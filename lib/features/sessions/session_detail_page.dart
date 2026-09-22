import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/app_theme.dart';
import '../friends/models/friend_models.dart';
import '../friends/widgets/profile_sheet.dart';
import 'models/session_models.dart';

class SessionDetailPage extends StatefulWidget {
  final Session session;
  final bool isLocal;

  const SessionDetailPage({
    super.key,
    required this.session,
    this.isLocal = false,
  });

  @override
  State<SessionDetailPage> createState() => _SessionDetailPageState();
}

class _SessionDetailPageState extends State<SessionDetailPage> {
  void _showToast(String message) {
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

  void _openProfile(String name) {
    ProfileSheet.show(
      context,
      person: ProfileView(
        name: name,
        handle: '@${name.toLowerCase().replaceAll(' ', '')}',
        initials: name.length >= 2 ? name.substring(0, 2).toUpperCase() : name,
        payments: const PaymentMethods(instapay: 'user@instapay'),
      ),
    );
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

    final balances = computeBalances(widget.session);
    final total = widget.session.totalAmount;

    // Identify user's own share ("You", "Me", or specific first name)
    final myBalance = balances.firstWhere(
      (b) => b.name == 'You' || b.name == 'Me' || b.name.startsWith('Youssef'),
      orElse: () => const PersonBalance(name: 'You', paid: 0, owed: 0),
    );
    final myNet = myBalance.net;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Hero Header
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(
                20,
                kToolbarHeight - 8,
                20,
                28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.arrowLeft,
                          size: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.session.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.session.place} · ${widget.session.date} · ${widget.session.members.length} people',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    formatCurrency(total),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Session total',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Action Buttons ("Add item" & "Scan bill")
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showToast('Add item — coming next'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.plus,
                              size: 16,
                              color: Color(0xFF133B2E),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Add item',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF133B2E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showToast(
                        widget.isLocal
                            ? 'Scanning works offline too'
                            : 'Bill scanning is experimental',
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.scanLine,
                              size: 16,
                              color: foregroundColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Scan bill',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: foregroundColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. Items Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Items',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: foregroundColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.session.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = widget.session.items[index];

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: foregroundColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  formatCurrency(item.price),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: foregroundColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 12,
                                  color: mutedForeground,
                                ),
                                children: [
                                  const TextSpan(text: 'Paid by '),
                                  TextSpan(
                                    text: item.buyer,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: foregroundColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' · ${formatCurrency(item.perPersonShare)} each',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: item.consumers.map((c) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    c,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: foregroundColor,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // 4. "Who Owes What" Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Who owes what',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: foregroundColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: balances.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, thickness: 1, color: borderColor),
                      itemBuilder: (context, index) {
                        final b = balances[index];
                        final isGets = b.net > 0.01;
                        final isOwes = b.net < -0.01;

                        return InkWell(
                          onTap: () => _openProfile(b.name),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        b.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: foregroundColor,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'paid ${formatCurrency(b.paid)} · share ${formatCurrency(b.owed)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: mutedForeground,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  isGets
                                      ? 'gets ${formatCurrency(b.net)}'
                                      : isOwes
                                      ? 'owes ${formatCurrency(-b.net)}'
                                      : 'even',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isGets
                                        ? AppColors.positive
                                        : isOwes
                                        ? AppColors.negative
                                        : mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Settle Banner / Button
                  const SizedBox(height: 16),
                  if (myNet < -0.01)
                    GestureDetector(
                      onTap: () => _showToast(
                        'Estafena — you paid ${formatCurrency(-myNet)}',
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Estafena · pay ${formatCurrency(-myNet)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF133B2E),
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'You owe nothing here — waiting for the others to press Estafena',
                        style: TextStyle(fontSize: 12, color: mutedForeground),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
