import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback onSignupSuccess;

  const SignupPage({super.key, required this.onSignupSuccess});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _handleController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _handleController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onSignupSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;
    final foregroundColor = isDark
        ? AppColors.foregroundDark
        : AppColors.foreground;
    final mutedForeground = isDark
        ? AppColors.mutedForegroundDark
        : AppColors.mutedForeground;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 448),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Hero Header
                Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.heroGradient,
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 56, 24, 44),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ESTAFENA',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 3.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Create your account',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Takes less than a minute.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Form Body (rounded-t-[2rem] -mt-8)
                Transform.translate(
                  offset: const Offset(0, -32),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildInputField(
                          label: 'Full name',
                          hint: 'Youssef Ashraf',
                          controller: _nameController,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                          foregroundColor: foregroundColor,
                          mutedForeground: mutedForeground,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          label: 'Username',
                          hint: '@youssef',
                          controller: _handleController,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                          foregroundColor: foregroundColor,
                          mutedForeground: mutedForeground,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          label: 'Email',
                          hint: 'you@example.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                          foregroundColor: foregroundColor,
                          mutedForeground: mutedForeground,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          label: 'Password',
                          hint: '••••••••',
                          controller: _passwordController,
                          isPassword: true,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                          foregroundColor: foregroundColor,
                          mutedForeground: mutedForeground,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          label: 'Confirm password',
                          hint: '••••••••',
                          controller: _confirmPasswordController,
                          isPassword: true,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                          foregroundColor: foregroundColor,
                          mutedForeground: mutedForeground,
                        ),
                        const SizedBox(height: 16),

                        // Checkbox agreement
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Checkbox(
                                value: _agreedToTerms,
                                activeColor: AppColors.accent,
                                checkColor: const Color(0xFF133B2E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (v) =>
                                    setState(() => _agreedToTerms = v ?? false),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'I agree to the terms and privacy policy.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: mutedForeground,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Submit Button
                        GestureDetector(
                          onTap: _submit,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              gradient: AppColors.accentGradient,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Create account',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF133B2E),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Log in link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontSize: 13,
                                color: mutedForeground,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Text(
                                'Log in',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: foregroundColor,
                                ),
                              ),
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
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required Color surfaceColor,
    required Color borderColor,
    required Color foregroundColor,
    required Color mutedForeground,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: mutedForeground,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            style: TextStyle(fontSize: 14, color: foregroundColor),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 14, color: mutedForeground),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              filled: false,
            ),
          ),
        ),
      ],
    );
  }
}
