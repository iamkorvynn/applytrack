import 'package:material_ui/material_ui.dart';

import '../models/application.dart';
import '../services/csv_export_service.dart';
import '../utils/csv_builder.dart';
import '../widgets/settings_section.dart';

/// Theme, reminders, default salary period, CSV export.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.applications,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final List<Application> applications;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _exporting = false;
  String? _exportPath;

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
