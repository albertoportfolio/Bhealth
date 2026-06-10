import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/babies_dao.dart';
import 'daos/feedings_dao.dart';
import 'daos/sleep_dao.dart';
import 'daos/weight_dao.dart';
import 'tables/babies_table.dart';
import 'tables/feedings_table.dart';
import 'tables/sleep_entries_table.dart';
import 'tables/weight_entries_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Babies, Feedings, SleepEntries, WeightEntries],
  daos: [BabiesDao, FeedingsDao, SleepDao, WeightDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // Future migrations go here.
        },
        beforeOpen: (details) async {
          // Enable foreign-key enforcement for SQLite.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    Directory dbFolder;
    try {
      dbFolder = await getApplicationDocumentsDirectory();
    } catch (_) {
      dbFolder = Directory.current;
    }

    final file = File(p.join(dbFolder.path, 'baby_tracker.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

/// Overridden in main() via ProviderScope overrides.
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(
    'databaseProvider must be overridden in the root ProviderScope.',
  );
});