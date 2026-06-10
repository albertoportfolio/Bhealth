import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/app_database.dart';
import '../../../core/utils/selected_baby_provider.dart';

export '../../../../database/app_database.dart' show Baby, BabiesCompanion;

/// Live stream of all babies.
final babiesProvider = StreamProvider<List<Baby>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.babiesDao.watchAllBabies();
});

/// The currently active baby.
/// Falls back to the first baby if no explicit selection has been made.
final selectedBabyProvider = Provider<Baby?>((ref) {
  final babies = ref.watch(babiesProvider).valueOrNull ?? [];
  if (babies.isEmpty) return null;

  final selectedId = ref.watch(selectedBabyIdProvider);
  if (selectedId == null) return babies.first;

  return babies.firstWhere(
    (b) => b.id == selectedId,
    orElse: () => babies.first,
  );
});