# Agent Context Updater (Read this first)

This file is a **handoff snapshot** for any new Cursor agent session.

## Repo + current state
- **Workspace root**: `d:/اللهم التخرج/Dana_App-flutter/Dana_App-flutter`
- **Git remote (origin)**: `https://github.com/7inawy/Dana-Test.git`
- **Branch**: `main`
- **Upstream state**: `main...origin/main` (synced)
- **HEAD**: `e1155ea06fc8ab1fa359996aa6666946d5cbe908` (2026-04-22 02:19:04 +0200)
- **Working tree changes (uncommitted)**:
  - `Dana.postman_collection.json` (**modified**) — `1 file changed, 1201 insertions(+), 187 deletions(-)`

## Toolchain (Windows)
- **Flutter**: 3.41.7 (stable)
- **Dart**: 3.11.5
- **Health**: `flutter analyze` ✅ (no issues found)
- **Note**: `flutter doctor` reports **Android SDK missing** (Windows + web targets are available).

## API base URL config (important)
The app’s new wiring uses `AppConfig.apiBaseUrl`:

- `lib/core/config/app_config.dart`
  - `API_BASE_URL` via `--dart-define`
  - default: `http://3.64.255.173:3000/api`

**Beware**: there is also an older `ApiConstants.baseUrl` in `lib/core/constant/api_constants.dart` (ngrok). Prefer `AppConfig.apiBaseUrl` for new code to avoid “wrong base URL” bugs.

## What was recently wired (high-signal)
The focus of the latest work is: **Child Profile** is now wired to the **selected child** and uses **real API data** (growth + skills + vaccines) in a way that matches the UI.

### Latest commits to know
- `e1155ea` — **Align child profile UI with real skills and measurement flows**
  - Skills overview + cards now reflect **real checklist completion**.
  - Skill expand opens the **real checklist sheet** with bloc context.
  - Update measurements bottom sheet is now **context-safe** and opens consistently.
- `0d6a313` — **Wire child profile to selected child and real API data**
  - Introduced route args and optional `childId` plumbing end-to-end.
- Earlier relevant commits:
  - `9e21999` — `parentMe` wired (GET/PATCH/addChild), profile tab uses real data
  - `81dc070` — appointments wired (change/cancel/rebook/rate)

## Child Profile: current behavior (where to look)

### Navigation + route args
- **Args DTO**: `lib/features/child_profile/child_profile_args.dart` (`ChildProfileArgs`)
- **Routes**: `lib/my_app.dart`
  - `AppRoutes.childProfile` reads `ChildProfileArgs` from `settings.arguments`
  - `AppRoutes.vaccine` reads optional `String childId` from `settings.arguments`
- **Entry points passing args**:
  - Home header button: `lib/features/home/presentation/views/screens/home_screen.dart`
  - Profile quick access tile: `lib/features/parent_profile/presentation/widgets/profile_quick_access.dart`

### Data loading (real backend)
- Screen: `lib/features/child_profile/presentation/screens/child_profile_page.dart`
  - Creates 3 cubits and loads with `args?.childId`:
    - `GrowthCubit.load(childId: ...)`
    - `SkillsCubit.loadSkills(childId: ...)`
    - `VaccinationScheduleCubit.load(childId: ...)`

### UI wiring vs. “mock-looking UI”
- **Measurements**:
  - `ChildInfoCard` shows latest height/weight/head from growth records
  - `GrowthCurveSection` chart uses real records
  - Update measurements uses **`showUpdateMeasurementsBottomSheet(context)`**
    - Defined in: `lib/features/child_profile/presentation/bottom_sheets/update_data_bottom_sheet.dart`
    - Posts a new growth record via `GrowthCubit.submit(...)`
- **Skills**:
  - `SkillsCubit` now loads per-skill checklist progress maps:
    - `skillCheckedById` and `skillTotalById`
  - `SkillsOverviewCard` uses real checklist completion %
  - `SkillsHorizontalList` shows `done/total` and opens the checklist bottom sheet
- **Vaccines**:
  - `NextVaccineCard` shows next pending schedule item from `VaccinationScheduleCubit`
  - `VaccineScreen` accepts optional `childId`

## Backend/API contract trackers
- **Mobile wiring tracker**: `docs/WIRING_STATUS.md` (source of truth for “what endpoints are wired”)
- **Backend blockers list**: `docs/BACKEND_WORK_ITEMS.md`

## Known TODOs / gaps (don’t re-break these)
- **Multiple children selection**: currently, most entry points pick `children.first` for convenience; if UI adds selection, always pass the selected child’s id via `ChildProfileArgs`.
- **Vaccinations**: schedule is wired; anything under “vaccinations admin” endpoints may still be out of scope for mobile.
- **Response shape inconsistencies**: backend sometimes returns different envelopes; code has shape guards in some services (don’t remove them casually).

## Notes on Postman collection
`Dana.postman_collection.json` changes can be noisy (export metadata, request/response ids). If it churns frequently, consider keeping a stable “source of truth” export format or committing only intentional changes.

## Quick commands
- **Analyze**: `flutter analyze`
- **Tests**: `flutter test`
- **Run (override API base url)**:
  - `flutter run --dart-define=API_BASE_URL=http://3.75.188.99:3000/api`

