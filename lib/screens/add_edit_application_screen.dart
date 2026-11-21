import 'package:material_ui/material_ui.dart';

import '../models/application.dart';
import '../models/application_status.dart';
import '../models/job_type.dart';
import '../models/salary_period.dart';
import '../models/source.dart';
import '../models/work_mode.dart';
import '../services/application_service.dart';
import '../services/duplicate_detector.dart';
import '../utils/money.dart';
import '../utils/validators.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/status_picker.dart';

/// Form to add a new application or edit an existing one.
class AddEditApplicationScreen extends StatefulWidget {
  const AddEditApplicationScreen({
    super.key,
    required this.service,
    this.existing,
    this.allApplications = const [],
  });

  final ApplicationService service;
  final Application? existing;
  final List<Application> allApplications;

  @override
  State<AddEditApplicationScreen> createState() =>
      _AddEditApplicationScreenState();
}

class _AddEditApplicationScreenState extends State<AddEditApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  late final TextEditingController _company;
  late final TextEditingController _role;
  late final TextEditingController _city;
  late final TextEditingController _salaryMin;
  late final TextEditingController _salaryMax;
  late final TextEditingController _jobUrl;
  late final TextEditingController _contactName;
  late final TextEditingController _contactEmail;
  late final TextEditingController _resumeVersion;
  late final TextEditingController _notes;

  var _jobType = JobType.fullTime;
  var _workMode = WorkMode.onsite;
  var _salaryPeriod = SalaryPeriod.monthly;
  var _source = ApplicationSource.other;
  var _status = ApplicationStatus.wishlist;
  DateTime? _dateApplied;
  DateTime? _deadline;
  DateTime? _followUpDate;
  var _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _company = TextEditingController(text: existing?.company ?? '');
    _role = TextEditingController(text: existing?.role ?? '');
    _city = TextEditingController(text: existing?.city ?? '');
    _salaryMin = TextEditingController(
      text: existing == null || existing.salaryMin <= 0
          ? ''
          : '${existing.salaryMin}',
    );
    _salaryMax = TextEditingController(
      text: existing == null || existing.salaryMax <= 0
          ? ''
          : '${existing.salaryMax}',
    );
    _jobUrl = TextEditingController(text: existing?.jobUrl ?? '');
    _contactName = TextEditingController(text: existing?.contactName ?? '');
    _contactEmail = TextEditingController(text: existing?.contactEmail ?? '');
    _resumeVersion =
        TextEditingController(text: existing?.resumeVersion ?? '');
    _notes = TextEditingController(text: existing?.notes ?? '');
    if (existing != null) {
      _jobType = existing.jobType;
      _workMode = existing.workMode;
      _salaryPeriod = existing.salaryPeriod;
      _source = existing.source;
      _status = existing.status;
      _dateApplied = existing.dateApplied;
      _deadline = existing.deadline;
      _followUpDate = existing.followUpDate;
    }
  }

  @override
  void dispose() {
    _company.dispose();
    _role.dispose();
    _city.dispose();
    _salaryMin.dispose();
    _salaryMax.dispose();
    _jobUrl.dispose();
    _contactName.dispose();
    _contactEmail.dispose();
    _resumeVersion.dispose();
    _notes.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  DropdownButtonFormField<T> _dropdown<T>(
    String label,
    T value,
    List<T> values,
    String Function(T) labelOf,
    ValueChanged<T?> onChanged,
  ) {
    return DropdownButtonFormField<T>(
      key: ValueKey(value),
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: values
          .map(
            (item) => DropdownMenuItem(value: item, child: Text(labelOf(item))),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _save() async {
    // A ListView disposes fields scrolled off-screen, so Form.validate()
    // only sees the fields currently built. Check the required values
    // from their controllers first; when one is empty, scroll it into
    // view and run validation on the next frame so the error renders.
    if (_company.text.trim().isEmpty || _role.text.trim().isEmpty) {
      _scrollController.jumpTo(0);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _formKey.currentState!.validate();
      });
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    final salaryError =
        Validators.salaryRange(_salaryMin.text, _salaryMax.text);
    if (salaryError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(salaryError)),
      );
      return;
    }
    setState(() => _saving = true);
    final app = (widget.existing ??
            Application(company: '', role: ''))
        .copyWith(
      company: _company.text.trim(),
      role: _role.text.trim(),
      jobType: _jobType,
      workMode: _workMode,
      city: _city.text.trim(),
      salaryMin: Money.parseRupees(_salaryMin.text) ?? 0,
      salaryMax: Money.parseRupees(_salaryMax.text) ?? 0,
      salaryPeriod: _salaryPeriod,
      jobUrl: _jobUrl.text.trim(),
      source: _source,
      dateApplied: _dateApplied,
      deadline: _deadline,
      status: _status,
      followUpDate: _followUpDate,
      contactName: _contactName.text.trim(),
      contactEmail: _contactEmail.text.trim(),
      resumeVersion: _resumeVersion.text.trim(),
      notes: _notes.text.trim(),
    );
    final duplicates = DuplicateDetector.findDuplicates(
      widget.allApplications,
      app,
    );
    if (duplicates.isNotEmpty && mounted) {
      final goAhead = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Possible duplicate'),
          content: Text(
            'You already track ${duplicates.first.company} — '
            '${duplicates.first.role} (${duplicates.first.status.label}). '
            'Save anyway?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Save anyway'),
            ),
          ],
        ),
      );
      if (goAhead != true) {
        setState(() => _saving = false);
        return;
      }
    }
    if (_isEdit) {
      await widget.service.updateApplication(app);
    } else {
      await widget.service.createApplication(app);
    }
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit application' : 'Add application'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _company,
              decoration: const InputDecoration(labelText: 'Company *'),
              textCapitalization: TextCapitalization.words,
              validator: Validators.company,
            ),
            TextFormField(
              controller: _role,
              decoration: const InputDecoration(labelText: 'Role *'),
              textCapitalization: TextCapitalization.words,
              validator: Validators.role,
            ),
            const SizedBox(height: 8),
            _dropdown<JobType>(
              'Type',
              _jobType,
              JobType.values,
              (value) => value.label,
              (value) {
                if (value != null) setState(() => _jobType = value);
              },
            ),
            _dropdown<WorkMode>(
              'Work mode',
              _workMode,
              WorkMode.values,
              (value) => value.label,
              (value) {
                if (value != null) setState(() => _workMode = value);
              },
            ),
            TextFormField(
              controller: _city,
              decoration: const InputDecoration(labelText: 'City'),
              textCapitalization: TextCapitalization.words,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _salaryMin,
                    decoration: const InputDecoration(
                      labelText: 'Min salary (Rs.)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _salaryMax,
                    decoration: const InputDecoration(
                      labelText: 'Max salary (Rs.)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            _dropdown<SalaryPeriod>(
              'Salary period',
              _salaryPeriod,
              SalaryPeriod.values,
              (value) => value.label,
              (value) {
                if (value != null) setState(() => _salaryPeriod = value);
              },
            ),
            _dropdown<ApplicationSource>(
              'Found via',
              _source,
              ApplicationSource.values,
              (value) => value.label,
              (value) {
                if (value != null) setState(() => _source = value);
              },
            ),
            TextFormField(
              controller: _jobUrl,
              decoration: const InputDecoration(labelText: 'Job link'),
              keyboardType: TextInputType.url,
              validator: Validators.jobUrl,
            ),
            const SizedBox(height: 8),
            StatusPicker(
              value: _status,
              onChanged: (value) {
                if (value != null) setState(() => _status = value);
              },
            ),
            DatePickerField(
              label: 'Date applied',
              value: _dateApplied,
              onPick: (value) => setState(() => _dateApplied = value),
            ),
            DatePickerField(
              label: 'Application deadline',
              value: _deadline,
              onPick: (value) => setState(() => _deadline = value),
            ),
            DatePickerField(
              label: 'Follow-up date',
              value: _followUpDate,
              onPick: (value) => setState(() => _followUpDate = value),
            ),
            TextFormField(
              controller: _contactName,
              decoration: const InputDecoration(labelText: 'Contact person'),
            ),
            TextFormField(
              controller: _contactEmail,
              decoration: const InputDecoration(labelText: 'Contact email'),
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            TextFormField(
              controller: _resumeVersion,
              decoration: const InputDecoration(
                labelText: 'Resume version used',
              ),
            ),
            TextFormField(
              controller: _notes,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEdit ? 'Save changes' : 'Add application'),
            ),
          ],
        ),
      ),
    );
  }
}
