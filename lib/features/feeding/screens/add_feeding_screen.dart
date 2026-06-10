import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../database/app_database.dart';
import '../../baby/providers/baby_provider.dart';
import '../feeding_type.dart';

class AddFeedingScreen extends ConsumerStatefulWidget {
  const AddFeedingScreen({super.key});

  @override
  ConsumerState<AddFeedingScreen> createState() => _AddFeedingScreenState();
}

class _AddFeedingScreenState extends ConsumerState<AddFeedingScreen> {
  final _amountController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();

  FeedingType _type = FeedingType.breastLeft;
  DateTime _startTime = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startTime,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startTime),
    );
    if (time == null) return;

    setState(() {
      _startTime = DateTime(
        date.year, date.month, date.day, time.hour, time.minute,
      );
    });
  }

  Future<void> _save() async {
    final baby = ref.read(selectedBabyProvider);
    if (baby == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un bebé antes de guardar la toma')),
      );
      return;
    }

    final amountText = _amountController.text.trim();
    final durationText = _durationController.text.trim();
    final amountMl = _type.isBottle
        ? double.tryParse(amountText.replaceAll(',', '.'))
        : null;
    final durationMinutes = !_type.isBottle
        ? int.tryParse(durationText)
        : null;

    if (_type.isBottle) {
      if (amountText.isEmpty || amountMl == null || amountMl <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Introduce una cantidad válida en ml')),
        );
        return;
      }
    } else {
      if (durationText.isEmpty || durationMinutes == null || durationMinutes <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Introduce una duración válida en minutos')),
        );
        return;
      }
    }

    setState(() => _isSaving = true);

    try {
      final db = ref.read(databaseProvider);
      await db.feedingsDao.insertFeeding(
        FeedingsCompanion.insert(
          id: const Uuid().v4(),
          babyId: baby.id,
          type: _type.value,
          startTime: _startTime,
          amountMl: _type.isBottle ? Value(amountMl) : const Value.absent(),
          durationMinutes:
              !_type.isBottle ? Value(durationMinutes) : const Value.absent(),
          notes: _notesController.text.isNotEmpty
              ? Value(_notesController.text.trim())
              : const Value.absent(),
        ),
      );

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Añadir toma')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type selector
              Text('Tipo de toma', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: FeedingType.values.map((t) {
                  final selected = _type == t;
                  return ChoiceChip(
                    avatar: Icon(t.icon,
                        size: 16, color: selected ? t.color : null),
                    label: Text(t.shortLabel),
                    selected: selected,
                    selectedColor: t.color.withValues(alpha: 0.2),
                    onSelected: (_) => setState(() => _type = t),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Amount / Duration
              if (_type.isBottle) ...[
                Text('Cantidad (ml)', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                  decoration: const InputDecoration(
                    hintText: 'ej. 120',
                    suffixText: 'ml',
                    prefixIcon: Icon(Icons.local_drink_outlined),
                  ),
                ),
              ] else ...[
                Text('Duración (minutos)', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: 'ej. 15',
                    suffixText: 'min',
                    prefixIcon: Icon(Icons.timer_outlined),
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Date & time
              Text('Hora de inicio', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDateTime,
                borderRadius: BorderRadius.circular(14),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.schedule_outlined),
                  ),
                  child: Text(
                    '${_startTime.day.toString().padLeft(2, '0')}/'
                    '${_startTime.month.toString().padLeft(2, '0')}/'
                    '${_startTime.year}  '
                    '${_startTime.hour.toString().padLeft(2, '0')}:'
                    '${_startTime.minute.toString().padLeft(2, '0')}',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Notes
              Text('Notas (opcional)', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Observaciones...',
                ),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Guardar toma'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}