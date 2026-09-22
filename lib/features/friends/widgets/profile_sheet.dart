import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/avatar.dart';
import '../models/friend_models.dart';

class PaymentMethodItem {
  final String key;
  final String label;
  final IconData icon;
  final String value;

  const PaymentMethodItem({
    required this.key,
    required this.label,
    required this.icon,
    required this.value,
  });
}

class PaymentMethodList extends StatelessWidget {
  final PaymentMethods payments;

  const PaymentMethodList({super.key, required this.payments});

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor = isDark
        ? AppColors.secondaryDark
        : AppColors.secondary;
    final foregroundColor = isDark
        ? AppColors.foregroundDark
        : AppColors.foreground;
    final mutedForeground = isDark
        ? AppColors.mutedForegroundDark
        : AppColors.mutedForeground;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;

    final List<PaymentMethodItem> available = [
      if (payments.instapay != null)
        PaymentMethodItem(
          key: 'instapay',
          label: 'InstaPay',
          icon: LucideIcons.smartphone,
          value: payments.instapay!,
        ),
      if (payments.wallet != null)
        PaymentMethodItem(
          key: 'wallet',
          label: 'Mobile wallet',
          icon: LucideIcons.wallet,
          value: payments.wallet!,
        ),
      if (payments.card != null)
        PaymentMethodItem(
          key: 'card',
          label: 'Prepaid card',
          icon: LucideIcons.creditCard,
          value: payments.card!,
        ),
    ];

    if (available.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          'No payment methods shared yet',
          style: TextStyle(fontSize: 13, color: mutedForeground),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: available.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, thickness: 1, color: borderColor),
        itemBuilder: (context, index) {
          final item = available[index];

          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    item.icon,
                    size: 16,
                    color: const Color(0xFF133B2E),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: TextStyle(fontSize: 11, color: mutedForeground),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        item.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: foregroundColor,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      _copyToClipboard(context, item.value, item.label),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      LucideIcons.copy,
                      size: 16,
                      color: foregroundColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfileSheet extends StatelessWidget {
  final ProfileView person;

  const ProfileSheet({super.key, required this.person});

  static Future<void> show(
    BuildContext context, {
    required ProfileView person,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => ProfileSheet(person: person),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final foregroundColor = isDark
        ? AppColors.foregroundDark
        : AppColors.foreground;
    final mutedForeground = isDark
        ? AppColors.mutedForegroundDark
        : AppColors.mutedForeground;

    return Dialog(
      backgroundColor: surfaceColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 384),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  AppAvatar(initials: person.initials, tone: AvatarTone.accent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          person.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: foregroundColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          person.handle,
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
                ],
              ),
              const SizedBox(height: 14),

              // Optional Balance Indicator
              if (person.balance != null) ...[
                Text(
                  person.balance == 0
                      ? 'All settled'
                      : person.balance! > 0
                      ? 'Owes you ${formatCurrency(person.balance!)}'
                      : 'You owe ${formatCurrency(-person.balance!)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: person.balance! > 0
                        ? AppColors.positive
                        : person.balance! < 0
                        ? AppColors.negative
                        : mutedForeground,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Payment Methods Section
              Text(
                'Payment methods',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor,
                ),
              ),
              const SizedBox(height: 10),
              PaymentMethodList(payments: person.payments),
            ],
          ),
        ),
      ),
    );
  }
}
