# ApplyTrack

Track job and internship applications: pipeline, deadlines, interviews, stats.

## What it does

- **Applications** — add jobs and internships with company, role, type
  (full-time / internship / part-time), work mode, city, salary range,
  job link, source, contact, resume version and notes.
- **Pipeline** — Wishlist → Applied → Assessment → Interview → Offer,
  with Rejected / Withdrawn as terminal stages. Search, filter by status,
  sort by deadline, date applied or salary.
- **Dashboard** — total applied, interviews, offers, this week's count,
  upcoming deadlines, next interview, and applications needing a follow-up.
- **Deadlines** — grouped Overdue / Today / This week / Later, with local
  reminders before a deadline and on follow-up day.
- **Interviews** — rounds per application (HR, technical, managerial,
  assignment, final) with date/time, notes and outcome, plus a prep
  checklist with one-tap templates per round type.
- **Stats** — pipeline funnel, applications per week, response rate, top
  sources, application streak, average days to first interview, and
  salary insights (median / min / max yearly pay).
- **Export** — all applications to CSV, saved on the device.

## Data

Local SQLite only. The app starts **empty** — no demo or sample data.
No accounts, no network calls, no AI, no keys. Money is stored as whole
rupees (int), never floats.

## Tech

- Flutter 3.50, Dart, Material 3 (light + dark).
- Storage: `sqflite` (`sqflite_common_ffi` for tests).
- Reminders: `flutter_local_notifications` 22.3.3 + `timezone`.
- Settings: `shared_preferences`. Links: `url_launcher`.

## Build and test

```sh
flutter pub get
flutter analyze   # 0 issues
flutter test      # unit + widget tests
flutter build apk --release
```

The release APK needs `android.permission.INTERNET` in
`android/app/src/main/AndroidManifest.xml` (already added) so job links
can open in the browser.
