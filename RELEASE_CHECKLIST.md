# Android release checklist (Play Store)

## 1) Prerequisites

- Install **Android SDK** and accept licenses (`flutter doctor --android-licenses`).
- Ensure `flutter doctor` is green for Android.

## 2) App identity

- Update `applicationId` in `android/app/build.gradle.kts` from `com.example.dana` to your real unique id.
- Update `android { namespace = ... }` accordingly.

## 3) Signing (required for Play Store)

This repo supports release signing via `android/key.properties` (not committed).

1) Create a keystore:

```bash
keytool -genkeypair -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2) Move it to `android/app/upload-keystore.jks`

3) Create `android/key.properties`:

```properties
storeFile=app/upload-keystore.jks
storePassword=YOUR_STORE_PASSWORD
keyAlias=upload
keyPassword=YOUR_KEY_PASSWORD
```

The Gradle build uses the release signing config when this file exists, otherwise it falls back to debug signing.

## 4) Environment config (backend)

Set backend base url at build time:

```bash
flutter build appbundle --release --dart-define=API_BASE_URL=http://3.75.188.99:3000/api
```

Optional crash reporting:

```bash
flutter build appbundle --release --dart-define=API_BASE_URL=http://3.75.188.99:3000/api --dart-define=SENTRY_DSN=YOUR_SENTRY_DSN
```

## 5) Versioning

- Update `version:` in `pubspec.yaml` (e.g. `1.0.1+2`)
- Ensure Play Console versionCode increases every upload.

## 6) Build artifacts

- AAB (recommended):

```bash
flutter build appbundle --release
```

- APK (QA only):

```bash
flutter build apk --release
```

## 7) Final pre-upload checks

- `dart format --output=none --set-exit-if-changed .`
- `flutter analyze`
- `flutter test`
- Smoke test critical flows on a real device (login, appointments, child profile, vaccines).

