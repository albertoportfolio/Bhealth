// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedings_dao.dart';

// ignore_for_file: type=lint
mixin _$FeedingsDaoMixin on DatabaseAccessor<AppDatabase> {
  $BabiesTable get babies => attachedDatabase.babies;
  $FeedingsTable get feedings => attachedDatabase.feedings;
  FeedingsDaoManager get managers => FeedingsDaoManager(this);
}

class FeedingsDaoManager {
  final _$FeedingsDaoMixin _db;
  FeedingsDaoManager(this._db);
  $$BabiesTableTableManager get babies =>
      $$BabiesTableTableManager(_db.attachedDatabase, _db.babies);
  $$FeedingsTableTableManager get feedings =>
      $$FeedingsTableTableManager(_db.attachedDatabase, _db.feedings);
}
