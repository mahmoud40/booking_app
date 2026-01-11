import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../models/booking.dart';
import 'login_screen.dart';
import 'admin_report_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  List<Booking> _bookings = [];
  bool _isLoading = true;
  String? _currentUserId;
  String? _currentUsername;
  String? _userRole;
  final String _pitchId = '00000000-0000-0000-0000-000000000000';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _loadSession();
    await _fetchBookings();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _currentUserId = prefs.getString('user_id');
        _currentUsername = prefs.getString('username');
      });
    }

    if (_currentUserId != null) {
      try {
        final res = await Supabase.instance.client
            .from('users')
            .select('role')
            .eq('id', _currentUserId!)
            .maybeSingle();
        if (mounted && res != null) {
          setState(() => _userRole = res['role']);
        }
      } catch (e) {
        debugPrint('Error loading role: $e');
      }
    }
  }

  Future<void> _fetchBookings() async {
    setState(() => _isLoading = true);
    try {
      // Fetch bookings for the selected day AND the early morning of the next day (up to 4 AM)
      // because our "business day" runs late.
      final start = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
      final end = start.add(const Duration(days: 1, hours: 4)); 

      final response = await Supabase.instance.client
          .from('bookings')
          .select()
          .gte('start_time', start.toIso8601String())
          .lt('start_time', end.toIso8601String());

      setState(() {
        _bookings = (response as List).map((json) => Booking.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching bookings: $e');
      setState(() => _isLoading = false);
    }
  }

  List<TimeSlot> _generateSlots() {
    final List<TimeSlot> slots = [];
    final DateTime dayStart = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      15, // 3 PM
    );

    // Generate 12 slots: 3 PM (15:00) to 2 AM (26:00)
    for (int i = 0; i < 12; i++) {
      final slotTime = dayStart.add(Duration(hours: i));
      final endTime = slotTime.add(const Duration(hours: 1));
      
      final booking = _bookings.firstWhere(
        (b) => b.startTime.isAtSameMomentAs(slotTime),
        orElse: () => Booking(id: '', userId: '', pitchId: '', startTime: slotTime, endTime: endTime, totalPrice: 0, teamName: '', status: ''),
      );

      slots.add(TimeSlot(time: slotTime, booking: booking.id.isEmpty ? null : booking));
    }
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    final slots = _generateSlots();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.mainStadium, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              DateFormat('EEEE, MMMM d').format(_selectedDate),
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month, color: AppColors.primary),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                lastDate: DateTime.now().add(const Duration(days: 90)),
              );
              if (date != null) {
                setState(() => _selectedDate = date);
                _fetchBookings();
              }
            },
          ),
          if (_currentUserId != null) ...[
            if (_userRole == 'admin')
              IconButton(
                icon: const Icon(Icons.bar_chart, color: Colors.blueAccent),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AdminReportScreen()),
                  );
                },
              ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white70),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                }
              },
            ),
          ]
          else
            IconButton(
              icon: const Icon(Icons.login, color: AppColors.primary),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchBookings,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 12),
                    _buildCallInstruction(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: slots.length,
                        itemBuilder: (context, index) {
                          return _buildSlotCard(slots[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.sportyGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.black),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.operationsInfo,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotCard(TimeSlot slot) {
    final isBooked = slot.isBooked;
    final isPending = isBooked && slot.booking!.status == 'pending';
    
    // Check cancellation rule:
    // User can cancel if they are the owner AND it is more than 1 hour before the start time.
    // Admin can always cancel.
    bool canCancel = false;
    if (isBooked) {
        final isOwner = slot.booking!.userId == _currentUserId;
        final isAdmin = _userRole == 'admin';
        // Check if booking is in the future by at least 60 minutes
        final timeToStart = slot.booking!.startTime.difference(DateTime.now());
        
        if (isAdmin) {
            canCancel = true;
        } else if (isOwner) {
            canCancel = timeToStart.inMinutes >= 60;
        }
    }

    return Container(
      decoration: BoxDecoration(
        color: isBooked 
            ? (isPending ? Colors.orange.withAlpha(50) : AppColors.surface.withAlpha(128)) 
            : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isBooked 
              ? (isPending ? Colors.orange.withAlpha(100) : Colors.transparent) 
              : AppColors.primary.withAlpha(77),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: isBooked 
          ? (canCancel ? () => _showCancelDialog(slot.booking!) : null)
          : () => _showBookingDialog(slot),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                slot.timeString,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isBooked ? AppColors.textSecondary : AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              if (isBooked) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isPending ? "${slot.booking!.teamName} (${AppLocalizations.of(context)!.pendingStatus})" : slot.booking!.teamName,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isPending ? Colors.orangeAccent : Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (canCancel)
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(AppLocalizations.of(context)!.tapToCancel, style: TextStyle(color: Colors.white38, fontSize: 10)),
                  ),
              ] else
                Text(
                  AppLocalizations.of(context)!.available,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBookingDialog(TimeSlot slot) {
    if (_currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.loginToBook)),
      );
      return;
    }

    final teamController = TextEditingController(text: _currentUsername);
    bool isRecurring = false;
    int weeks = 4;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(AppLocalizations.of(context)!.bookSlot(slot.timeString), style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: teamController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.teamName,
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.repeatWeekly, style: TextStyle(color: Colors.white)),
                  value: isRecurring,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    setDialogState(() => isRecurring = val);
                  },
                ),
                if (isRecurring) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(AppLocalizations.of(context)!.weeksLabel, style: TextStyle(color: Colors.white)),
                      Expanded(
                        child: Slider(
                          value: weeks.toDouble(),
                          min: 2,
                          max: 12,
                          divisions: 10,
                          label: AppLocalizations.of(context)!.weeksCount(weeks),
                          activeColor: AppColors.primary,
                          onChanged: (val) {
                            setDialogState(() => weeks = val.toInt());
                          },
                        ),
                      ),
                      Text('$weeks', style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () => _handleBooking(slot, teamController.text, isRecurring, weeks),
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleBooking(TimeSlot slot, String teamName, bool isRecurring, int weeks) async {
    if (teamName.isEmpty) return;
    if (_currentUserId == null) return;

    Navigator.pop(context); // Close dialog
    setState(() => _isLoading = true);

    try {
      final String? pitchId = await _getPitchId();
      if (pitchId == null) throw 'Pitch not found';

      final List<Map<String, dynamic>> bookingData = [];
      final String recurringGroupId = const Uuid().v4();
      final List<DateTime> datesToBook = [];
      final List<String> takenDates = [];

      int count = isRecurring ? weeks : 1;
      for (int i = 0; i < count; i++) {
        datesToBook.add(slot.time.add(Duration(days: i * 7)));
      }

      // Check availability for all dates
      for (var date in datesToBook) {
        final existing = await Supabase.instance.client
            .from('bookings')
            .select()
            .eq('start_time', date.toIso8601String())
            .maybeSingle();
        
        if (existing != null) {
          takenDates.add(DateFormat('MMM d').format(date));
          continue; // Skip this date
        }

        bookingData.add({
          'user_id': _currentUserId,
          'pitch_id': pitchId,
          'start_time': date.toIso8601String(),
          'end_time': date.add(const Duration(hours: 1)).toIso8601String(),
          'total_price': 100,
          'team_name': teamName,
          'status': _userRole == 'admin' ? 'confirmed' : 'pending',
          'is_recurring': isRecurring,
          'recurring_group_id': isRecurring ? recurringGroupId : null,
        });
      }

      if (bookingData.isEmpty) {
        throw AppLocalizations.of(context)!.allDatesTaken;
      }

      await Supabase.instance.client.from('bookings').insert(bookingData);

      if (mounted) {
        String msg = _userRole == 'admin' 
            ? AppLocalizations.of(context)!.bookingConfirmed(bookingData.length)
            : AppLocalizations.of(context)!.bookingRequestSent;
            
        if (takenDates.isNotEmpty) {
          msg += AppLocalizations.of(context)!.skippedDates(takenDates.join(", "));
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            duration: const Duration(seconds: 5),
            backgroundColor: takenDates.isNotEmpty ? Colors.orange : Colors.green,
          ),
        );
        _fetchBookings();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorOccurred(e.toString())), backgroundColor: Colors.red),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Future<String?> _getPitchId() async {
    try {
      final response = await Supabase.instance.client.from('pitches').select('id').limit(1).maybeSingle();
      if (response != null && response['id'] != null) {
        return response['id'] as String?;
      }
      // If no pitch is found, return a default UUID as a fallback
      // This matches the default pitch seeded in our SQL schema
      return '00000000-0000-0000-0000-000000000000';
    } catch (e) {
      debugPrint('Pitch lookup error: $e');
      return '00000000-0000-0000-0000-000000000000';
    }
  }

  void _showCancelDialog(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(AppLocalizations.of(context)!.cancelBookingTitle, style: TextStyle(color: Colors.white)),
        content: Text(
          AppLocalizations.of(context)!.cancelBookingMessage(booking.teamName, DateFormat('h:mm a').format(booking.startTime)),
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.no, style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              
              // Optimistic update
              setState(() {
                _bookings.removeWhere((b) => b.id == booking.id);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.bookingCancelled)),
              );

              try {
                await Supabase.instance.client
                    .from('bookings')
                    .delete()
                    .eq('id', booking.id);
                
                // No need to fetch if successful, local state is already correct
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)!.errorOccurred(e.toString())), backgroundColor: Colors.red),
                  );
                  // Revert by fetching real state
                  _fetchBookings(); 
                }
              }
            },
            child: Text(AppLocalizations.of(context)!.yesCancel),
          ),
        ],
      ),
    );
  }

  Widget _buildCallInstruction() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface.withAlpha(180),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withAlpha(50)),
      ),
      child: InkWell(
        onTap: () => launchUrl(Uri.parse('tel:01023783968')),
        child: Row(
          children: [
            const Icon(Icons.phone_in_talk, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.supportCall,
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white.withAlpha(100), size: 12),
          ],
        ),
      ),
    );
  }
}



