import 'package:drift/drift.dart';

import 'babies_table.dart';

/// Stores milk intake events.
/// type values: 'breast_left' | 'breast_right' | 'bottle_formula' | 'bottle_breast_milk'
class Feedings extends Table {
  TextColumn get id => text()();
  TextColumn get babyId =>
      text().references(Babies, #id, onDelete: KeyAction.cascade)();

  /// Feeding modality string – see FeedingType enum.
  TextColumn get type => text()();

  /// Volume in millilitres (bottle feedings).
  RealColumn get amountMl => real().nullable()();

  /// Duration in minutes (breast feedings).
  IntColumn get durationMinutes => integer().nullable()();

  /// When the feeding started.
  DateTimeColumn get startTime => dateTime()();

  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}