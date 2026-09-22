import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum AvatarTone { muted, accent }

class AppAvatar extends StatelessWidget {
  final String initials;
  final AvatarTone tone;
  final double size;

  const AppAvatar({
    super.key,
    required this.initials,
    this.tone = AvatarTone.muted,
    this.size = 44.0, // Matches h-11 w-11
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryBg = isDark ? AppColors.secondaryDark : AppColors.secondary;
    final secondaryFg = isDark ? AppColors.secondaryForegroundDark : AppColors.secondaryForeground;

    final isAccent = tone == AvatarTone.accent;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // rounded-2xl
        gradient: isAccent ? AppColors.accentGradient : null,
        color: isAccent ? null : secondaryBg,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isAccent ? const Color(0xFF133B2E) : secondaryFg,
        ),
      ),
    );
  }
}