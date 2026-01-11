import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_colors.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isSignUp = false;

  Future<void> _handleAuth() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();

    if (phone.isEmpty || password.isEmpty || (_isSignUp && username.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseFillAllFields)),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;

      if (_isSignUp) {
        // Check if user exists
        final existing = await supabase
            .from('users')
            .select()
            .or('phone.eq.$phone,username.eq.$username')
            .maybeSingle();

        if (existing != null) {
          throw AppLocalizations.of(context)!.userExists;
        }

        // Create new user
        final newUser = await supabase.from('users').insert({
          'username': username,
          'phone': phone,
          'password': password, // Note: Simplified for demonstration
        }).select().single();

        await _saveUserSession(newUser['id'], newUser['username']);

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        // Sign in
        final user = await supabase
            .from('users')
            .select()
            .eq('phone', phone)
            .eq('password', password)
            .maybeSingle();

        if (user == null) {
          throw AppLocalizations.of(context)!.invalidCredentials;
        }

        await _saveUserSession(user['id'], user['username']);

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorOccurred(e.toString())), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveUserSession(String userId, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
    await prefs.setString('username', username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.sports_soccer, size: 80, color: AppColors.primary),
              const SizedBox(height: 24),
              Text(
                _isSignUp ? AppLocalizations.of(context)!.createAccount : AppLocalizations.of(context)!.welcomeBack,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isSignUp ? AppLocalizations.of(context)!.joinCommunity : AppLocalizations.of(context)!.signInPrompt,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 40),
              
              if (_isSignUp) ...[
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.username,
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.phoneNumber,
                  hintText: AppLocalizations.of(context)!.phoneHint,
                  hintStyle: TextStyle(color: Colors.white24),
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.password,
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: _isLoading ? null : _handleAuth,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : Text(_isSignUp ? AppLocalizations.of(context)!.signUp : AppLocalizations.of(context)!.signIn),
              ),
              
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => setState(() => _isSignUp = !_isSignUp),
                child: Text(
                  _isSignUp
                      ? AppLocalizations.of(context)!.alreadyHaveAccount
                      : AppLocalizations.of(context)!.noAccount,
                  style: const TextStyle(color: AppColors.primary),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}


