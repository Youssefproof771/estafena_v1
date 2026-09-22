import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

import '../../theme/app_theme.dart';
import '../../widgets/avatar.dart';
import '../../widgets/page_header.dart';
import '../friends/models/friend_models.dart';
import 'models/settings_models.dart';

class SettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeToggle;

  const SettingsPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'en';

  late UserProfile _profile;

  late TextEditingController _nameController;
  late TextEditingController _handleController;
  late TextEditingController _bioController;
  late TextEditingController _instapayController;
  late TextEditingController _walletController;
  late TextEditingController _cardController;

  @override
  void initState() {
    super.initState();
    _profile = const UserProfile(
      name: 'Youssef Ashraf',
      handle: '@youssef',
      initials: 'YA',
      bio: 'Splitting bills and building products.',
      payments: PaymentMethods(
        instapay: 'youssef@instapay',
        wallet: '0100 000 0000',
        card: '',
      ),
    );

    _nameController = TextEditingController(text: _profile.name);
    _handleController = TextEditingController(text: _profile.handle);
    _bioController = TextEditingController(text: _profile.bio);
    _instapayController = TextEditingController(
      text: _profile.payments.instapay ?? '',
    );
    _walletController = TextEditingController(
      text: _profile.payments.wallet ?? '',
    );
    _cardController = TextEditingController(text: _profile.payments.card ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _handleController.dispose();
    _bioController.dispose();
    _instapayController.dispose();
    _walletController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _shareProfile() async {
    final handleClean = _handleController.text.replaceAll('@', '').trim();
    final shareUrl = 'https://estafena.app/u/$handleClean';
    final shareText = 'Pay ${_nameController.text} on Estafena: $shareUrl';

    try {
      await Share.share(shareText, subject: _nameController.text);
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: shareUrl));
      _showNotification('Profile link copied');
    }
  }

  void _saveChanges() {
    final updatedInitials = getInitials(_nameController.text);
    setState(() {
      _profile = _profile.copyWith(
        name: _nameController.text.trim(),
        handle: _handleController.text.trim(),
        initials: updatedInitials,
        bio: _bioController.text.trim(),
        payments: PaymentMethods(
          instapay: _instapayController.text.trim().isEmpty
              ? null
              : _instapayController.text.trim(),
          wallet: _walletController.text.trim().isEmpty
              ? null
              : _walletController.text.trim(),
          card: _cardController.text.trim().isEmpty
              ? null
              : _cardController.text.trim(),
        ),
      );
    });
    _showNotification('Profile saved');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final secondaryColor = isDark
        ? AppColors.secondaryDark
        : AppColors.secondary;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;
    final foregroundColor = isDark
        ? AppColors.foregroundDark
        : AppColors.foreground;
    final mutedForeground = isDark
        ? AppColors.mutedForegroundDark
        : AppColors.mutedForeground;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageHeader(
            title: 'Settings',
            subtitle: 'Profile, payments and preferences',
          ),

          // 1. Profile Preview Card + Share
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  AppAvatar(
                    initials: _profile.initials,
                    tone: AvatarTone.accent,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _profile.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: foregroundColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _profile.handle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _shareProfile,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.share2,
                            size: 14,
                            color: foregroundColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Share',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: foregroundColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Preferences (Language + Dark Theme Switch)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preferences',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: foregroundColor,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      // Language selector
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              LucideIcons.globe,
                              size: 16,
                              color: foregroundColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Language',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: foregroundColor,
                              ),
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedLanguage,
                              dropdownColor: surfaceColor,
                              borderRadius: BorderRadius.circular(12),
                              items: supportedLanguages.map((l) {
                                return DropdownMenuItem(
                                  value: l.code,
                                  child: Text(
                                    l.label,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: foregroundColor,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null)
                                  setState(() => _selectedLanguage = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 24, thickness: 1, color: borderColor),
                      // Dark Mode Switch
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              widget.isDarkMode
                                  ? LucideIcons.moon
                                  : LucideIcons.sun,
                              size: 16,
                              color: foregroundColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dark theme',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: foregroundColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.isDarkMode
                                      ? 'Dark mode is on'
                                      : 'Light mode is on',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: widget.isDarkMode,
                            activeColor: AppColors.accent,
                            onChanged: widget.onThemeToggle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Edit Profile
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: foregroundColor,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        label: 'Full name',
                        controller: _nameController,
                        secondaryColor: secondaryColor,
                        foregroundColor: foregroundColor,
                        mutedForeground: mutedForeground,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        label: 'Username',
                        controller: _handleController,
                        secondaryColor: secondaryColor,
                        foregroundColor: foregroundColor,
                        mutedForeground: mutedForeground,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        label: 'About you',
                        controller: _bioController,
                        secondaryColor: secondaryColor,
                        foregroundColor: foregroundColor,
                        mutedForeground: mutedForeground,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 4. Payment Methods
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment methods',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: foregroundColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'All optional. Friends see these when they open your profile.',
                  style: TextStyle(fontSize: 12, color: mutedForeground),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      _buildTextField(
                        label: 'InstaPay address',
                        icon: LucideIcons.smartphone,
                        hint: 'name@instapay',
                        controller: _instapayController,
                        secondaryColor: secondaryColor,
                        foregroundColor: foregroundColor,
                        mutedForeground: mutedForeground,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        label: 'Mobile wallet number',
                        icon: LucideIcons.wallet,
                        hint: '0100 000 0000',
                        controller: _walletController,
                        secondaryColor: secondaryColor,
                        foregroundColor: foregroundColor,
                        mutedForeground: mutedForeground,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        label: 'Prepaid card',
                        icon: LucideIcons.creditCard,
                        hint: '5321 0000 0000 0000',
                        controller: _cardController,
                        secondaryColor: secondaryColor,
                        foregroundColor: foregroundColor,
                        mutedForeground: mutedForeground,
                      ),
                    ],
                  ),
                ),

                // Save Changes Button
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _saveChanges,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: AppColors.accentGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Save changes',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF133B2E),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    IconData? icon,
    String? hint,
    required TextEditingController controller,
    required Color secondaryColor,
    required Color foregroundColor,
    required Color mutedForeground,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: mutedForeground),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: foregroundColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: TextStyle(fontSize: 14, color: foregroundColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: mutedForeground),
            filled: true,
            fillColor: secondaryColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
