## Dana (DANA-ضنا) — Wiring status tracker

This document uses `Dana.postman_collection.json` as the current API contract.

### Environments (from Postman variables)
- **local**: `http://localhost:3000/api/`
- **dana (prod)**: `http://3.75.188.99:3000/api/`
- **Rule**: all mobile endpoints are called as: `BASE_URL` + `/v1/...`

---

## ✅ Fully wired (implemented + DI + used in app flow)

### Auth + session (mobile)
- **POST** `/v1/parent/pre-signIn`
- **POST** `/v1/parent/verify-signIn` → extracts token from `accessToken.access_token`
- **POST** `/v1/parent/pre-SignUp` (multipart `data` + optional `file`)
- **POST** `/v1/parent/verify-signUp`
- **POST** `/v1/parent/reset-password`
- **POST** `/v1/parent/verify-password-otp`
- **POST** `/v1/parent/change-password` (Bearer)

**What’s done**
- **Secure token storage**: `flutter_secure_storage`
- **Session**: token persisted on login success
- **Dio interceptor** adds `Authorization: Bearer <jwt>` automatically
- **Splash auth gate**: token → Home, else → Onboarding
- **Login bug fixed**: failure no longer navigates to Home

Key files:
- `lib/core/auth/auth_session.dart`
- `lib/core/auth/token_storage.dart`
- `lib/core/auth/dio_auth_interceptor.dart`
- `lib/core/di/injection_container.dart`
- `lib/features/auth/login/...`
- `lib/features/splash/views/screens/splash_screen.dart`

### Parent profile (mobile)
From Postman folder: `parentMe`
- **GET** `/v1/parentMe` (Bearer expected in Postman examples)
- **POST** `/v1/parentMe/addChild` (Bearer, JSON: `childName`, `gender`, `birthDate`)
- **PATCH** `/v1/parentMe/updateChild/:childId` (Bearer, multipart `data` + `file`)

**What’s done**
- Remote datasource + repository + cubit implemented
- `ProfileSection` now loads real `parentMe` data and add-child calls backend

Key files:
- `lib/features/parent_profile/data/datasources/parent_profile_remote_data_source_impl.dart`
- `lib/features/parent_profile/presentation/cubit/parent_profile_cubit.dart`
- `lib/features/parent_profile/presentation/screens/profile_section.dart`

### Booking (mobile) — rating wired
- **POST** `/v1/booking/:bookingId/rate` (✅ confirmed POST by you)
- **DELETE** `/v1/booking/cancel/child/:childId` ✅ (wired + used in Appointments UI cancel)
- **PATCH** `/v1/booking/:id` ✅ (wired + used in Change Appointment flow)
- **GET** `/v1/booking/:id` ✅ (wired in data layer)

Key files:
- `lib/features/booking/data/services/booking_service.dart`
- `lib/features/booking/presentation/cubit/booking_cubit.dart`

### Child vaccination “take” (mobile)
- **PATCH** `/v1/child/:childId/childVaccinations/:vaccinationId/take` (✅ confirmed PATCH by you)
### Child vaccination schedule (mobile)
- **GET** `/v1/child/:childId/childVaccinations` ✅ (wired + used in Vaccine screen)
- **POST** `/v1/child/:childId/childVaccinations/generate` ✅ (wired + UI fallback button)

Key files:
- `lib/features/vaccinations/data/services/child_vaccination_service.dart`
- `lib/features/vaccinations/data/repo/child_vaccination_repo.dart`
- `lib/features/vaccinations/data/services/child_vaccination_schedule_service.dart`
- `lib/features/vaccinations/presentation/cubit/vaccination_schedule_cubit.dart`
- `lib/features/vaccinations/presentation/screens/vaccine_page.dart`

### Skills checklist (mobile)
- **GET** `/v1/skills`
- **GET** `/v1/skills/:skillId/child/:childId/checklist`
- **POST** `/v1/skills/toggle/child/:childId`

**What’s done**
- Child profile screen now loads skills from backend.
- Skill checklist bottom sheet loads checklist and toggles items via backend.

Key files:
- `lib/features/child_profile/data/services/skills_service.dart`
- `lib/features/child_profile/data/repo/skills_repo.dart`
- `lib/features/child_profile/presentation/cubit/skills_cubit.dart`
- `lib/features/child_profile/presentation/bottom_sheets/skill_checklist_bottom_sheet.dart`
- `lib/features/child_profile/presentation/screens/child_profile_page.dart`

---

## 🟡 Partially wired (implemented but not connected to real UI data yet)

### Booking list
- Current service/repo includes:
  - **GET** `/v1/booking`
  - **GET** `/v1/booking/myAppointment/:parentId` (**Shape B**: `response.data` is the list)
- ✅ Appointments UI now loads from backend bookings and uses real `bookingId` for rating.

Blockers:
- Need to wire booking list to the appointments screens and map backend booking model → UI appointment model.

### Vaccinations UI
- Current vaccinations UI uses local `getVaccines()` mock list (no `childId`/`vaccinationId`).
- The “take” endpoint is wired but can’t be triggered meaningfully until we fetch real child vaccination schedule.

---

## ❗ Known issues / mismatches to resolve (contract + code)

### Postman inconsistencies (must confirm with backend or fix contract)
- Some requests have wrong method/url in Postman request definition but correct saved examples.
  - We already confirmed:
    - Booking rate is **POST**
    - Child vaccination take is **PATCH**

### Paymob callback
- Flutter constants comment says GET, Postman shows **POST**.
- Needs backend confirmation for mobile flow (often callback is server-to-server, not mobile).

### Duplicate API constants in codebase
- `lib/core/api/api_constant.dart` vs `lib/core/constant/api_constants.dart` (older)
- Should be unified later to avoid accidental wrong base URL.

---

## ⛔ Not wired yet (still in Postman contract)

### Booking (Postman folder: `Booking`)
- **DELETE** `/v1/booking/:id` (Bearer) *(available in data layer, not used in UI yet)*
- **GET** `/v1/booking/doctorAppointment/:doctorId` *(doctor panel may be web-only; confirm if needed for mobile)*
- *(optional)* **GET** `/v1/booking/todayDoctorAppointment/:doctorId` *(if mobile needs it; Postman folder includes it but response examples missing)*

### Child APIs (Postman folder: `child`) — big missing area
Vaccinations:
- **GET** `/v1/vaccinations`
- **POST** `/v1/vaccinations`
- **POST** `/v1/vaccinations/bulk`

Child vaccination schedule:
- **POST** `/v1/child/:childId/vaccinations/generate` *(alt path in Postman; confirm with backend — app uses `/v1/child/:childId/childVaccinations/generate`)*

Skills:
- **POST** `/v1/skills/items/bulk`

Growth/records:
- **GET** `/v1/child/:childId/growth` ✅ (wired + used in Growth curve chart)
- **GET** `/v1/child/:childId/growth/latest` ✅ (wired)
- **POST** `/v1/child/:childId/growth` ✅ (wired + used in Update Data bottom sheet)

### Sensory test (Postman folder: `sensory-test`)
- **POST** `/v1/sensory-test/` (insert questions — likely admin only)

### Videos (Postman folder: `videos`)
- **POST** `/v1/videos` *(likely admin only)*

### TextBooks (Postman folder: `textBooks`)
- **POST** `/v1/textBooks` *(likely admin only)*

### Google OAuth (Postman folder: `google`)
- **GET** `/v1/parent/google`
- **GET** `/v1/parent/google/callback`
- **GET** `/v1/parent/google/compelete` (with body in Postman)

### Doctor record analytics (Postman folder: `doctor-record`)
- Looks like web/doctor panel; skipped unless you confirm mobile needs it.

---

## Next wiring recommendations (mobile-first)
1) **Growth**: `/v1/child/:childId/growth` (connect GrowthCurveSection to backend)
2) **Vaccinations admin**: `/v1/vaccinations` (only if mobile needs it)
3) **Skills bulk items**: `/v1/skills/items/bulk` (admin-only unless you need it in mobile)
4) Google OAuth (only if you want in-app Google sign-in)

