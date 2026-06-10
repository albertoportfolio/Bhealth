import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/sleep_entries_table.dart';

part 'sleep_dao.g.dart';

@DriftAccessor(tables: [SleepEntries])
class SleepDao extends DatabaseAccessor<AppDatabase> with _$SleepDaoMixin {
  SleepDao(super.db);

  /// Live stream of all sleep entries for a baby, newest first.
  Stream<List<SleepEntry>> watchSleepByBaby(String babyId) =>
      (select(sleepEntries)
            ..where((s) => s.babyId.equals(babyId))
            ..orderBy([(s) => OrderingTerm.desc(s.startTime)]))
          .watch();

  /// Returns the currently active sleep session (endTime IS NULL), if any.
  Future<SleepEntry?> getActiveSleep(String babyId) =>
      (select(sleepEntries)
            ..where(
              (s) => s.babyId.equals(babyId) & s.endTime.isNull(),
            ))
          .getSingleOrNull();

  /// Same as above but as a live stream.
  Stream<SleepEntry?> watchActiveSleep(String babyId) =>
      (select(sleepEntries)
            ..where(
              (s) => s.babyId.equals(babyId) & s.endTime.isNull(),
            ))
          .watchSingleOrNull();

  Future<void> insertSleep(SleepEntriesCompanion companion) =>
      into(sleepEntries).insert(companion);

  Future<void> updateSleep(SleepEntriesCompanion companion) =>
      (update(sleepEntries)
            ..where((s) => s.id.equals(companion.id.value)))
          .write(companion);

  Future<void> deleteSleep(String id) =>
      (delete(sleepEntries)..where((s) => s.id.equals(id))).go();
}