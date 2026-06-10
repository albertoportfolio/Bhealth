import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/selected_baby_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/empty_state.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../database/app_database.dart';
import '../providers/baby_provider.dart';
import '../baby_avatar.dart';

class BabiesScreen extends ConsumerWidget {
  const BabiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final babiesAsync = ref.watch(babiesProvider);
    final selectedId = ref.watch(selectedBabyIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis bebés'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/babies/add'),
        child: const Icon(Icons.add_rounded),
      ),
      body: babiesAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (babies) {
          if (babies.isEmpty) {
            return EmptyState(
              icon: Icons.child_care_rounded,
              title: 'Sin bebés registrados',
              subtitle: 'Añade tu primer bebé para empezar a registrar su información.',
              actionLabel: 'Añadir bebé',
              onAction: () => context.push('/babies/add'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: babies.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _BabyCard(
              baby: babies[i],
              isSelected: (selectedId ?? babies.first.id) == babies[i].id,
            ),
          );
        },
      ),
    );
  }
}

class _BabyCard extends ConsumerWidget {
  final Baby baby;
  final bool isSelected;

  const _BabyCard({required this.baby, required this.isSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isSelected
            ? Border.all(color: theme.colorScheme.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: BabyAvatar(
          name: baby.name,
          gender: baby.gender,
          photoBytes: baby.photoBytes,
          radius: 28,
        ),
        title: Text(baby.name, style: theme.textTheme.titleMedium),
        subtitle: Text(
          DateFormatter.getAge(baby.birthDate),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: theme.colorScheme.primary,
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ),
        onTap: () {
          ref.read(selectedBabyIdProvider.notifier).state = baby.id;
          context.go('/home');
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar bebé'),
        content: Text(
          '¿Estás seguro de que quieres eliminar a ${baby.name}? '
          'Se borrarán todos sus registros.',
        ),
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
      final db = ref.read(databaseProvider);
      await db.babiesDao.deleteBaby(baby.id);
    }
  }
}