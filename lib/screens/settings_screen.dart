import 'package:material_ui/material_ui.dart';

import '../data/settings_store.dart';
import '../models/application.dart';
import '../services/application_service.dart';
import '../services/csv_export_service.dart';
import '../utils/csv_builder.dart';
import '../utils/reminder_lead_options.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../widgets/settings_section.dart';

/// Theme, reminders, default salary period, CSV export.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.applications,
    required this.themeMode,
    required this.onThemeChanged,
    required this.settings,
    required this.service,
  });

  final List<Application> applications;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final SettingsStore settings;
  final ApplicationService service;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _exporting = false;
  String? _exportPath;
  late int _leadDays;

  @override
  void initState() {
    super.initState();
    _leadDays = widget.settings.reminderLeadDays;
  }

  Future<void> _export() async {
    setState(() => _exporting = true);
    try {
      final path = await CsvExportService().export(widget.applications);
      if (!mounted) return;
      setState(() {
        _exportPath = path;
        _exporting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CSV exported')),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _exporting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Export failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SettingsSection(
          title: 'Appearance',
          children: [
            RadioGroup<ThemeMode>(
              groupValue: widget.themeMode,
              onChanged: (value) {
                if (value != null) widget.onThemeChanged(value);
              },
              child: const Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text('System'),
                    value: ThemeMode.system,
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text('Light'),
                    value: ThemeMode.light,
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text('Dark'),
                    value: ThemeMode.dark,
                  ),
                ],
              ),
            ),
          ],
        ),
        SettingsSection(
          title: 'Reminders',
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButtonFormField<int>(
                key: ValueKey(_leadDays),
                initialValue: _leadDays,
                decoration: const InputDecoration(
                  labelText: 'Remind me before a deadline',
                ),
                items: ReminderLeadOptions.options
                    .map(
                      (days) => DropdownMenuItem(
                        value: days,
                        child: Text(ReminderLeadOptions.label(days)),
                      ),
                    )
                    .toList(),
                onChanged: (value) async {
                  if (value == null) return;
                  await widget.settings.setReminderLeadDays(value);
                  setState(() => _leadDays = value);
                },
              ),
            ),
          ],
        ),
        SettingsSection(
          title: 'Data',
          children: [
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const Text('Export as CSV'),
              subtitle: Text(CsvBuilder.summary(widget.applications)),
              trailing: _exporting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.chevron_right),
              onTap: widget.applications.isEmpty ? null : _export,
            ),
            if (_exportPath != null)
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('Saved to'),
                subtitle: Text(_exportPath!),
              ),
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Clear all data'),
              subtitle: const Text(
                'Delete every application, round and checklist item.',
              ),
              onTap: () async {
                final confirmed = await ConfirmDeleteDialog.show(
                  context,
                  'Delete all ${widget.applications.length} '
                  'application(s)? This cannot be undone.',
                );
                if (!confirmed) return;
                await widget.service.clearAllData();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data cleared')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Storage'),
              subtitle: Text(
                '${widget.applications.length} application(s) stored '
                'on this device only.',
              ),
            ),
          ],
        ),
        SettingsSection(
          title: 'About',
          children: const [
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('ApplyTrack 1.0.0'),
              subtitle: Text(
                'Local-first job and internship tracker. '
                'No account, no server, no demo data.',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
