import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the ID of the currently selected baby.
/// Null means "not yet set" – the UI will pick the first available baby.
final selectedBabyIdProvider = StateProvider<String?>((ref) => null);