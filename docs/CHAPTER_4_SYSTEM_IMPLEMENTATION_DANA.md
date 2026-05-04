# Chapter 4 — System Implementation (Dana)

> Draft aligned with **Chapters 1–3** in `Grad-doc-pages-2.pdf` (official Dana graduation document).  
> Section layout follows the same pattern as the reference dissertation in `Graduation project.pdf`: **4.1 Introduction**, **4.2 Tools and Languages**, **4.3 Main implementation** (front-end / back-end).

---

## Chapter 4. System Implementation

### 4.1 Introduction

**System implementation** is the phase of the software life cycle in which the system design is transformed into executable software: modules are coded, integrated with persistence and **REST APIs over HTTPS**, and validated against the **functional and non-functional requirements** and the **architectural and UI design** described in Chapters 2 and 3 of this document (`Grad-doc-pages-2.pdf`).

**Dana** is an integrated **child development support system** for parents of children from **birth through early childhood (zero to seven years)**, combining growth and health monitoring, developmental and sensory screening support, AI-assisted guidance, appointment booking with verified specialists, and educational resources, as defined in **Chapter 1 (Introduction, Objectives, and Scope)** and **Chapter 2 (Requirements and Analysis)**.

Implementation realizes the **client–server architecture** defined in **Chapter 3.2 (Architecture Design)**:

| Layer | As specified in Chapter 3 |
|--------|---------------------------|
| **Parent client** | Mobile application (**Flutter**) |
| **Professional / admin clients** | **Two separate** **React + Vite** web applications: one for the **doctor** dashboard and one for **administration** (see **Chapter 3.4**, Figures 55–64 for the doctor-facing UI; admin flows follow **Chapter 2** use cases such as *Approve/Deny Doctor Request* for **Super Admin**) |
| **Backend** | **Node.js** with **NestJS** |
| **Database** | **MongoDB** |
| **Communication** | **REST APIs** over HTTPS |
| **Security** | **JWT** authentication and **role-based access control (RBAC)** for parents, doctors, and administrators |

The mobile client may additionally use **real-time** libraries (e.g. **Socket.IO** client) where the backend exposes matching channels for chat or live notifications, consistent with the **Messaging** and **Notifications** components in Chapter 3.2.1.

Practical implementation work also includes environment configuration (development / demonstration), base-URL configuration for the Flutter app (e.g. `API_BASE_URL` via `--dart-define`), integration with external services where applicable (payment gateway, OAuth providers, optional crash reporting), and iterative testing in line with the **Agile** approach described in **Chapter 2.4**.

**Goal:** deliver a coherent implementation of the Dana platform that satisfies the requirements in Chapter 2 and the structure in Chapter 3, within the scope of the graduation project.

---

### 4.2 Tools and Languages

The toolchain matches **Chapter 3.2** and extends it with concrete libraries used in the Flutter repository and standard engineering tools.

#### 4.2.1 Flutter (Dart) — Parent mobile application

- **Flutter** and **Dart**: cross-platform mobile UI for **Android** (and iOS where targeted), as stated in Chapter 1.5 and Chapter 3.2.
- The implemented parent app includes, among others (see `pubspec.yaml` in the Dana mobile codebase): **flutter_bloc** and **provider** for state management, **get_it** for dependency injection, **dio** for HTTP calls to the NestJS API, **shared_preferences** and **flutter_secure_storage** for local data, **flutter_localizations** and **intl** for language support, **IBMPlexSansArabic** for Arabic typography, chart and media packages for growth visualization and the **Resource Center**, **socket_io_client** for real-time features when enabled on the server, and **sentry_flutter** for optional production monitoring.

**Rationale:** Flutter supports a **mobile-first** experience for parents, responsive layouts, and **RTL** layouts required for Arabic, in line with Chapter 2 **usability** and **compatibility** requirements.

#### 4.2.2 Web — Doctor dashboard and administration (React + Vite)

- **Doctor Panel** and **Admin Panel** are **two independent** **React** applications, each bootstrapped and built with its own **Vite** project (`vite.config.ts`, dedicated `package.json`, and separate `vite` / `vite build` pipelines). This keeps doctor and Super Admin concerns isolated, allows independent versioning and deployment, and still targets the same **NestJS REST API** over HTTPS with **JWT** and **RBAC**.
- **Doctor-facing web UI** covers flows such as login, partnership application, dashboard, patient profile, schedule, consultation, chat, and settings (**Chapter 3.4**, Figures 55–62).
- **Administrative web UI** supports **Super Admin** scenarios from Chapter 2 (e.g. reviewing and approving or denying doctor registration requests) and broader **Administration Panel** requirements (user management, monitoring, moderation).

**Rationale:** Web clients suit **keyboard-heavy** scheduling, review of clinical or partnership documents, and administrative oversight on large screens; **split Vite projects** reduce accidental coupling between clinical and platform-admin code.

#### 4.2.3 Backend — Node.js with NestJS

- **NestJS** on **Node.js** implements server-side logic, modular services, validation, and guards for **JWT** and **RBAC**, as described in **Chapter 3.2** and the **server components** in **Chapter 3.2.2** (Authentication Manager, Doctor Management Service, Appointment Service, Payment Service, AI Processing Service, Notification Service, Data Management).

#### 4.2.4 Database — MongoDB

- **MongoDB** stores application documents and relationships modeled in the system’s **ERD (Chapter 3.3.3, Figure 34)** and supports the **Data Management** component (Chapter 3.2.2).

#### 4.2.5 Supporting tools

- **Git / GitHub** — version control and collaboration.
- **Postman** and/or **Swagger (OpenAPI)** — contract testing and API documentation for NestJS.
- **IDEs** — VS Code, Android Studio, or WebStorm as used by the team.
- **Vite** — `vite` dev server and `vite build` run **per project** (doctor app and admin app each has its own config); environment variables (e.g. `VITE_API_BASE_URL`) in each project for per-environment API endpoints.
- **Flutter** — `--dart-define=API_BASE_URL=...` (and related defines) to target the correct API host per environment without embedding secrets in source.

---

### 4.3 Main / Most Important Implementation Areas

Use this section in the final thesis with **screenshots** aligned to **Chapter 3.4 (User Interface Design)** where possible, plus short **code excerpts** for NestJS modules/controllers and key Flutter widgets or BLoCs. **§B** and **§C** below map to the **two separate React + Vite** repositories (doctor vs admin).

#### 4.3.1 Front-end implementation

**A — Parent application (Flutter — Mobile)**  
*Map screenshots to Chapter 3.4 figures where applicable.*

| # | Topic | Chapter 3.4 reference (examples) |
|---|--------|----------------------------------|
| 1 | Splash, onboarding | Figures 35–36 |
| 2 | Signup, login, forgot password | Figures 37–39 |
| 3 | Home | Figure 40 |
| 4 | Doctor chat, AI chatbot | Figures 41–42 |
| 5 | Booking flow | Figures 43–44 |
| 6 | Online payment (Visa / wallet UI) | Figures 45–46 |
| 7 | My bookings list | Figure 47 |
| 8 | Examination (e.g. sensory / developmental) | Figure 48 |
| 9 | Books, videos (resource center) | Figures 49–50 |
| 10 | Child profile, vaccinations | Figures 51–52 |
| 11 | Parent profile, technical support | Figures 53–54 |

**B — Doctor web application**  
*Figures 55–64 in Chapter 3.4.*

| # | Topic |
|---|--------|
| 1 | Doctor login |
| 2 | Doctor partnership application |
| 3 | Dashboard |
| 4 | Patient profile |
| 5 | Doctor schedule |
| 6 | Consultation |
| 7 | Chat |
| 8 | Settings |
| 9 | Scheduling / notifications (as in Figures 63–64) |

**C — Administrative web application**

| # | Topic |
|---|--------|
| 1 | Super Admin login and secure access |
| 2 | Pending doctor requests; approve / deny workflow |
| 3 | User management (parents, doctors), bans/restrictions if implemented |
| 4 | Platform monitoring, reports/analytics per Chapter 2.2.1 item 13 |

---

#### 4.3.2 Back-end implementation

Present **numbered items** with short descriptions and **code snippets** or screenshots of NestJS controllers, services, DTOs, and guards. Group endpoints to mirror **Chapter 3.2.2 (Server components)**:

1. **Authentication Manager** — registration, login, OTP, JWT issuance, refresh (if any), password reset; integration with **RBAC** for Parent, Doctor, Admin / Super Admin.
2. **Doctor Management Service** — doctor profiles, partnership applications, verification status, availability.
3. **Appointment Service** — booking, reschedule, cancel, calendar slots, linkage to parents and doctors.
4. **Payment Service** — invoices, payment intent, gateway callbacks, transaction records (**Payment** / **Transaction** classes per Chapter 3.2.2).
5. **AI Processing Service** — chatbot and analysis endpoints (**AI Engine** / model integration per Chapter 3.2.2); align wording with Chapter 2 AI requirements.
6. **Notification Service** — push/in-app/email triggers for appointments, vaccinations, milestones, and admin decisions.
7. **Data Management** — MongoDB persistence through schemas/models/repositories; consistency rules for child records, growth series, and medical documents.
8. **Cross-cutting concerns** — HTTPS, input validation, logging, and avoidance of sensitive data in logs (Chapter 2 **Security** and **Privacy**).

**Flutter integration note:** the mobile app should use a single HTTP client (**Dio**) with interceptors for attaching **JWT** tokens and handling standardized errors, calling paths consistent with the NestJS API version prefix used in development (e.g. `/v1/...` as configured in the mobile codebase).

---

### Summary

Chapter 4 describes how the **Dana** platform is implemented in code and tools: a **Flutter** parent application, **two React + Vite** web applications (**Doctor Panel** and **Admin Panel**), a **NestJS** backend on **Node.js**, **MongoDB** persistence, **REST** over **HTTPS**, and **JWT + RBAC** security—matching **Chapters 1–3** of this graduation document—and lists the main UI and server modules to illustrate with screenshots and excerpts in the bound thesis.

---

### Pre-submission checklist

- [ ] Every technology name in §4.2 matches **Chapter 3.2** (Flutter, NestJS, MongoDB, REST, JWT, RBAC), with **React + Vite** documented in §4.2.2 for the web tier.
- [ ] Screenshot numbering in §4.3.1 aligns with **Chapter 3.4** figure captions after any figure renumbering in Word.
- [ ] **Chapter 3** text is updated if the examination committee expects the architecture section to name **React** and **Vite** explicitly (currently Chapter 3.2 lists Flutter only under “Frontend”; the web stack is detailed here in Chapter 4).
- [ ] API examples in the thesis use **non-production** hosts; no live secrets or card data in samples.
