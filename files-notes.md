# Phero – File Notes (lib only)

---

### `lib/` (root)
**`main.dart`** — App entry point. Initializes Firebase and sets up all providers, then launches the splash screen.
**`firebase_options.dart`** — Auto-generated Firebase config with API keys per platform. Never edit manually.

---

### `lib/auth/`
**`login_screen.dart`** — Email/password login form with inline validation and show/hide password toggle.
**`signin_screen.dart`** — Registration form with email, password, and confirm password fields. Auto-generates a display name from the email prefix.

---

### `lib/core/di/`
**`injection.dart`** — Wires all services, repositories, use cases, and view models together in dependency order. The only file you change to swap out a backend.

### `lib/core/theme/`
**`theme_notifier.dart`** — Holds a dark/light mode boolean. Calling `toggle()` switches the whole app theme instantly.

---

### `lib/data/repositories/`
**`auth_repository_impl.dart`** — Real Firebase Auth + Firestore implementation. Fetches the user's `role` from Firestore on login so admin access reflects in real time.
**`report_repository_impl.dart`** — Saves and fetches reports from Firestore. Uses `GeoFlutterFirePlus` for nearby/radius queries.

### `lib/data/services/`
**`camera_service_impl.dart`** — Opens the native camera via `ImagePicker`. Returns null silently if the user cancels.
**`location_service_impl.dart`** — Gets GPS coordinates with a smart fallback chain: high accuracy → cached position → low accuracy → null.
**`storage_service_impl.dart`** — Uploads a report photo to Firebase Storage and returns the download URL, or null on failure.

---

### `lib/domain/models/`
**`app_user.dart`** — Represents a logged-in user with `id`, `email`, `displayName`, and `role`. Has an `isAdmin` getter.
**`report.dart`** — The main data model: title, description, GPS location, photo URL, status, and an auto-computed geohash for map queries.
**`captured_media.dart`** — Simple wrapper around a local file path from the camera. Keeps camera plugin types out of business logic.
**`location_data.dart`** — Simple wrapper around latitude, longitude, and accuracy. Keeps GPS plugin types out of business logic.

### `lib/domain/repositories/`
Abstract interfaces only — no logic. These define the contracts that the `data/` layer implements.

**`auth_repository.dart`** — Contract for sign in, sign up, sign out, get current user, and auth change stream.
**`report_repository.dart`** — Contract for create, fetch, update, delete, and geo-query reports.
**`camera_service.dart`** — Contract for taking a picture.
**`location_service.dart`** — Contract for requesting permission and getting current coordinates.
**`storage_service.dart`** — Contract for uploading a report image to cloud storage.

### `lib/domain/usecases/`
**`submit_new_report_usecase.dart`** — Orchestrates the full report flow: verify login → get GPS → optionally capture/upload photo → save report. The most complex file in the app.
**`fetch_reports_usecase.dart`** — Fetches all reports, or just a specific user's reports.
**`fetch_nearby_reports_usecase.dart`** — Fetches reports within a given km radius from a coordinate.
**`update_report_status_usecase.dart`** — Updates a report's status (e.g. Pending → In Progress).
**`delete_report_usecase.dart`** — Deletes a report by ID.

---

### `lib/emergency/`
**`emergency_screen.dart`** — Static screen listing 5 emergency hotlines (911, 311, Poison Control, etc.). Tapping any card dials the number directly.

---

### `lib/features/admin/`
**`admin_dashboard_screen.dart`** — Admin-only screen with three tabs: Pending, In Progress, Resolved. Shows "Access Denied" to non-admins.

### `lib/features/admin/widgets/`
**`admin_report_list.dart`** — Reusable report card list filtered by status. Used by each tab in the admin dashboard.
**`admin_status_modal.dart`** — Bottom sheet that lets an admin change a report's status, with the current status pre-selected.

### `lib/features/splash/`
**`splash_screen.dart`** — Tap-to-start animated splash screen. Plays a logo zoom + green flood-fill animation, then routes to the map or login depending on auth state.

---

### `lib/presentation/viewmodels/`
**`auth_viewmodel.dart`** — Manages login state for the whole app. Reacts to auth changes automatically via a stream and exposes sign in/up/out with loading and error states.
**`report_viewmodel.dart`** — Manages the three report lists (all, user's, nearby). On status update, patches the local list directly to avoid a full refetch.

---

### `lib/reports/`
**`map_feed_screen.dart`** — Main home screen. Shows reports on an interactive map or list. The list syncs with the visible map viewport as the user pans.
**`report_screen.dart`** — Report submission form. User picks a category, writes a description, optionally attaches a photo, and submits with auto-fetched GPS.
**`my_reports_screen.dart`** — Shows only the current user's reports with filter chips for All, Submitted, In Progress, and Resolved.
**`report_details_screen.dart`** — Full detail view of a report. Owners and admins can update its status from here.

### `lib/reports/widgets/`
**`custom_bottom_navbar.dart`** — Shared 5-tab bottom nav bar (Map, Report, My Reports, Emergency, Admin). Uses instant zero-duration transitions between screens.

---

### `lib/settings/`
**`account_settings_screen.dart`** — Lets the user update their display name, change their password (requires re-auth), or sign out.

### `lib/settings/widgets/`
**`theme_toggle.dart`** — Reusable sun/moon icon button that toggles dark/light mode.
