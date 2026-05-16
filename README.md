# Phero: Community Reporting Tool

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
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_textfield.dart
│       ├── custom_appbar.dart
│       ├── loading_indicator.dart
│       └── bottom_navbar.dart
│
├── features/
│   ├── splash/
│   ├── auth/
│   ├── dashboard/
│   ├── reports/
│   ├── emergency/
│   └── settings/
│
└── test/
```

---

## Key Features

```plaintext
Location-Based Reporting
- Submit reports with photos
- Automatic GPS location tagging
- Uses device location services
```

```plaintext
Interactive Map Feed
- Displays nearby reported issues
- Uses live map visualization
- Map markers for easier monitoring
```

```plaintext
Report Status Tracking
- Pending
- Under Review
- In Progress
- Resolved
```

```plaintext
Hardware Integration
- Camera Access
- GPS and Location Services
- Media Storage
```

```plaintext
Emergency Hotline Access
- Quick access to emergency contacts
- Supports urgent public safety concerns
```

```plaintext
Admin Dashboard
- Manage submitted reports
- Update report statuses
- Monitor emergency-related data
```

```plaintext
Feature-Based MVC Architecture

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
