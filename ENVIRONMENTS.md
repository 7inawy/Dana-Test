# Environments / API base URL

This app reads the backend base URL from a **Dart define**:

- `API_BASE_URL` (must include `/api`, must exclude `/v1`)

The HTTP client uses:

- `AppConfig.apiBaseUrl` in `lib/core/config/app_config.dart`

## Run (debug)

```bash
flutter run --dart-define=API_BASE_URL=http://3.64.255.173:3000/api
```

## Build APK (release)

```bash
flutter build apk --release --dart-define=API_BASE_URL=http://3.75.188.99:3000/api
```

## Build AAB (release)

```bash
flutter build appbundle --release --dart-define=API_BASE_URL=http://3.75.188.99:3000/api
```

## Notes

- Don’t hardcode base URLs in code (ngrok/local URLs should never ship).
- In **release**, `AppConfig.validate()` will warn if `API_BASE_URL` is `http://...` (non-HTTPS).

