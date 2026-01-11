import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/app_colors.dart';
import 'admin_requests_screen.dart';

class AdminReportScreen extends StatefulWidget {
  const AdminReportScreen({super.key});

  @override
  State<AdminReportScreen> createState() => _AdminReportScreenState();
}

class _AdminReportScreenState extends State<AdminReportScreen> {
  DateTime _startOfWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  List<Map<String, dynamic>> _weeklyBookings = [];
  bool _isLoading = true;

  // Times from 3 PM (15:00) to 2 AM (26:00)
  // We represent hours past midnight as 24, 25, 26, etc. for sorting/display logic
  final List<int> _hours = List.generate(12, (index) => 15 + index); // 15 to 26

  @override
  void initState() {
    super.initState();
    _fetchWeeklyReport();
  }

  Future<void> _fetchWeeklyReport() async {
    setState(() => _isLoading = true);
    final DateTime endOfWeek = _startOfWeek.add(const Duration(days: 7));

    try {
      final response = await Supabase.instance.client
          .from('bookings')
          .select('*, users(username, phone)')
          .gte('start_time', DateTime(_startOfWeek.year, _startOfWeek.month, _startOfWeek.day).toIso8601String())
          .lt('start_time', DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day).toIso8601String())
          .order('start_time', ascending: true);

      setState(() {
        _weeklyBookings = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching report: $e');
      setState(() => _isLoading = false);
    }
  }

  void _changeWeek(int delta) {
    setState(() {
      _startOfWeek = _startOfWeek.add(Duration(days: delta * 7));
    });
    _fetchWeeklyReport();
  }

  // Helper to format hour labels (e.g., 25 -> 1 AM)
  String _formatHour(int hour) {
    int h = hour % 24;
    final dt = DateTime(2024, 1, 1, h);
    return DateFormat('h a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final DateTime endOfWeek = _startOfWeek.add(const Duration(days: 6));
    final dateRange = "${DateFormat('MMM d').format(_startOfWeek)} - ${DateFormat('MMM d, y').format(endOfWeek)}";

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Professional Dark Grey
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.weeklyMatrixReport),
        backgroundColor: const Color(0xFF2C2C2C),
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminRequestsScreen()),
                  ).then((_) => _fetchWeeklyReport());
                },
              ),
              // We could add a badge here if we tracked pending count
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchWeeklyReport,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildWeekPicker(dateRange),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _buildProfessionalSchedule(),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekPicker(String range) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF2C2C2C),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white70),
            onPressed: () => _changeWeek(-1),
          ),
          const SizedBox(width: 16),
          Text(
            range,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white70),
            onPressed: () => _changeWeek(1),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalSchedule() {
    // Determine cell dimensions
    const double timeColumnWidth = 70.0;
    const double slotWidth = 110.0;
    const double rowHeight = 60.0;
    const double headerHeight = 60.0;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Time Column (Left Side) - Vertical List of times
          SizedBox(
            width: timeColumnWidth,
            child: Column(
              children: [
                // Corner Label
                Container(
                  height: headerHeight,
                  color: const Color(0xFF2C2C2C),
                  alignment: Alignment.center,
                  child: const Text('Time', style: TextStyle(color: Colors.white54, fontSize: 12)),
                ),
                // Time Labels
                ..._hours.map((h) => Container(
                  height: rowHeight,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2C2C),
                    border: Border(bottom: BorderSide(color: Colors.white10)),
                  ),
                  child: Text(
                    _formatHour(h),
                    style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                )),
              ],
            ),
          ),
          
          // 2. Schedule Grid (Right Side) - Horizontal Scroll + Rows of Days
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Days Header Row
                  Row(
                    children: List.generate(7, (index) {
                      final dayDate = _startOfWeek.add(Duration(days: index));
                      final isToday = DateUtils.isSameDay(dayDate, DateTime.now());
                      return Container(
                        width: slotWidth,
                        height: headerHeight,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isToday ? AppColors.primary.withOpacity(0.1) : const Color(0xFF252525),
                          border: const Border(
                            bottom: BorderSide(color: Colors.white10),
                            right: BorderSide(color: Colors.white10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('E').format(dayDate),
                              style: TextStyle(
                                color: isToday ? AppColors.primary : Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              DateFormat('d/M').format(dayDate),
                              style: TextStyle(
                                color: isToday ? AppColors.primary.withOpacity(0.8) : Colors.white38,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  
                  // Grid Rows (Each row is One Hour, containing 7 columns for days)
                  ..._hours.map((h) {
                    return Row(
                      children: List.generate(7, (dayIndex) {
                        final dayDate = _startOfWeek.add(Duration(days: dayIndex));
                        
                        // Handle crossing midnight (0, 1, 2 AM belong to 'next day' date-wise)
                        DateTime targetDate = dayDate;
                        int targetHour = h;
                        if (h >= 24) {
                          targetDate = dayDate.add(const Duration(days: 1));
                          targetHour = h - 24;
                        }

                        final slotStartTime = DateTime(targetDate.year, targetDate.month, targetDate.day, targetHour);
                        final booking = _findBooking(slotStartTime);

                        return _buildSlotCell(booking, slotWidth, rowHeight);
                      }),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotCell(Map<String, dynamic>? booking, double width, double height) {
    if (booking == null) {
      return Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white10),
            right: BorderSide(color: Colors.white10),
          ),
        ),
      );
    }

    final status = booking['status'] ?? 'pending';
    final isConfirmed = status == 'confirmed';
    final teamName = booking['team_name'] ?? '';
    final userData = booking['users'] as Map<String, dynamic>?;
    final phone = userData?['phone'] ?? '';

    // Confirmed -> Green, Pending -> Amber/Brown
    final bgColor = isConfirmed ? const Color(0xFF1E3A28) : const Color(0xFF4A3B28);
    final borderColor = isConfirmed ? AppColors.primary : Colors.orangeAccent;
    final textColor = isConfirmed ? AppColors.primary : Colors.orangeAccent;

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white10),
          right: BorderSide(color: Colors.white10),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showBookingActionDialog(booking),
          borderRadius: BorderRadius.circular(4),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: borderColor, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teamName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                Text(
                   phone,
                   maxLines: 1,
                   overflow: TextOverflow.ellipsis,
                   style: const TextStyle(color: Colors.white70, fontSize: 9),
                ),
                if (!isConfirmed)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.info_outline, size: 10, color: borderColor),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBookingActionDialog(Map<String, dynamic> b) {
    final status = b['status'] ?? 'pending';
    final isConfirmed = status == 'confirmed';
    final teamName = b['team_name'];
    final startTime = DateTime.parse(b['start_time']);
    final timeStr = DateFormat('EEEE d/M h:mm a').format(startTime);

    if (isConfirmed) {
      // Manage / Delete
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: Text(AppLocalizations.of(context)!.manageBooking, style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$teamName', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Text(timeStr, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.cancelBookingWarning, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.close, style: const TextStyle(color: Colors.white54)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => _deleteBooking(b['id']),
              icon: const Icon(Icons.delete, size: 16),
              label: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        ),
      );
    } else {
      // Approve / Reject
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: Text(AppLocalizations.of(context)!.pendingRequest, style: const TextStyle(color: Colors.white)),
          content: Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text('$teamName', style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 16)),
               const SizedBox(height: 8),
               Text(timeStr, style: const TextStyle(color: Colors.white70)),
               const SizedBox(height: 16),
               Text(AppLocalizations.of(context)!.adminRequestReviewMessage, style: const TextStyle(color: Colors.white54, fontSize: 12)),
             ],
          ),
          actions: [
            OutlinedButton(
               style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent)),
               onPressed: () => _rejectBooking(b['id']),
               child: Text(AppLocalizations.of(context)!.reject, style: const TextStyle(color: Colors.redAccent)),
            ),
            ElevatedButton(
               style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
               onPressed: () => _approveBooking(b['id']),
               child: Text(AppLocalizations.of(context)!.approve),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _approveBooking(String id) async {
    Navigator.pop(context);
    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client
          .from('bookings')
          .update({'status': 'confirmed'})
          .eq('id', id);
      _fetchWeeklyReport();
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _rejectBooking(String id) async {
    // Rejection currently deletes the booking
    _deleteBooking(id); 
  }

  Future<void> _deleteBooking(String id) async {
    // Check if dialog is open (it usually is)
    if (Navigator.canPop(context)) Navigator.pop(context);
    
    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client
          .from('bookings')
          .delete()
          .eq('id', id);
      _fetchWeeklyReport();
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String msg) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $msg')));
  }

  Map<String, dynamic>? _findBooking(DateTime startTime) {
    try {
      return _weeklyBookings.firstWhere(
        (b) => DateTime.parse(b['start_time']).isAtSameMomentAs(startTime),
      );
    } catch (_) {
      return null;
    }
  }
}
