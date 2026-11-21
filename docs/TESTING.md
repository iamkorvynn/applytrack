# Testing

Run the suite with:

```sh
flutter test
```

## What is covered

- **Models** — map round-trips, deadline maths, status flags, labels.
- **Utils** — date maths, INR formatting/parsing, validators, CSV
  escaping, sorting, filtering, salary insights, application age.
- **Data** — DAO CRUD, search, cascade delete, in-memory SQLite via
  `sqflite_common_ffi`.
- **Services** — stats, deadlines, reminders, follow-ups, duplicates,
  streaks, response time, next interview, prep templates, clear-all.
- **Widgets** — chips, cards, bars, empty states, dialogs, pickers.
- **Screens** — dashboard, applications list + search, deadlines,
  stats, settings, detail, add/edit form validation and save.

Widget tests use plain lists and in-memory databases; no test talks to
the network or the real notification plugin.
