import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'data/store/auth_store.dart';
import 'data/store/daily_tracker_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR');
  await authStore.restoreSession();

  if (authStore.isLoggedIn) {
    await dailyTrackerStore.refreshForSelectedDate();
  }

  runApp(const DailyFuelTrackerApp());
}
