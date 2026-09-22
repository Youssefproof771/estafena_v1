import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/app_theme.dart';
import '../../widgets/avatar.dart';
import '../friends/models/friend_models.dart';
import '../friends/widgets/profile_sheet.dart';
import '../sessions/models/session_models.dart';
import 'models/home_models.dart';

class HomePage extends StatefulWidget {
  final void Function(int tabIndex)? onNavigateTab;

  const HomePage({super.key, this.onNavigateTab});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Mock current user
  final String userName = 'Youssef Ashraf';
  final String userInitials = 'YA';

  // Metrics
  final double totalOwedToMe = 1450.0;
  final double totalIOwe = 420.0;

  double get netBalance => totalOwedToMe - totalIOwe;

  // Mock friends
  final List<Friend> _topFriends = [
    const Friend(
      id: 'f1',
      name: 'Omar Hassan',
      handle: '@omar_h',
      initials: 'OH',
      payments: ['InstaPay: omar@instapay'],
    ),
    const Friend(
      id: 'f2',
      name: 'Kareem Tarek',
      handle: '@ktarek',
      initials: 'KT',
      payments: ['Vodafone Cash: 01012345678'],
    ),
    const Friend(
      id: 'f4',
      name: 'Ahmed Yasser',
      handle: '@ayasser',
      initials: 'AY',
      payments: ['InstaPay: ahmed@instapay'],
    ),
  ];

  final Map<String, double> _balances = {
    'f1': 680.0,
    'f2': -420.0,
    'f4': 770.0,
  };

  // Mock sessions using unified session_models.dart
  final List<Session> _sessions = const [
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
  ];

  // Mock activity
  final List<ActivityItem> _activities = const [
    ActivityItem(
      id: 'a1',
      title: 'Dinner at Crave',
      detail: 'Split with 3 friends',
      when: '2 hours ago',
      amount: 416.0,
    ),
    ActivityItem(
      id: 'a2',
      title: 'InstaPay settlement',
      detail: 'Paid Kareem Tarek',
      when: 'Yesterday',
      amount: -150.0,
    ),
    ActivityItem(
      id: 'a3',
      title: 'Coffee at Espresso Lab',
      detail: 'Omar paid',
      when: '2 days ago',
      amount: -75.0,
    ),
  ];

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

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Hero Header Section
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            padding: const EdgeInsets.fromLTRB(20, kToolbarHeight - 8, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User bar + Notification bell
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AppAvatar(
                          initials: userInitials,
                          tone: AvatarTone.accent,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => widget.onNavigateTab?.call(1),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          LucideIcons.bell,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Net Balance
                Text(
                  'NET BALANCE',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatCurrency(netBalance),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  netBalance >= 0
                      ? "You're owed more than you owe"
                      : "You owe more than you're owed",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 24),

                // Split Metrics Cards
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              LucideIcons.arrowDownLeft,
                              size: 18,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'You are owed',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              formatCurrency(totalOwedToMe),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              LucideIcons.arrowUpRight,
                              size: 18,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'You owe',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              formatCurrency(totalIOwe),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. Quick Action Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context: context,
                    icon: LucideIcons.plus,
                    iconBg: AppColors.accent.withValues(alpha: 0.25),
                    iconColor: const Color(0xFF133B2E),
                    title: 'New session',
                    subtitle: 'Split with app friends',
                    onTap: () => widget.onNavigateTab?.call(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    context: context,
                    icon: LucideIcons.plus,
                    iconBg: isDark
                        ? AppColors.secondaryDark
                        : AppColors.secondary,
                    iconColor: foregroundColor,
                    title: 'Quick split',
                    subtitle: 'Offline, on this phone',
                    onTap: () => widget.onNavigateTab?.call(3),
                  ),
                ),
              ],
            ),
          ),

          // 3. Balances Section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Balances',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: foregroundColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => widget.onNavigateTab?.call(1),
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: mutedForeground,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _topFriends.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final friend = _topFriends[index];
                    final balance = _balances[friend.id] ?? 0.0;

                    return GestureDetector(
                      onTap: () {
                        ProfileSheet.show(
                          context,
                          person: ProfileView(
                            name: friend.name,
                            handle: friend.handle,
                            initials: friend.initials,
                            balance: balance,
                            payments: PaymentMethods(
                              instapay: friend.payments.isNotEmpty
                                  ? friend.payments.first
                                  : null,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            AppAvatar(initials: friend.initials),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    friend.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: foregroundColor,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    balance > 0 ? 'owes you' : 'you owe',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: mutedForeground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              formatCurrency(balance.abs()),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: balance > 0
                                    ? AppColors.positive
                                    : AppColors.negative,
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
          ),

          // 4. Active Sessions Section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Active sessions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: foregroundColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => widget.onNavigateTab?.call(2),
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: mutedForeground,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _sessions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final session = _sessions[index];

                    return Container(
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
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: foregroundColor,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${session.place} · ${session.members.length} people · ${session.date}',
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
                    );
                  },
                ),
              ],
            ),
          ),

          // 5. Recent Activity Section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent activity',
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
                    itemCount: _activities.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, thickness: 1, color: borderColor),
                    itemBuilder: (context, index) {
                      final item = _activities[index];

                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: foregroundColor,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${item.detail} · ${item.when}',
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
                              item.amount == 0
                                  ? '—'
                                  : formatCurrency(item.amount.abs()),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: item.amount > 0
                                    ? AppColors.positive
                                    : item.amount < 0
                                    ? AppColors.negative
                                    : mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;
    final foregroundColor = isDark
        ? AppColors.foregroundDark
        : AppColors.foreground;
    final mutedForeground = isDark
        ? AppColors.mutedForegroundDark
        : AppColors.mutedForeground;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: foregroundColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: mutedForeground),
            ),
          ],
        ),
      ),
    );
  }
}
