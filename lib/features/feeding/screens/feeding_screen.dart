import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/empty_state.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../database/app_database.dart';
import '../feeding_provider.dart';
import '../feeding_tile.dart';
import '../feeding_type.dart';

class FeedingScreen extends ConsumerWidget {
  const FeedingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedingsAsync = ref.watch(feedingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Alimentación')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/feedings/add'),
        child: const Icon(Icons.add_rounded),
      ),
      body: feedingsAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (feedings) {
          if (feedings.isEmpty) {
            return EmptyState(
              icon: Icons.local_drink_outlined,
              title: 'Sin registros de alimentación',
              subtitle: 'Pulsa el botón + para añadir la primera toma.',
              actionLabel: 'Añadir toma',
              onAction: () => context.push('/feedings/add'),
            );
          }

          // Group by day
          final grouped = <String, List<Feeding>>{};
          for (final f in feedings) {
            final key = DateFormatter.formatRelativeDate(f.startTime);
            grouped.putIfAbsent(key, () => []).add(f);
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: grouped.length,
            itemBuilder: (_, i) {
              final day = grouped.keys.elementAt(i);
              final items = grouped[day]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          day,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                        Text(
                          _daySummary(items),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  ...items.map(
                    (f) => FeedingTile(
                      feeding: f,
                      onDelete: () => _delete(context, ref, f.id),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  /// e.g. '5 tomas · 320 ml · 25 min'
  String _daySummary(List<Feeding> items) {
    double totalMl = 0;
    int totalMin = 0;
    for (final f in items) {
      if (FeedingType.fromValue(f.type).isBottle) {
        totalMl += f.amountMl ?? 0;
      } else {
        totalMin += f.durationMinutes ?? 0;
      }
    }
    return [
      '${items.length} ${items.length == 1 ? "toma" : "tomas"}',
      if (totalMl > 0) DateFormatter.formatVolume(totalMl),
      if (totalMin > 0) '$totalMin min',
    ].join(' · ');
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar toma'),
        content: const Text('¿Seguro que quieres eliminar este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(databaseProvider).feedingsDao.deleteFeeding(id);
    }
  }
}