import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'phone_auth_screen.dart';
import 'email_auth_screen.dart';

/// Authentication method selection screen
/// Allows users to choose between phone OTP and email/password authentication
class AuthSelectionScreen extends StatelessWidget {
  const AuthSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              // Logo
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 48,
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
              const SizedBox(height: 8),
              const Text(
                'Trusted work. Secure pay. Your record, forever.',
                style: TextStyle(
                  fontSize: 16,
                  color: WL.inkSoft,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 60),
              // Heading
              const Text(
                'How would you like to sign in?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: WL.ink,
                ),
              ),
              const SizedBox(height: 32),
              // Phone Authentication Option
              _AuthMethodCard(
                icon: Icons.phone,
                title: 'Phone Number',
                subtitle: 'Sign in with your phone number via OTP',
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const PhoneAuthScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Email Authentication Option
              _AuthMethodCard(
                icon: Icons.email,
                title: 'Email Address',
                subtitle: 'Sign up or sign in with email and password',
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const EmailAuthScreen(),
                  ),
                ),
              ),
              const Spacer(),
              // Terms and Privacy
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      const Text(
                        'By continuing, you agree to our',
                        style: TextStyle(
                          fontSize: 12,
                          color: WL.inkSoft,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              // TODO: Open terms of service
                            },
                            child: const Text('Terms of Service'),
                          ),
                          const Text('and'),
                          TextButton(
                            onPressed: () {
                              // TODO: Open privacy policy
                            },
                            child: const Text('Privacy Policy'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable auth method card
class _AuthMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AuthMethodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: WL.silver,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: WL.copper.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: WL.copper,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: WL.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: WL.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: WL.copper,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
