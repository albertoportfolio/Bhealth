import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/app_database.dart';
import '../baby/providers/baby_provider.dart';

export '../../../database/app_database.dart' show Feeding, FeedingsCompanion;

/// Live stream of feedings for the currently selected baby.
final feedingsProvider = StreamProvider<List<Feeding>>((ref) {
  final baby = ref.watch(selectedBabyProvider);
  if (baby == null) return const Stream.empty();

  final db = ref.watch(databaseProvider);
  return db.feedingsDao.watchFeedingsByBaby(baby.id);
});

/// Today's feedings for the selected baby.
final todayFeedingsProvider = FutureProvider<List<Feeding>>((ref) async {
  final baby = ref.watch(selectedBabyProvider);
  if (baby == null) return [];

  final db = ref.read(databaseProvider);
  return db.feedingsDao.getFeedingsByBabyAndDate(baby.id, DateTime.now());
});