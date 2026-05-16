# PHERO: Community Reporting Tool

Phero is a mobile-first community reporting application that helps citizens report local infrastructure issues such as potholes, broken streetlights, flooding, vandalism, and other public concerns. Users can capture photos, attach GPS coordinates, and submit reports through a centralized platform where issues can be tracked in real time.

---

## Overview

Phero aims to improve communication between communities and local authorities through a simple and accessible reporting system.

The application focuses on:

- Location-based reporting
- Real-time issue visibility
- Faster report management
- Community engagement

---

## Project Structure

```plaintext
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── theme.dart
│   ├── routes.dart
│   ├── constants.dart
│   ├── services.dart
│   ├── helpers.dart
│   │
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_textfield.dart
│       ├── custom_appbar.dart
│       ├── loading_indicator.dart
│       └── bottom_navbar.dart
│
├── features/
│
│   ├── splash/
│   │   └── splash_screen.dart
│   │
│   ├── auth/
│   │   ├── auth_controller.dart
│   │   ├── auth_repository.dart
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   ├── admin_login_screen.dart
│   │   │
│   │   └── widgets/
│   │       ├── auth_form.dart
│   │       └── auth_header.dart
│   │
│   ├── dashboard/
│   │   ├── home_screen.dart
│   │   ├── admin_dashboard_screen.dart
│   │   │
│   │   └── widgets/
│   │       ├── dashboard_card.dart
│   │       └── quick_action_button.dart
│   │
│   ├── reports/
│   │   ├── reports_controller.dart
│   │   ├── reports_repository.dart
│   │   ├── report_screen.dart
│   │   ├── my_reports_screen.dart
│   │   ├── map_feed_screen.dart
│   │   ├── manage_reports_screen.dart
│   │   ├── reports_dashboard_screen.dart
│   │   │
│   │   └── widgets/
│   │       ├── report_card.dart
│   │       ├── report_form.dart
│   │       ├── report_map.dart
│   │       └── status_badge.dart
│   │
│   ├── emergency/
│   │   ├── emergency_controller.dart
│   │   ├── emergency_screen.dart
│   │   ├── emergency_dashboard_screen.dart
│   │   │
│   │   └── widgets/
│   │       └── emergency_button.dart
│   │
│   └── settings/
│       ├── settings_screen.dart
│       │
│       └── widgets/
│           └── theme_toggle.dart
│
└── test/
```

---

## Key Features
**Location-Based Reporting**
```plaintext
- Submit reports with photos
- Automatic GPS location tagging
- Uses device location services
```

**Interactive Map Feed**
```plaintext
- Displays nearby reported issues
- Uses live map visualization
- Map markers for easier monitoring
```

**Report Status Tracking**
```plaintext
- Pending
- Under Review
- In Progress
- Resolved
```

**Hardware Integration**
```plaintext
- Camera Access
- GPS and Location Services
- Media Storage
```

**Emergency Hotline Access**
```plaintext
- Quick access to emergency contacts
- Supports urgent public safety concerns
```
**Admin Dashboard**
```plaintext
- Manage submitted reports
- Update report statuses
- Monitor emergency-related data
```
**Feature-Based MVC Architecture**
```plaintext
Each feature contains its own:
- Controllers
- Repositories
- Screens
- Widgets

Benefits:
- Better scalability
- Easier maintenance
- Cleaner code organization
```

---

## Technology Stack

```plaintext
Framework        : Flutter
Language         : Dart
Database         : Firebase Firestore
Maps Integration : Google Maps API
Cloud Services   : Firebase Cloud Storage
Authentication   : Firebase Authentication
State Management : Flutter State Management
```

---

## Team Members and Roles

```plaintext
Angel May Janiola
Frontend & Geospatial Developer

- Develops the Flutter UI
- Integrates Google Maps
- Handles live location visualization
```

```plaintext
Matthew Simpas
Backend & Data Architect

- Designs database structure
- Manages cloud storage
- Optimizes geospatial queries
```

```plaintext
Chakinzo Sombito
Hardware & State Lead

- Integrates camera and GPS services
- Handles device permissions
- Manages report submission state
```

```plaintext
Sophe Mae Dela Cruz
Release & Version Control Manager

- Maintains Git workflow
- Coordinates testing
- Ensures stable releases
```

---

## Project Goal

Phero aims to promote civic engagement by providing
communities with an accessible platform for reporting,
monitoring, and tracking public infrastructure concerns
efficiently and transparently.
