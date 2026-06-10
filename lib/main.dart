import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
 
import 'app/app.dart';
import 'database/app_database.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');
 
  final database = AppDatabase();
 
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
      child: const BabyTrackerApp(),
    ),
  );
}