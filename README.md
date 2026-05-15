# Phero: Location-Based Community Reporting Tool

**Phero** is a mobile-first community reporting application designed to help citizens report local infrastructure issues such as potholes, broken streetlights, flooding, vandalism, and other public concerns. Using mobile device hardware and cloud-based services, users can capture photos, automatically attach GPS coordinates, and submit reports to a centralized community feed where issues can be monitored and tracked in real time.

---

# Overview

Phero aims to improve communication between communities and local authorities by providing a simple and accessible reporting platform. The application focuses on location-aware reporting, real-time issue visibility, and efficient status tracking to encourage faster responses to community concerns.

---

# Key Features

## 📍 Location-Based Reporting

Users can create reports by taking photos and automatically attaching precise GPS coordinates using the device’s location services.

## 🗺️ Interactive Map Feed

A live map interface displays nearby reported issues through map markers, allowing users to easily view incidents within their area.

## 🔄 Report Status Tracking

Users can monitor the progress of their submitted reports through a complete CRUD lifecycle, including:

* Pending
* Under Review
* In Progress
* Resolved

## 📸 Hardware Integration

The application integrates directly with device hardware including:

* Camera API
* GPS / Location Services
* Media Storage Access

## 🚨 Emergency Hotline Access

Provides quick access to emergency contact hotlines and local authorities for urgent incidents.

## 🏗️ MVC-Based Architecture

The project follows the **Model-View-Controller (MVC)** architecture to maintain clean separation between:

* UI components
* Business logic
* Hardware and service integrations

---

# Technology Stack

* **Framework:** Flutter
* **Language:** Dart
* **Database:** NoSQL Database
* **Maps Integration:** Google Maps API
* **State Management:** Flutter State Management
* **Cloud Storage:** Firebase / Cloud Storage
* **Authentication:** Firebase Authentication

---

# Members and Designated Roles

### **Frontend & Geospatial Developer**

**Angel May Janiola**
Responsible for developing the Flutter user interface and integrating geospatial functionalities such as Google Maps and live location visualization.

### **Backend & Data Architect**

**Matthew Simpas**
Responsible for designing the NoSQL database structure, optimizing geospatial queries, and handling cloud-based media storage.

### **Hardware & State Lead**

**Chakinzo Sombito**
Responsible for integrating device hardware APIs including camera and GPS services, managing permissions, and handling report submission state management.

### **Release & Version Control Manager**

**Sophe Mae Dela Cruz**
Responsible for maintaining the Git workflow, coordinating testing across devices, and ensuring stable version releases throughout development.

---

# Project Structure

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

# Future Enhancements

* Push notifications for report updates
* AI-assisted issue categorization
* Offline report saving
* Community upvoting and verification system
* Analytics dashboard for local authorities
* Dark mode and accessibility improvements

---

# Goal of the Project

Phero aims to promote civic engagement by giving communities an accessible platform to report and monitor public infrastructure concerns efficiently and transparently.
