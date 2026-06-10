import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/app_database.dart';
import '../../baby/providers/baby_provider.dart';

export '../../../database/app_database.dart' show WeightEntry, WeightEntriesCompanion;

/// Live stream of weight records for the currently selected baby.
final weightEntriesProvider = StreamProvider<List<WeightEntry>>((ref) {
  final baby = ref.watch(selectedBabyProvider);
  if (baby == null) return const Stream.empty();

  final db = ref.watch(databaseProvider);
  return db.weightDao.watchWeightByBaby(baby.id);
});
