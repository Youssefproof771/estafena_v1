import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/app_theme.dart';
import '../../widgets/avatar.dart';
import '../../widgets/page_header.dart';
import 'models/friend_models.dart';
import 'widgets/friend_widget.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  String _activeTab = 'list'; // 'list' | 'requests'
  String _query = '';

  // Mock data mirroring mock-data.ts
  final List<Friend> _friends = [
    const Friend(
      id: 'f1',
      name: 'Omar Hassan',
      handle: '@omar_h',
      initials: 'OH',
      payments: ['InstaPay: omar@instapay', 'Vodafone Cash: 01012345678'],
    ),
    const Friend(
      id: 'f2',
      name: 'Kareem Tarek',
      handle: '@ktarek',
      initials: 'KT',
      payments: ['InstaPay: kareem@instapay'],
    ),
    const Friend(
      id: 'f3',
      name: 'Nour Sherif',
      handle: '@nour_s',
      initials: 'NS',
      payments: ['InstaPay: nour@instapay'],
    ),
  ];

  late Map<String, double> _balances;
  late List<FriendRequest> _pendingRequests;
  late List<FriendSuggestion> _suggestions;
  late List<FriendTransaction> _transactions;

  @override
  void initState() {
    super.initState();
    _balances = {
      'f1': 320.0, // owes you
      'f2': -150.0, // you owe
      'f3': 0.0, // settled
    };

    _pendingRequests = [
      const FriendRequest(
        id: 'r1',
        name: 'Ziad Mahmoud',
        initials: 'ZM',
        mutual: 4,
      ),
      const FriendRequest(
        id: 'r2',
        name: 'Farah Ahmed',
        initials: 'FA',
        mutual: 2,
      ),
    ];

    _suggestions = [
      const FriendSuggestion(
        id: 's1',
        name: 'Mostafa Ali',
        initials: 'MA',
        mutual: 7,
      ),
      const FriendSuggestion(
        id: 's2',
        name: 'Salma Refaat',
        initials: 'SR',
        mutual: 3,
      ),
    ];

    _transactions = [
      const FriendTransaction(
        id: 't1',
        title: 'Dinner at Crave',
        amount: 320.0,
        when: 'Yesterday',
      ),
      const FriendTransaction(
        id: 't2',
        title: 'Starbucks coffee',
        amount: -150.0,
        when: '3 days ago',
      ),
    ];
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
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _addTransaction(Friend friend, String title, double amount) {
    setState(() {
      _transactions.insert(
        0,
        FriendTransaction(
          id: 't-${DateTime.now().millisecondsSinceEpoch}',
          title: title,
          amount: amount,
          when: 'Just now',
        ),
      );
      _balances[friend.id] = (_balances[friend.id] ?? 0) + amount;
    });
    _showNotification(
      'Added ${formatCurrency(amount.abs())} with ${friend.name.split(" ")[0]}',
    );
  }

  void _settle(Friend friend, double balance) {
    setState(() {
      _transactions.insert(
        0,
        FriendTransaction(
          id: 't-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Estafena · settled up',
          amount: -balance,
          when: 'Just now',
        ),
      );
      _balances[friend.id] = 0;
    });
    _showNotification(
      'Estafena — you paid ${friend.name} ${formatCurrency(-balance)}',
    );
  }

  void _openFriendSheet(Friend friend, FriendSheetTab tab) {
    FriendSheet.show(
      context,
      friend: friend,
      balance: _balances[friend.id] ?? 0,
      transactions: _transactions,
      initialTab: tab,
      onAdd: ({required title, required amount}) =>
          _addTransaction(friend, title, amount),
      onSettle: () => _settle(friend, _balances[friend.id] ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final secondaryColor = isDark
        ? AppColors.secondaryDark
        : AppColors.secondary;
    final foregroundColor = isDark
        ? AppColors.foregroundDark
        : AppColors.foreground;
    final mutedForeground = isDark
        ? AppColors.mutedForegroundDark
        : AppColors.mutedForeground;

    final visibleFriends = _friends
        .where((f) => f.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageHeader(
            title: 'Friends',
            subtitle: 'Balances update with every shared expense',
          ),

          // Main Tab Switcher ("My friends" vs "Requests (count)")
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _buildMainTabButton(
                    'My friends',
                    'list',
                    surfaceColor,
                    foregroundColor,
                    mutedForeground,
                  ),
                  _buildMainTabButton(
                    'Requests (${_pendingRequests.length})',
                    'requests',
                    surfaceColor,
                    foregroundColor,
                    mutedForeground,
                  ),
                ],
              ),
            ),
          ),

          if (_activeTab == 'list') ...[
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.border,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.search, size: 16, color: mutedForeground),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _query = v),
                        style: TextStyle(fontSize: 14, color: foregroundColor),
                        decoration: InputDecoration(
                          hintText: 'Search friends',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: mutedForeground,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Friends List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              itemCount: visibleFriends.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final friend = visibleFriends[index];
                final bal = _balances[friend.id] ?? 0;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
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
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: foregroundColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  friend.handle,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                bal == 0
                                    ? 'Settled'
                                    : formatCurrency(bal.abs()),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: bal > 0
                                      ? AppColors.positive
                                      : bal < 0
                                      ? AppColors.negative
                                      : mutedForeground,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                bal > 0
                                    ? 'owes you'
                                    : bal < 0
                                    ? 'you owe'
                                    : 'all clear',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _openFriendSheet(
                                friend,
                                FriendSheetTab.history,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LucideIcons.history,
                                      size: 14,
                                      color: foregroundColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Transactions',
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
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  _openFriendSheet(friend, FriendSheetTab.pay),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LucideIcons.wallet2,
                                      size: 14,
                                      color: foregroundColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Payment methods',
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
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ] else ...[
            // Requests Tab
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Incoming requests',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: foregroundColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_pendingRequests.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? AppColors.borderDark
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        'No pending requests',
                        style: TextStyle(fontSize: 13, color: mutedForeground),
                      ),
                    )
                  else
                    ..._pendingRequests.map(
                      (r) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            AppAvatar(initials: r.initials),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: foregroundColor,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${r.mutual} mutual friends',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: mutedForeground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Accept button
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _pendingRequests.removeWhere(
                                    (x) => x.id == r.id,
                                  );
                                });
                                _showNotification(
                                  '${r.name} is now your friend',
                                );
                              },
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withValues(
                                    alpha: 0.25,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  LucideIcons.check,
                                  size: 16,
                                  color: Color(0xFF133B2E),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Reject button
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _pendingRequests.removeWhere(
                                    (x) => x.id == r.id,
                                  );
                                });
                              },
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  LucideIcons.x,
                                  size: 16,
                                  color: foregroundColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),
                  Text(
                    'People you may know',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: foregroundColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._suggestions.map(
                    (s) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? AppColors.borderDark
                              : AppColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          AppAvatar(initials: s.initials),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: foregroundColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${s.mutual} mutual friends',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                _showNotification('Request sent to ${s.name}'),
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
                                    LucideIcons.userPlus,
                                    size: 14,
                                    color: foregroundColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Add',
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
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMainTabButton(
    String label,
    String tabKey,
    Color surfaceColor,
    Color foregroundColor,
    Color mutedForeground,
  ) {
    final isSelected = _activeTab == tabKey;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = tabKey),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? surfaceColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isSelected ? foregroundColor : mutedForeground,
            ),
          ),
        ),
      ),
    );
  }
}
