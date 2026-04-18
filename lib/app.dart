import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'data/store/auth_store.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';

class DailyFuelTrackerApp extends StatelessWidget {
  const DailyFuelTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: authStore,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Daily Fuel Tracker',
          theme: AppTheme.lightTheme,
          scrollBehavior: const _AppScrollBehavior(),
          home: authStore.isLoggedIn
              ? DashboardScreen(
                  userName: authStore.fullName ?? 'Kullanıcı',
                )
              : const LoginScreen(),
        );
      },
    );
  }
}

class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices {
    return {
      PointerDeviceKind.touch,
      PointerDeviceKind.mouse,
      PointerDeviceKind.trackpad,
      PointerDeviceKind.stylus,
    };
  }
}
