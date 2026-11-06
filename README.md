# Medtrack

A clinical-grade personal medication management and adherence tracking platform built with Flutter and Clean Architecture.

Developed and maintained by **Hamas** ([hamasdmc@gmail.com](mailto:hamasdmc@gmail.com)).

---

## Overview

Medication non-adherence is one of the most persistent hurdles in modern outpatient medicine. Missed doses, irregular scheduling, unmonitored treatment courses, and lack of contextual administration (such as meal requirements, vitals observation, or drug contraindications) frequently lead to preventable health setbacks.

**Medtrack** was engineered to solve this challenge with clinical precision and architectural dependability. Rather than functioning as a generic calendar alarm, Medtrack acts as a personal clinical companion: calculating cyclical dose intervals, screening against known patient allergies, tracking antibiotic and taper courses, providing overdue dose guidance, logging paired biometric vitals, managing prescription inventory, and generating verifiable adherence reports for healthcare providers.

---

## Clinical & Functional Capabilities

### Surgical Dose Scheduling Engine
* **Multi-Interval Support:** Accurately schedules daily, weekly, bi-weekly, monthly, or custom cyclical regimens (e.g., tapering courses or alternating-day therapy).
* **Exact Time Alarms:** Utilizes Android exact alarm APIs (`SCHEDULE_EXACT_ALARM`) and high-importance notification channels to ensure alerts fire reliably, even in device low-power idle states.
* **Meal Context Guidance:** Associates each dose with specific administration instructions: *Before Breakfast*, *With Meal*, *After Dinner*, or *No meal requirement*.
* **Full Regimen Editing:** Modify dosages, schedules, frequencies, and duration parameters of existing medications in-place without losing historical adherence logs.

### Clinical Safety, Overdue Guidance & Allergy Screening
* **Contraindication Guardrails:** Intercepts medication creation and cross-references drug names against the patient's documented allergy profile.
* **Class Conflict Alerts:** Flags high-risk classes including penicillins, sulfa compounds, NSAIDs, opioids, and cephalosporins, requiring explicit acknowledgment before scheduling.
* **Overdue Clinical Guidance:** Automatically flags doses delayed by over 60 minutes with an **OVERDUE** badge. Provides actionable, clinical guidance on whether to take or hold the missed dose to prevent dangerous accidental double-dosing.

### Course Completion & Taper Tracking
* **Course Progress Bar:** Visualizes duration-based prescriptions (e.g., antibiotics, steroid tapers) with day-by-day progress indicators (`Day X of Y • Z days remaining`).
* **Active vs. Paused Management:** Preserves finished and temporarily suspended therapies while maintaining continuous visibility in the medication roster.

### Biometric Vitals & Adherence Observations
* **Paired Physiological Logging:** Record vital signs alongside medication intake—including Blood Pressure (systolic/diastolic), Heart Rate (BPM), and Blood Glucose (mg/dL)—for comprehensive cardiovascular and metabolic monitoring.
* **Structured Skip Reason Logging:** Patients rarely miss medication randomly. Medtrack captures specific clinical rationales:
  * Adverse side effects or nausea
  * Fasting or medical procedures
  * Temporary supply unavailability
  * Physician instructions to hold therapy
* **Snooze Protocol:** Provides a 30-minute grace window for real-world flexibility without falsely marking a dose as missed.
* **Adherence Heatmap:** Live-updating GitHub-style annual adherence heatmap reflecting daily intake compliance in real time.

### Clinician-Ready PDF Reporting
* **Standardized Adherence Summaries:** Exports multi-page, formatted medical reports directly from the app.
* **KPI Adherence Scoring:** Calculates overall percentage adherence, active medication counts, and doses taken versus omitted.
* **Biometric & Regimen Tables:** Formats full prescription regimens, logged physiological observations (blood pressure, glucose, heart rate), tolerability side effects, and up to 50 intake audit records for physician consultations.

### Inventory & Refill Warnings
* **Depletion Tracking:** Automatically decrements pill counts upon dose confirmation.
* **Refill Warnings & Quick Replenishment:** Highlights low-stock medications once remaining quantities hit custom thresholds, enabling single-tap stock refills that immediately sync across local and cloud stores.

### Offline-First Architecture & Emergency Profile
* **Zero-Latency Offline Mode:** All core scheduling, timeline generation, dose reconciliation, and logging operate completely offline via SQLite and local cache.
* **Emergency Medical ID:** Stores blood type, allergies, and emergency contact information locally with encrypted access, ensuring vital health data is immediately accessible offline or during guest usage.
* **Hardware-Gated Security:** Protects sensitive medical records behind native biometric authentication (fingerprint, Face ID, device PIN).

---

## Architectural & Technical Design

Medtrack is built with strict adherence to **Feature-First Clean Architecture**, ensuring clear separation of concerns, testability, and enterprise maintainability:

```text
Medtrack/
├── android/                          # Native Android runner (Java 17, ProGuard, Desugaring)
├── assets/                           # Curated production image and icon assets
├── lib/
│   ├── firebase_options.dart         # Android Firebase platform configuration
│   ├── main.dart                     # Application entrypoint & initialization
│   └── src/
│       ├── core/
│       │   ├── navigation/           # Declarative routing with GoRouter
│       │   ├── services/             # Local database, notifications, alarms, auth
│       │   ├── theme/                # Deep midnight cinematic theme & typography
│       │   ├── utils/                # Standardized animation & motion curves
│       │   └── widgets/              # Atmospheric ambient backgrounds & common UI
│       └── features/
│           ├── authentication/       # Biometric gate & auth state providers
│           ├── daily_dashboard/      # Timeline, dose cards, vitals, low-stock banners
│           ├── gamification/         # Streaks, milestones, adherence heatmaps
│           ├── history_tracking/     # Monthly calendar & clinical PDF export
│           ├── medication_management/# Dose scheduler, allergy checker, medicine forms
│           ├── navigation/           # App shell, navigation bar, menus & security
│           └── weather/              # Real-time ambient weather integration
└── test/
    ├── unit/                         # Dose scheduler & drug interaction unit tests
    ├── widget/                       # Form validation and UI widget tests
    └── widget_test.dart              # Core application smoke test
```

### Core Technology Stack

| Component | Technology | Role |
| :--- | :--- | :--- |
| **Framework** | Flutter 3.47+ & Dart 3.11+ | Cross-platform UI toolkit and language |
| **State Management** | Riverpod 3.x (`riverpod_generator`) | Reactive, compile-safe dependency injection |
| **Routing** | GoRouter 18.x | Declarative, branch-aware navigation |
| **Local Database** | SQLite (`sqflite`) & `shared_preferences` | Offline-first persistence and schema migrations |
| **Cloud Backend** | Firebase (Auth, Firestore, Storage) | Secure user accounts and cross-device sync |
| **Notifications** | `flutter_local_notifications` | Native Android exact alarm scheduling |
| **Biometrics** | `local_auth` / `local_auth_android` | Hardware-backed biometric authentication |
| **PDF Generation** | `pdf` & `printing` | Medical-grade PDF rendering and sharing |
| **Models** | Freezed & `json_serializable` | Immutable data models and JSON serialization |

---

## Getting Started

### Prerequisites
* [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.29.0 or later, Dart 3.11+)
* [Android Studio](https://developer.android.com/studio) with Android SDK and JDK 17
* Physical Android device (recommended for exact alarms and biometrics) or Android Emulator (API 33+)

### Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/hamas/Medtrack.git
   cd Medtrack
   ```

2. **Install project dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify static analysis and tests:**
   ```bash
   dart analyze
   flutter test
   ```

4. **Launch the application on Android:**
   ```bash
   flutter run
   ```

### Release Build

To generate an optimized release build with resource shrinking and ProGuard minification:

```bash
# Build standalone APK
flutter build apk --release

# Build Google Play App Bundle
flutter build appbundle --release
```

---

## Code Quality Standards

* **Strict Type Safety:** Configured with `strict-casts`, `strict-inference`, and `strict-raw-types`.
* **Zero Analyzer Warnings:** Maintained with clean passes across all Dart and Flutter linter rules.
* **Automated Test Coverage:** Includes unit tests for cyclical dose scheduling and drug-interaction safety logic, widget tests for medication entry workflows, and application rendering tests.

---

## Author & Contact

**Hamas**  
Lead Developer & Maintainer  
Email: [hamasdmc@gmail.com](mailto:hamasdmc@gmail.com)  
GitHub: [@hamas](https://github.com/hamas)

Contributions, feature requests, and issue reports are welcome via GitHub Issues.

---

## License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for complete details.

### Clinical Notice
Medtrack is intended solely as an informational personal medication and adherence management assistant. It is not a certified medical device and does not provide medical diagnosis, treatment planning, or clinical consultation. Users should always confirm medication regimens with their licensed physician or pharmacist.
