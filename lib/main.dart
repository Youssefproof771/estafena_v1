import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'widgets/app_shell.dart';
import 'features/friends/friend_page.dart';
import 'features/home/home_page.dart';
import 'features/local/local_page.dart';
import 'features/sessions/sessions_page.dart';
import 'features/settings/settings_page.dart';
import 'features/auth/login_page.dart';

void main() {
  runApp(const EstafenaApp());
}

class EstafenaApp extends StatefulWidget {
  const EstafenaApp({super.key});

  @override
  State<EstafenaApp> createState() => _EstafenaAppState();
}

class _EstafenaAppState extends State<EstafenaApp> {
  int _currentTab = 0;
  bool _isDarkMode = false;
  bool _isAuthenticated = false;
  void _setTab(int index) {
    setState(() => _currentTab = index);
  }

  void _toggleTheme(bool value) {
    setState(() => _isDarkMode = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estafena',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: _isAuthenticated
          ? AppShell(
              currentIndex: _currentTab,
              onTabChanged: _setTab,
              pages: [
                HomePage(onNavigateTab: _setTab),
                const FriendsPage(),
                const SessionsPage(),
                const LocalPage(),
                SettingsPage(
                  isDarkMode: _isDarkMode,
                  onThemeToggle: _toggleTheme,
                ),
              ],
            )
          : LoginPage(
              onLoginSuccess: () => setState(() => _isAuthenticated = true),
            ),
    );
  }
}
