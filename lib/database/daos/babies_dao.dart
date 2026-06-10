import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/babies_table.dart';

part 'babies_dao.g.dart';

@DriftAccessor(tables: [Babies])
class BabiesDao extends DatabaseAccessor<AppDatabase>
    with _$BabiesDaoMixin {
  BabiesDao(super.db);

  /// Live stream of all babies, ordered by creation date.
  Stream<List<Baby>> watchAllBabies() =>
      (select(babies)..orderBy([(b) => OrderingTerm.asc(b.createdAt)])).watch();

  Future<List<Baby>> getAllBabies() =>
      (select(babies)..orderBy([(b) => OrderingTerm.asc(b.createdAt)])).get();

  Future<Baby?> getBabyById(String id) =>
      (select(babies)..where((b) => b.id.equals(id))).getSingleOrNull();

  Future<void> insertBaby(BabiesCompanion companion) =>
      into(babies).insert(companion);

  Future<void> updateBaby(BabiesCompanion companion) =>
      (update(babies)..where((b) => b.id.equals(companion.id.value)))
          .write(companion);

  Future<void> deleteBaby(String id) =>
      (delete(babies)..where((b) => b.id.equals(id))).go();
}