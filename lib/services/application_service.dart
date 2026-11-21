import '../data/application_dao.dart';
import '../data/checklist_dao.dart';
import '../data/interview_dao.dart';
import '../models/application.dart';
import '../models/checklist_item.dart';
import '../models/interview_round.dart';
import 'notification_service.dart';
import 'prep_templates.dart';

/// Orchestrates database + reminders so screens stay thin.
class ApplicationService {
  ApplicationService({
    required this.applications,
    required this.rounds,
    required this.checklist,
    NotificationService? notifications,
  }) : _notifications = notifications ?? NotificationService.instance;

  final ApplicationDao applications;
  final InterviewDao rounds;
  final ChecklistDao checklist;
  final NotificationService _notifications;

  Future<int> createApplication(Application app, {int leadDays = 3}) async {
    final id = await applications.insert(app);
    final saved = app.copyWith(id: id);
    await _notifications.scheduleForApplication(saved, leadDays: leadDays);
    return id;
  }

  Future<void> updateApplication(Application app, {int leadDays = 3}) async {
    await applications.update(app);
    await _notifications.scheduleForApplication(app, leadDays: leadDays);
  }

  Future<void> deleteApplication(int id) async {
    await _notifications.cancelForApplication(id);
    await applications.delete(id);
  }

  /// Delete everything: all applications, rounds, checklist items,
  /// and cancel every reminder. Used by Settings > Clear all data.
  Future<void> clearAllData() async {
    await _notifications.cancelAll();
    final apps = await applications.getAll();
    for (final app in apps) {
      await applications.delete(app.id ?? -1);
    }
  }

  Future<int> addRound(InterviewRound round) =>
      rounds.insert(round);

  Future<void> updateRound(InterviewRound round) => rounds.update(round);

  Future<void> deleteRound(int id) => rounds.delete(id);

  Future<List<InterviewRound>> roundsFor(int applicationId) =>
      rounds.getForApplication(applicationId);

  Future<int> addChecklistItem(ChecklistItem item) =>
      checklist.insert(item);

  Future<void> toggleChecklistItem(ChecklistItem item) =>
      checklist.toggle(item);

  Future<void> deleteChecklistItem(int id) => checklist.delete(id);

  Future<List<ChecklistItem>> checklistFor(int applicationId) =>
      checklist.getForApplication(applicationId);

  /// Add the default prep tasks for a round type, if not already present.
  Future<void> addPrepTemplate(int applicationId, RoundType type) async {
    final existing = await checklist.getForApplication(applicationId);
    final titles = existing.map((item) => item.title).toSet();
    var order = existing.length;
    for (final title in PrepTemplates.titlesFor(type)) {
      if (titles.contains(title)) continue;
      await checklist.insert(
        ChecklistItem(
          applicationId: applicationId,
          title: title,
          sortOrder: order++,
        ),
      );
    }
  }
}
