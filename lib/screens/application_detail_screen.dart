import 'package:material_ui/material_ui.dart';

import '../models/application.dart';
import '../models/checklist_item.dart';
import '../models/interview_round.dart';
import '../models/job_type.dart';
import '../models/source.dart';
import '../services/application_service.dart';
import '../services/link_service.dart';
import '../utils/application_age.dart';
import '../utils/csv_builder.dart';
import '../utils/formatters.dart';
import '../widgets/checklist_tile.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../widgets/prep_template_picker.dart';
import '../widgets/round_tile.dart';
import '../widgets/section_header.dart';
import '../widgets/status_chip.dart';
import 'add_edit_application_screen.dart';
import 'add_round_screen.dart';

/// Full detail: status changer, link, rounds, prep checklist, edit/delete.
class ApplicationDetailScreen extends StatefulWidget {
  const ApplicationDetailScreen({
    super.key,
    required this.application,
    required this.service,
  });

  final Application application;
  final ApplicationService service;

  @override
  State<ApplicationDetailScreen> createState() =>
      _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState extends State<ApplicationDetailScreen> {
  late Application _app;
  List<InterviewRound> _rounds = [];
  List<ChecklistItem> _checklist = [];
  final _checklistController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _app = widget.application;
    _load();
  }

  @override
  void dispose() {
    _checklistController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final rounds = await widget.service.roundsFor(_app.id ?? -1);
    final items = await widget.service.checklistFor(_app.id ?? -1);
    if (!mounted) return;
    setState(() {
      _rounds = rounds;
      _checklist = items;
    });
  }

  Future<void> _edit() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => AddEditApplicationScreen(
          service: widget.service,
          existing: _app,
        ),
      ),
    );
    if (saved == true) {
      final fresh =
          await widget.service.applications.getById(_app.id ?? -1);
      if (fresh != null && mounted) {
        setState(() => _app = fresh);
      }
    }
  }

  Future<void> _delete() async {
    final confirmed = await ConfirmDeleteDialog.show(
      context,
      'Delete ${_app.company} — ${_app.role}? This cannot be undone.',
    );
    if (!confirmed) return;
    await widget.service.deleteApplication(_app.id ?? -1);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _changeRoundOutcome(InterviewRound round) async {
    final picked = await showDialog<RoundOutcome>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('${round.type.label} outcome'),
        children: RoundOutcome.values
            .map(
              (outcome) => SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(outcome),
                child: Text(outcome.label),
              ),
            )
            .toList(),
      ),
    );
    if (picked == null || picked == round.outcome) return;
    await widget.service.updateRound(round.copyWith(outcome: picked));
    await _load();
  }

  Future<void> _addRound() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => AddRoundScreen(
          applicationId: _app.id ?? -1,
          service: widget.service,
        ),
      ),
    );
    if (created == true) _load();
  }

  Future<void> _addChecklistItem() async {
    final title = _checklistController.text.trim();
    if (title.isEmpty) return;
    await widget.service.addChecklistItem(
      ChecklistItem(
        applicationId: _app.id ?? -1,
        title: title,
        sortOrder: _checklist.length,
      ),
    );
    _checklistController.clear();
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final salary = salaryLabelFor(_app);
    final done = _checklist.where((item) => item.isDone).length;
    return Scaffold(
      appBar: AppBar(
        title: Text(_app.company),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: _edit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
            onPressed: _delete,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _app.role,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  '${_app.jobType.label} · ${_app.displayLocation}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                StatusChip(status: _app.status),
                if (salary.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(salary, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Date applied'),
            subtitle: Text(Formatters.date(_app.dateApplied)),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Applied'),
            subtitle: Text(ApplicationAge.label(_app)),
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Deadline'),
            subtitle: Text(
              _app.deadline == null
                  ? 'No deadline set'
                  : Formatters.relativeDay(_app.deadline!),
            ),
          ),
          if (_app.followUpDate != null)
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('Follow up'),
              subtitle: Text(Formatters.date(_app.followUpDate)),
            ),
          ListTile(
            leading: const Icon(Icons.public),
            title: Text('Found via ${_app.source.label}'),
            subtitle: Text(
              _app.contactName.isEmpty
                  ? 'No contact saved'
                  : '${_app.contactName} ${_app.contactEmail}',
            ),
          ),
          if (_app.resumeVersion.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Resume version'),
              subtitle: Text(_app.resumeVersion),
            ),
          if (_app.hasJobUrl)
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Open job posting'),
              subtitle: Text(
                _app.jobUrl,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => LinkService.openUrl(_app.jobUrl),
            ),
          if (_app.notes.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.notes),
              title: const Text('Notes'),
              subtitle: Text(_app.notes),
            ),
          const SectionHeader(title: 'Interview rounds'),
          if (_rounds.isEmpty)
            const ListTile(
              title: Text('No rounds yet. Add the first one below.'),
            ),
          ..._rounds.map(
            (round) => RoundTile(
              round: round,
              onTap: () => _changeRoundOutcome(round),
              onDelete: () async {
                await widget.service.deleteRound(round.id ?? -1);
                await _load();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: _addRound,
              icon: const Icon(Icons.add),
              label: const Text('Add interview round'),
            ),
          ),
          SectionHeader(
            title: 'Interview prep ($done/${_checklist.length} done)',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PrepTemplatePicker(
              onAdd: (type) async {
                await widget.service.addPrepTemplate(_app.id ?? -1, type);
                await _load();
              },
            ),
          ),
          ..._checklist.map(
            (item) => ChecklistTile(
              item: item,
              onToggle: () async {
                await widget.service.toggleChecklistItem(item);
                await _load();
              },
              onDelete: () async {
                await widget.service.deleteChecklistItem(item.id ?? -1);
                await _load();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _checklistController,
                    decoration: const InputDecoration(
                      labelText: 'Add a prep task',
                    ),
                    onSubmitted: (_) => _addChecklistItem(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  tooltip: 'Add prep task',
                  onPressed: _addChecklistItem,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
