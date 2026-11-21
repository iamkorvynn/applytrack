# Release checklist

## Build the APK

```sh
flutter pub get
flutter analyze   # must be 0 issues
flutter test      # must be all green
flutter build apk --release
```

Builds run one at a time on this VM (RAM is tight). Use
`GRADLE_USER_HOME=~/workspace/overnight-8-apps/.gradle-home` and
`TMPDIR=~/workspace/daily-apps/.tmp`.

## Before handing the APK over

- `aapt2 dump badging` on the APK must list
  `android.permission.INTERNET` (job links open in the browser).
- Install on a real phone and check: add an application, move it
  through the pipeline, set a deadline, add a round, export CSV.
- Notifications are best-effort: if a reminder does not fire on a
  device, the deadlines screen still shows every date.

## Play Store upload (needs Numaan)

- A Google Play developer account is required; the APK is unsigned
  with the debug key for now (`signingConfig debug` in
  `android/app/build.gradle.kts`).
- Before upload, create a real release keystore and switch the release
  signing config to it. Never commit the keystore or its passwords.
- App name: ApplyTrack. Category: Productivity. The listing should say
  the app works fully offline and stores everything on-device.
