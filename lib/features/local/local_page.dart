import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/app_theme.dart';
import '../../widgets/page_header.dart';
import '../friends/models/friend_models.dart';
import '../sessions/models/session_models.dart';
import '../sessions/session_detail_page.dart';

class LocalPage extends StatelessWidget {
  final List<Session> localSessions;

  const LocalPage({
    super.key,
    this.localSessions = const [
      Session(
        id: 'ls1',
        title: 'Work Lunch',
        place: 'Office Cafeteria',
        date: 'Today',
        status: 'open',
        members: ['You', 'Alex', 'Sarah'],
        items: [
          SessionItem(
            id: 'li1',
            name: 'Burgers x3',
            price: 450,
            buyer: 'You',
            consumers: ['You', 'Alex', 'Sarah'],
          ),
          SessionItem(
            id: 'li2',
            name: 'Fries & Drinks',
            price: 180,
            buyer: 'You',
            consumers: ['Alex', 'Sarah'],
          ),
        ],
      ),
      Session(
        id: 'ls2',
        title: 'Roadtrip Snacks',
        place: 'Gas Station',
        date: '3 days ago',
        status: 'open',
        members: ['You', 'Guest 1', 'Guest 2', 'Guest 3'],
        items: [
          SessionItem(
            id: 'li3',
            name: 'Energy Drinks & Chips',
            price: 320,
            buyer: 'Guest 1',
            consumers: ['You', 'Guest 1', 'Guest 2', 'Guest 3'],
          ),
        ],
      ),
    ],
  });

  void _showToast(BuildContext context, String message) {
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
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageHeader(
            title: 'Local splits',
            subtitle: 'Saved on this phone only',
          ),

          // Offline Disclaimer Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    LucideIcons.smartphone,
                    size: 16,
                    color: mutedForeground,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No account needed. Add guests by name and split instantly — works with no internet.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: mutedForeground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons: "New split" & "Add guest"
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showToast(context, 'New local split'),
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
                          SizedBox(width: 8),
                          Text(
                            'New split',
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
                    onTap: () => _showToast(context, 'Guest added'),
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
                            LucideIcons.userPlus,
                            size: 16,
                            color: foregroundColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Add guest',
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

          // Local Splits List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            itemCount: localSessions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final session = localSessions[index];

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) =>
                          SessionDetailPage(session: session, isLocal: true),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: foregroundColor,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${session.members.length} people · ${session.date}',
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
                      const SizedBox(width: 8),
                      Text(
                        formatCurrency(session.totalAmount),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: foregroundColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
