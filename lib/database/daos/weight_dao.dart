import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/weight_entries_table.dart';

part 'weight_dao.g.dart';

@DriftAccessor(tables: [WeightEntries])
class WeightDao extends DatabaseAccessor<AppDatabase> with _$WeightDaoMixin {
  WeightDao(super.db);

  /// Live stream of weight entries for a baby, newest first.
  Stream<List<WeightEntry>> watchWeightByBaby(String babyId) =>
      (select(weightEntries)
            ..where((w) => w.babyId.equals(babyId))
            ..orderBy([(w) => OrderingTerm.desc(w.measuredAt)]))
          .watch();

  Future<void> insertWeight(WeightEntriesCompanion companion) =>
      into(weightEntries).insert(companion);

  Future<void> deleteWeight(String id) =>
      (delete(weightEntries)..where((w) => w.id.equals(id))).go();
}