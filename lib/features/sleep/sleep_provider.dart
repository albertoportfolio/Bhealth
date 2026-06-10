import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/app_database.dart';
import '../baby/providers/baby_provider.dart';

export '../../../database/app_database.dart'
    show SleepEntry, SleepEntriesCompanion;

/// Live stream of all sleep entries for the selected baby.
final sleepEntriesProvider = StreamProvider<List<SleepEntry>>((ref) {
  final baby = ref.watch(selectedBabyProvider);
  if (baby == null) return const Stream.empty();

  final db = ref.watch(databaseProvider);
  return db.sleepDao.watchSleepByBaby(baby.id);
});

/// Live stream of the currently active sleep session (endTime IS NULL).
final activeSleepProvider = StreamProvider<SleepEntry?>((ref) {
  final baby = ref.watch(selectedBabyProvider);
  if (baby == null) return Stream.value(null);

  final db = ref.watch(databaseProvider);
  return db.sleepDao.watchActiveSleep(baby.id);
});