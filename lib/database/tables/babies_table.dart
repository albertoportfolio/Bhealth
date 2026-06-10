import 'package:drift/drift.dart';

/// Stores baby profiles.
class Babies extends Table {
  /// UUID primary key.
  TextColumn get id => text()();

  /// Baby's display name.
  TextColumn get name => text()();

  /// Date of birth (stored as unix timestamp by Drift).
  DateTimeColumn get birthDate => dateTime()();

  /// 'male' | 'female' | 'other'
  TextColumn get gender => text().withDefault(const Constant('other'))();

  /// Optional photo stored as raw bytes.
  BlobColumn get photoBytes => blob().nullable()();

  /// Record creation timestamp.
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}