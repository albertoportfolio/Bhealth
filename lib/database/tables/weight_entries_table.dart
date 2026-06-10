import 'package:drift/drift.dart';

import 'babies_table.dart';

/// Stores weight measurements (in grams for precision).
class WeightEntries extends Table {
  TextColumn get id => text()();
  TextColumn get babyId =>
      text().references(Babies, #id, onDelete: KeyAction.cascade)();

  /// Weight stored in grams.
  RealColumn get weightGrams => real()();

  DateTimeColumn get measuredAt => dateTime()();

  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}