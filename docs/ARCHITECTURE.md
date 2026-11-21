# Architecture

ApplyTrack is a small local-first Flutter app. Screens stay thin; logic
lives in pure services that are easy to unit test.

## Layers

- `lib/models/` — plain data classes (`Application`, `InterviewRound`,
  `ChecklistItem`, `AppStats`) with `toMap` / `fromMap` for SQLite.
  Enums (`ApplicationStatus`, `JobType`, `WorkMode`, `ApplicationSource`,
  `SalaryPeriod`) carry their own labels and rules.
- `lib/data/` — `AppDatabase` opens SQLite and creates the tables;
  `ApplicationDao`, `InterviewDao`, `ChecklistDao` do CRUD. DAOs take a
  `Database` in the constructor so tests can pass an in-memory one.
- `lib/services/` — `ApplicationService` orchestrates DAO + reminders;
  `StatsService`, `DeadlineService`, `ReminderCalculator`,
  `FollowUpHelper`, `DuplicateDetector`, `ResponseTime`,
  `ApplicationStreak`, `NextInterview` are pure functions over lists.
  `NotificationService` wraps `flutter_local_notifications`;
  `LinkService` wraps `url_launcher`; `CsvExportService` writes the CSV.
- `lib/utils/` — `AppDates`, `Money` (whole rupees, no floats),
  `Validators`, `StatusFlow`, `CsvBuilder`, `AppFilter`, `SortOption`,
  `Formatters`, `StringUtils`, `SalaryInsights`, `ApplicationAge`,
  `ReminderLeadOptions`, `ExportFilename`, `AppConstants`.
- `lib/widgets/` — small reusable pieces (cards, chips, bars, previews).
- `lib/screens/` — `HomeScreen` (bottom nav shell, loads data),
  `DashboardScreen`, `ApplicationsScreen`, `DeadlinesScreen`,
  `StatsScreen`, `SettingsScreen`, `AddEditApplicationScreen`,
  `ApplicationDetailScreen`, `AddRoundScreen`.

## Rules

- The app starts empty. No seed or demo data anywhere.
- No network calls except opening a job link the user saved.
- Reminders are best-effort: if scheduling fails, the app still works.
- Money is always whole rupees; salary parsing accepts `45k` and `4.5L`.
