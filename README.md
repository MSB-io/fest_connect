# FestConnect — College Fest Event Registration App

**B.Tech Computer Science Engineering & AI — Semester V**  
**Subject:** Cross Platform Application  
**Case Study:** 7. FestConnect (College Fest Event Registration App)  
**Faculty / Guide:** Prof. Sneha Gawas  
**Institution:** ITM Skills University | School of Future Tech  

---

## 1. Problem Statement & Motivation
University college fests feature diverse cultural, technical, and sports competitions. Conventional manual registration counters lead to long queues, human error, duplicate signups, and lack of real-time seat tracking.

**FestConnect** is a cross-platform Flutter application tailored for students and event coordinators:
* **Students** can browse upcoming fest events, filter by categories, inspect event rules/schedules, view **live remaining seats**, and register via a strictly validated multi-field form.
* **Organizers** get centralized participation tracking where all registrations and remaining seats are updated reactively in real time.

---

## 2. Technical Justification
As mandated by the case study (*"With Proper Justification"*):

1. **Why Cross-Platform (Flutter & Dart)?**
   * Single unified codebase deployed across **Web (Chrome)**, **macOS**, **Android**, and **iOS**.
   * Native graphics rendering via Flutter’s Impeller/Skia engine ensures smooth 60fps scrolling and card transitions.
   * Faster development and zero divergence between platforms.

2. **Why a Reactive Stream Repository Architecture?**
   * Built using Dart's broadcast `StreamController` to replicate Cloud Firestore snapshot behavior with zero external cloud billing or authentication dependencies.
   * Ensures instant, offline-capable, and 100% reliable seat decrementing during live evaluations and demos.
   * Decoupled architecture allows plug-and-play binding with Cloud Firestore if credentials are provided in production.

3. **Why Minimal Black & White Material 3 Styling?**
   * Clean, distraction-free monochrome aesthetic with high-contrast typography and subtle borders (`#E4E4E7`).
   * Color is used **sparsely and intentionally**:
     * Green badge (`#15803D`) for available seats.
     * Red badge (`#B91C1C`) for full / sold-out events.
     * Minimal black pills for active category chips.

---

## 3. Project Architecture & Screen Flow

```
lib/
├── main.dart                          # App entry point, Material 3 theming & named routes
├── models/
│   ├── event_model.dart               # Event data entity
│   └── registration_model.dart        # Student registration record entity
├── services/
│   └── event_service.dart             # Central reactive repository with live streams
├── screens/
│   ├── event_list_screen.dart         # ListView, Cards, ChoiceChips, dynamic filter
│   ├── event_detail_screen.dart       # Expanded details, live seat count stream
│   ├── registration_screen.dart       # Form with Name, Roll No, Email validation
│   ├── confirmation_screen.dart       # Ticket pass receipt with generated Pass ID
│   └── registrations_list_screen.dart # Organizer participation tracker
└── theme/
    └── app_theme.dart                 # Minimalist B&W Material 3 theme configuration
```

### Screen Flow:
1. **Event List (`/`)**: Displays all fest events in modern cards with dynamic category filtering chips (`All`, `Technical`, `Cultural`, `Gaming`, `Creative`). Shows date, venue, category, and live seat count.
2. **Event Details (`/detail`)**: Reached via named routes. Highlights live real-time remaining seats, event overview, venue, and rules.
3. **Registration Form (`/register`)**: Receives the selected event via `ModalRoute.of(context)!.settings.arguments`. Validates input before submission.
4. **Confirmation Screen (`/confirmation`)**: Generates a ticket pass with unique Pass ID, attendee credentials, and registration timestamp.
5. **Organizer Tracker (`/registrations`)**: Accessible via the top-right ticket icon in the app bar; displays all centrally logged registrations.

---

## 4. Dart Logic & Form Validation Rules

### A. Named Routes with Arguments
Navigation is fully decoupled from widget trees:
```dart
// Navigating to Registration with selected Event argument
Navigator.pushNamed(context, '/register', arguments: event);

// Extracting inside RegistrationScreen
final event = ModalRoute.of(context)?.settings.arguments as Event?;
```

### B. Mandatory Field Validations
Implemented using Flutter's `Form` and `GlobalKey<FormState>`:
* **Student Name**: Non-empty, minimum 2 characters, strictly alphabetic (`^[a-zA-Z\s\.\']+$`).
* **Roll Number**: Exactly 12 digits, strictly enforcing the institutional prefix `150096724` followed by 3 student-specific digits (`^150096724\d{3}$`), e.g., `150096724125`.
* **College Email**: Institutional email format strictly enforcing domain `@isu.ac.in` and pattern `YYYY.name@isu.ac.in` (`^\d{4}\.[a-zA-Z0-9._]+@isu\.ac\.in$`), e.g., `2024.manthanb@isu.ac.in`.

---

## 5. How to Run the Project

### Prerequisites
* Flutter SDK (3.x or higher)
* Dart SDK (3.x or higher)
* Google Chrome (recommended for evaluation)

### Running on Chrome (Web)
```bash
# Get dependencies
flutter pub get

# Run in Chrome
flutter run -d chrome
```

### Running on macOS (Desktop)
```bash
flutter run -d macos
```

### Running Tests & Static Analysis
```bash
# Run code analysis
flutter analyze

# Run unit & widget smoke tests
flutter test
```

---

## 6. Submission Deliverables Checklist
* [x] **Fully Tested Flutter Application** (0 errors, 0 warnings on `flutter analyze`, passes `flutter test`)
* [x] **Clean, Minimal Black & White UI** with sparse functional color
* [x] **Named Routes with Arguments**
* [x] **Form Validations for Name, Roll No, and Email**
* [x] **Live Reactive Seat Decrement Counter**
* [x] **Centralized Organizer Participation Log**
* [x] **Project Report (`FestConnect_Project_Report.docx`) included**
* [x] **README.md Documentation**
