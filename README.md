# Phero: Location-Based Community Reporting Tool

**Phero** is a mobile-first community reporting application designed to help citizens report local infrastructure issues such as potholes, broken streetlights, flooding, vandalism, and other public concerns. By integrating mobile device hardware with cloud-based services, the application enables users to capture photos, attach precise GPS coordinates, and submit reports to a centralized platform where issues can be monitored and tracked in real time.

## 📌 Overview

Phero aims to strengthen communication between communities and local authorities through an accessible and efficient reporting platform. The application focuses on location-aware reporting, real-time issue visibility, and streamlined report management to encourage faster responses to public concerns.

## 📂 Project Structure

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

## ✨ Key Features

### 📍 Location-Based Reporting

Users can create reports by capturing photos and automatically attaching geographic coordinates through the device's location services.

### 🗺️ Interactive Map Feed

The application provides a live map interface that displays nearby reported issues using map markers, allowing users to easily identify incidents within their area.

### 🔄 Report Status Tracking

Users can monitor the progress of submitted reports through a structured report lifecycle:

* Pending
* Under Review
* In Progress
* Resolved

### 📸 Hardware Integration

The system integrates directly with device hardware and services, including:

* Camera API
* GPS and Location Services
* Media Storage Access

### 🚨 Emergency Hotline Access

Provides quick access to emergency contact hotlines and local authorities for urgent incidents and public safety concerns.

### 🛡️ Admin Dashboard

A dedicated admin interface for managing and moderating submitted reports, updating report statuses, and overseeing emergency-related data across the platform.

### 🏗️ Feature-Based Architecture

The project follows a **feature-based MVC architecture**, organizing code by domain feature rather than by layer. Each feature encapsulates its own controller, repository, screens, and widgets, maintaining a clean separation between:

* User Interface Components
* Business Logic and Controllers
* Data Repositories and Services

## 🛠️ Technology Stack

* **Framework:** Flutter
* **Programming Language:** Dart
* **Database:** NoSQL Database (Firebase Firestore)
* **Maps Integration:** Google Maps API
* **Cloud Services:** Firebase / Cloud Storage
* **Authentication:** Firebase Authentication
* **State Management:** Flutter State Management

## 👥 Members and Designated Roles

**Angel May Janiola | Frontend & Geospatial Developer**

Responsible for developing the Flutter user interface and integrating geospatial functionalities such as Google Maps and live location visualization.

**Matthew Simpas | Backend & Data Architect**

Responsible for designing the NoSQL database structure, optimizing geospatial queries, and managing cloud-based media storage.

**Chakinzo Sombito | Hardware & State Lead**

Responsible for integrating device hardware APIs, managing camera and GPS services, handling permissions, and maintaining report submission state management.

**Sophe Mae Dela Cruz | Release & Version Control Manager**

Responsible for maintaining the Git workflow, coordinating testing across multiple devices, and ensuring stable version releases throughout the development lifecycle.

## 🎯 Project Goal

Phero aims to promote civic engagement by providing communities with an accessible platform for reporting, monitoring, and tracking public infrastructure concerns in an efficient and transparent manner.
