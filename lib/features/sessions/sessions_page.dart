import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/app_theme.dart';
import '../../widgets/page_header.dart';
import '../friends/models/friend_models.dart';
import 'models/session_models.dart';
import 'session_detail_page.dart';

class SessionsPage extends StatelessWidget {
  final List<Session> sessions;

  const SessionsPage({
    super.key,
    this.sessions = const [
      Session(
        id: 's1',
        title: 'Dinner Gathering',
        place: 'Crave',
        date: 'Tonight',
        status: 'open',
        members: ['You', 'Omar', 'Kareem', 'Ahmed'],
        items: [
          SessionItem(
            id: 'i1',
            name: 'Ribeye Steak',
            price: 620,
            buyer: 'You',
            consumers: ['You', 'Omar'],
          ),
          SessionItem(
            id: 'i2',
            name: 'Alfredo Pasta',
            price: 340,
            buyer: 'Omar',
            consumers: ['Kareem', 'Ahmed'],
          ),
          SessionItem(
            id: 'i3',
            name: 'Appetizer Platter',
            price: 290,
            buyer: 'You',
            consumers: ['You', 'Omar', 'Kareem', 'Ahmed'],
          ),
        ],
      ),
      Session(
        id: 's2',
        title: 'Padel Court',
        place: 'The Padel Club',
        date: 'Yesterday',
        status: 'open',
        members: ['You', 'Omar', 'Seif', 'Nour'],
        items: [
          SessionItem(
            id: 'i4',
            name: 'Court booking (90 mins)',
            price: 800,
            buyer: 'Omar',
            consumers: ['You', 'Omar', 'Seif', 'Nour'],
          ),
        ],
      ),
      Session(
        id: 's3',
        title: 'Cinema & Snacks',
        place: 'VOX Cinemas',
        date: 'Last weekend',
        status: 'closed',
        members: ['You', 'Farah', 'Ziad'],
        items: [
          SessionItem(
            id: 'i5',
            name: 'Tickets x3',
            price: 450,
            buyer: 'You',
            consumers: ['You', 'Farah', 'Ziad'],
          ),
          SessionItem(
            id: 'i6',
            name: 'Popcorn Combo',
            price: 220,
            buyer: 'Farah',
            consumers: ['You', 'Farah'],
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
            title: 'Sessions',
            subtitle: 'Shared online with your friends',
          ),

          // Action Buttons: "New" & "Scan bill"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showToast(
                      context,
                      'New session — coming with accounts',
                    ),
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
                            'New',
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
                    onTap: () =>
                        _showToast(context, 'Scanning a bill is experimental'),
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
                          const SizedBox(width: 8),
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

          // Session Cards List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            itemCount: sessions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final session = sessions[index];
              final isOpen = session.status == 'open';

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => SessionDetailPage(session: session),
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
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  '${session.place} · ${session.date}',
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isOpen
                                  ? AppColors.accent.withValues(alpha: 0.25)
                                  : secondaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isOpen ? 'Open' : 'Settled',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isOpen
                                    ? const Color(0xFF133B2E)
                                    : mutedForeground,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Overlapping member avatars
                          SizedBox(
                            height: 28,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(session.members.length, (
                                i,
                              ) {
                                final name = session.members[i];
                                final initials = name.length >= 2
                                    ? name.substring(0, 2)
                                    : name;

                                return Align(
                                  widthFactor: 0.72,
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: secondaryColor,
                                      border: Border.all(
                                        color: surfaceColor,
                                        width: 2,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      initials,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: foregroundColor,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
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
