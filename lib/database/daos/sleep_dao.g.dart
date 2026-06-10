// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_dao.dart';

// ignore_for_file: type=lint
mixin _$SleepDaoMixin on DatabaseAccessor<AppDatabase> {
  $BabiesTable get babies => attachedDatabase.babies;
  $SleepEntriesTable get sleepEntries => attachedDatabase.sleepEntries;
  SleepDaoManager get managers => SleepDaoManager(this);
}

class SleepDaoManager {
  final _$SleepDaoMixin _db;
  SleepDaoManager(this._db);
  $$BabiesTableTableManager get babies =>
      $$BabiesTableTableManager(_db.attachedDatabase, _db.babies);
  $$SleepEntriesTableTableManager get sleepEntries =>
      $$SleepEntriesTableTableManager(_db.attachedDatabase, _db.sleepEntries);
}
