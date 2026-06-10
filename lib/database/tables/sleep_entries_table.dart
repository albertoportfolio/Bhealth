import 'package:drift/drift.dart';

import 'babies_table.dart';

/// Stores sleep sessions. endTime is null while the baby is still sleeping.
class SleepEntries extends Table {
  TextColumn get id => text()();
  TextColumn get babyId =>
      text().references(Babies, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get startTime => dateTime()();

  /// Null means the baby is currently asleep.
  DateTimeColumn get endTime => dateTime().nullable()();

  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}