import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../theme/app_theme.dart';

class TabItem {
  final String label;
  final IconData icon;

  const TabItem({required this.label, required this.icon});
}

const List<TabItem> tabs = [
  TabItem(label: 'Home', icon: LucideIcons.home),
  TabItem(label: 'Friends', icon: LucideIcons.users),
  TabItem(label: 'Sessions', icon: LucideIcons.receipt),
  TabItem(label: 'Local', icon: LucideIcons.smartphone),
  TabItem(label: 'Settings', icon: LucideIcons.settings),
];

class AppShell extends StatelessWidget {
  final List<Widget> pages;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const AppShell({
    super.key,
    required this.pages,
    required this.currentIndex,
    required this.onTabChanged,
  });

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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 448),
          child: IndexedStack(index: currentIndex, children: pages),
        ),
      ),
      bottomNavigationBar: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 448),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: surfaceColor.withValues(alpha: 0.95),
                  border: Border(top: BorderSide(color: borderColor, width: 1)),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 6.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(tabs.length, (index) {
                        final tab = tabs[index];
                        final isActive = currentIndex == index;

                        return Expanded(
                          child: InkWell(
                            onTap: () => onTabChanged(index),
                            borderRadius: BorderRadius.circular(12),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    curve: Curves.easeInOut,
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? AppColors.accent.withValues(
                                              alpha: 0.25,
                                            )
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      tab.icon,
                                      size: 18,
                                      color: isActive
                                          ? foregroundColor
                                          : mutedForeground,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tab.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: isActive
                                          ? foregroundColor
                                          : mutedForeground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
