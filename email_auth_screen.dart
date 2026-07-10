import 'package:flutter/material.dart';

import '../core/supabase.dart';
import '../core/theme.dart';
import '../models/models.dart';
import '../services/services.dart';

/// Email-based authentication screen
/// Supports both sign-up and sign-in flows
class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({super.key});
  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _isSignUp = false;
  bool _obscurePassword = true;
  bool _busy = false;
  String? _error;

  Future<void> _run(Future<void> Function() fn) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await fn();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _handleSignUp() async {
    if (_password.text != _confirmPassword.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }
    if (_password.text.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters');
      return;
    }

    await _run(() async {
      await _auth.signUpWithEmail(
        _email.text.trim(),
        _password.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        ),
      );
    });
  }

  Future<void> _handleSignIn() async {
    await _run(() async {
      await _auth.signInWithEmail(
        _email.text.trim(),
        _password.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: WL.ink,
                      fontFamily: 'Archivo',
                    ),
                    children: [
                      TextSpan(text: 'Work'),
                      TextSpan(
                        text: 'Link',
                        style: TextStyle(color: WL.copper),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Trusted work. Secure pay. Your record, forever.',
                  style: TextStyle(color: WL.inkSoft),
                ),
                const SizedBox(height: 36),
                Text(
                  _isSignUp ? 'Create Account' : 'Sign In',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: WL.ink,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                    hintText: 'you@example.com',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _password,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'At least 6 characters',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                    ),
                  ),
                ),
                if (_isSignUp) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: _confirmPassword,
                    obscureText: _obscurePassword,
                    decoration: const InputDecoration(
                      labelText: 'Confirm password',
                      hintText: 'Re-enter your password',
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _busy
                        ? null
                        : (_isSignUp ? _handleSignUp : _handleSignIn),
                    child: Text(
                      _isSignUp ? 'Create Account' : 'Sign In',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _busy
                        ? null
                        : () => setState(() => _isSignUp = !_isSignUp),
                    child: Text(
                      _isSignUp
                          ? 'Already have an account? Sign in'
                          : 'Don\'t have an account? Create one',
                    ),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: WL.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: WL.red),
                    ),
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        color: WL.red,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Or continue with phone number',
                        style: TextStyle(
                          fontSize: 13,
                          color: WL.inkSoft,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const PhoneAuthScreen(),
                          ),
                        ),
                        child: const Text('Use phone number instead'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }
}

/// Import PhoneAuthScreen for reference
// The OnboardingScreen is already defined in phone_auth_screen.dart
