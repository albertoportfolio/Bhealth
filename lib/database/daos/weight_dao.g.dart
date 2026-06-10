// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_dao.dart';

// ignore_for_file: type=lint
mixin _$WeightDaoMixin on DatabaseAccessor<AppDatabase> {
  $BabiesTable get babies => attachedDatabase.babies;
  $WeightEntriesTable get weightEntries => attachedDatabase.weightEntries;
  WeightDaoManager get managers => WeightDaoManager(this);
}

class WeightDaoManager {
  final _$WeightDaoMixin _db;
  WeightDaoManager(this._db);
  $$BabiesTableTableManager get babies =>
      $$BabiesTableTableManager(_db.attachedDatabase, _db.babies);
  $$WeightEntriesTableTableManager get weightEntries =>
      $$WeightEntriesTableTableManager(_db.attachedDatabase, _db.weightEntries);
}
