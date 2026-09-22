import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/avatar.dart';
import '../models/friend_models.dart';

enum FriendSheetTab { history, add, pay }

class FriendSheet extends StatefulWidget {
  final Friend friend;
  final double balance;
  final List<FriendTransaction> transactions;
  final FriendSheetTab initialTab;
  final void Function({required String title, required double amount}) onAdd;
  final VoidCallback onSettle;

  const FriendSheet({
    super.key,
    required this.friend,
    required this.balance,
    required this.transactions,
    this.initialTab = FriendSheetTab.history,
    required this.onAdd,
    required this.onSettle,
  });

  static Future<void> show(
    BuildContext context, {
    required Friend friend,
    required double balance,
    required List<FriendTransaction> transactions,
    FriendSheetTab initialTab = FriendSheetTab.history,
    required void Function({required String title, required double amount})
    onAdd,
    required VoidCallback onSettle,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => FriendSheet(
        friend: friend,
        balance: balance,
        transactions: transactions,
        initialTab: initialTab,
        onAdd: onAdd,
        onSettle: onSettle,
      ),
    );
  }

  @override
  State<FriendSheet> createState() => _FriendSheetState();
}

class _FriendSheetState extends State<FriendSheet> {
  late FriendSheetTab _selectedTab;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _direction = 'they'; // 'they' = I paid, 'me' = they paid

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String get _firstName => widget.friend.name.split(' ').first;

  void _submit() {
    final title = _titleController.text.trim();
    final amountVal = double.tryParse(_amountController.text.trim());
    if (title.isEmpty || amountVal == null || amountVal <= 0) return;

    final signedAmount = _direction == 'they' ? amountVal : -amountVal;
    widget.onAdd(title: title, amount: signedAmount);

    _titleController.clear();
    _amountController.clear();
    setState(() => _selectedTab = FriendSheetTab.history);
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

    return Dialog(
      backgroundColor: surfaceColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 384), // max-w-sm
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  AppAvatar(
                    initials: widget.friend.initials,
                    tone: AvatarTone.accent,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.friend.name,
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
                          widget.friend.handle,
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
                  Text(
                    widget.balance == 0
                        ? 'Settled'
                        : formatCurrency(widget.balance.abs()),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: widget.balance > 0
                          ? AppColors.positive
                          : widget.balance < 0
                          ? AppColors.negative
                          : mutedForeground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Settle Banner / Button
              if (widget.balance < 0) ...[
                GestureDetector(
                  onTap: widget.onSettle,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: AppColors.accentGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Estafena · pay ${formatCurrency(-widget.balance)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF133B2E),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ] else if (widget.balance > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Waiting for $_firstName to press Estafena',
                    style: TextStyle(fontSize: 12, color: mutedForeground),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // 3-Way Tab Selector
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    _buildTabButton(
                      'History',
                      FriendSheetTab.history,
                      surfaceColor,
                      foregroundColor,
                      mutedForeground,
                    ),
                    _buildTabButton(
                      'Add',
                      FriendSheetTab.add,
                      surfaceColor,
                      foregroundColor,
                      mutedForeground,
                    ),
                    _buildTabButton(
                      'Pay to',
                      FriendSheetTab.pay,
                      surfaceColor,
                      foregroundColor,
                      mutedForeground,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tab Contents
              if (_selectedTab == FriendSheetTab.history)
                _buildHistoryTab(
                  secondaryColor,
                  foregroundColor,
                  mutedForeground,
                )
              else if (_selectedTab == FriendSheetTab.add)
                _buildAddTab(
                  secondaryColor,
                  surfaceColor,
                  foregroundColor,
                  mutedForeground,
                )
              else
                _buildPayTab(secondaryColor, mutedForeground),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(
    String label,
    FriendSheetTab tab,
    Color surfaceColor,
    Color foregroundColor,
    Color mutedForeground,
  ) {
    final isSelected = _selectedTab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
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
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? foregroundColor : mutedForeground,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryTab(
    Color secondaryColor,
    Color foregroundColor,
    Color mutedForeground,
  ) {
    if (widget.transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          'No transactions yet',
          style: TextStyle(fontSize: 13, color: mutedForeground),
        ),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 280),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: widget.transactions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final t = widget.transactions[index];
          final isPositive = t.amount >= 0;

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    isPositive
                        ? LucideIcons.arrowUpRight
                        : LucideIcons.arrowDownLeft,
                    size: 16,
                    color: isPositive ? AppColors.positive : AppColors.negative,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: foregroundColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${t.when} · ${isPositive ? "you paid" : "$_firstName paid"}',
                        style: TextStyle(fontSize: 11, color: mutedForeground),
                      ),
                    ],
                  ),
                ),
                Text(
                  formatCurrency(t.amount.abs()),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isPositive ? AppColors.positive : AppColors.negative,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddTab(
    Color secondaryColor,
    Color surfaceColor,
    Color foregroundColor,
    Color mutedForeground,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Direction toggle: "I paid" vs "[Name] paid"
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _direction = 'they'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _direction == 'they'
                          ? surfaceColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'I paid',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _direction == 'they'
                            ? foregroundColor
                            : mutedForeground,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _direction = 'me'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _direction == 'me'
                          ? surfaceColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$_firstName paid',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _direction == 'me'
                            ? foregroundColor
                            : mutedForeground,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Title Input
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'What was it for?',
            fillColor: secondaryColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Amount Input
        TextField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: 'Amount (EGP)',
            fillColor: secondaryColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Submit Button
        GestureDetector(
          onTap: _submit,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.plus, size: 16, color: Color(0xFF133B2E)),
                SizedBox(width: 6),
                Text(
                  'Add transaction',
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
      ],
    );
  }

  Widget _buildPayTab(Color secondaryColor, Color mutedForeground) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.wallet2, size: 14, color: mutedForeground),
            const SizedBox(width: 6),
            Text(
              'Where $_firstName receives money',
              style: TextStyle(fontSize: 12, color: mutedForeground),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (widget.friend.payments.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              'No payment methods listed',
              style: TextStyle(fontSize: 12, color: mutedForeground),
            ),
          )
        else
          ...widget.friend.payments.map(
            (p) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.creditCard, size: 16),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      p,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
