import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/feedings_table.dart';

part 'feedings_dao.g.dart';

@DriftAccessor(tables: [Feedings])
class FeedingsDao extends DatabaseAccessor<AppDatabase>
    with _$FeedingsDaoMixin {
  FeedingsDao(super.db);

  /// Stream of all feedings for a baby, newest first.
  Stream<List<Feeding>> watchFeedingsByBaby(String babyId) =>
      (select(feedings)
            ..where((f) => f.babyId.equals(babyId))
            ..orderBy([(f) => OrderingTerm.desc(f.startTime)]))
          .watch();

  /// Feedings for a baby on a specific calendar day.
  Future<List<Feeding>> getFeedingsByBabyAndDate(
    String babyId,
    DateTime date,
  ) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(feedings)
          ..where(
            (f) =>
                f.babyId.equals(babyId) &
                f.startTime.isBiggerOrEqualValue(start) &
                f.startTime.isSmallerThanValue(end),
          )
          ..orderBy([(f) => OrderingTerm.desc(f.startTime)]))
        .get();
  }

  Future<void> insertFeeding(FeedingsCompanion companion) =>
      into(feedings).insert(companion);

  Future<void> deleteFeeding(String id) =>
      (delete(feedings)..where((f) => f.id.equals(id))).go();
}