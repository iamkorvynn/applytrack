import 'package:material_ui/material_ui.dart';

import '../models/interview_round.dart';
import '../services/application_service.dart';
import '../utils/formatters.dart';

/// Form to add one interview round to an application.
class AddRoundScreen extends StatefulWidget {
  const AddRoundScreen({
    super.key,
    required this.applicationId,
    required this.service,
  });

  final int applicationId;
  final ApplicationService service;

  @override
  State<AddRoundScreen> createState() => _AddRoundScreenState();
}

class _AddRoundScreenState extends State<AddRoundScreen> {
  var _type = RoundType.hr;
  var _outcome = RoundOutcome.scheduled;
  DateTime? _scheduledAt;
  final _notesController = TextEditingController();
  var _saving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await widget.service.addRound(
      InterviewRound(
        applicationId: widget.applicationId,
        type: _type,
        scheduledAt: _scheduledAt,
        notes: _notesController.text.trim(),
        outcome: _outcome,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add interview round')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<RoundType>(
            key: ValueKey(_type),
            initialValue: _type,
            decoration: const InputDecoration(labelText: 'Round type'),
            items: RoundType.values
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(type.label),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _type = value);
            },
          ),
          DropdownButtonFormField<RoundOutcome>(
            key: ValueKey(_outcome),
            initialValue: _outcome,
            decoration: const InputDecoration(labelText: 'Outcome'),
            items: RoundOutcome.values
                .map(
                  (outcome) => DropdownMenuItem(
                    value: outcome,
                    child: Text(outcome.label),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _outcome = value);
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Scheduled for'),
            subtitle: Text(Formatters.dateTime(_scheduledAt)),
            trailing: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _scheduledAt ?? DateTime.now(),
                  firstDate: DateTime.now().subtract(
                    const Duration(days: 30),
                  ),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date == null) return;
                if (!context.mounted) return;
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                setState(() {
                  _scheduledAt = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time?.hour ?? 10,
                    time?.minute ?? 0,
                  );
                });
              },
            ),
          ),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Notes'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: const Text('Add round'),
          ),
        ],
      ),
    );
  }
}
