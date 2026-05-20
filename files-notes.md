# Phero – File Notes

## App Entry & Core

**`main.dart`** — Starts the app, initializes Firebase, and sets up all providers. Launches the splash screen first.

**`firebase_options.dart`** — Auto-generated Firebase config file with API keys for each platform (Android, iOS, Web, etc.). Don't edit manually.

**`core/di/injection.dart`** — Wires everything together: services → repositories → use cases → view models, in order. The only place you change if you swap out a backend.

**`core/theme/theme_notifier.dart`** — Holds a single dark/light mode boolean. Calling `toggle()` switches the whole app theme instantly.

---

## Domain – Models

**`domain/models/app_user.dart`** — Represents a logged-in user with `id`, `email`, `displayName`, and `role`. The `isAdmin` getter checks if `role == 'admin'`.

**`domain/models/report.dart`** — The main data model for a community report: title, description, location, photo URL, status, and a geohash (auto-computed) for map queries.

**`domain/models/captured_media.dart`** — Just wraps a local file path from the camera. Keeps camera-specific types out of the business logic.

**`domain/models/location_data.dart`** — Wraps latitude, longitude, and accuracy. Keeps GPS plugin types out of the business logic.

---

## Domain – Interfaces (abstract contracts, no logic)

**`domain/repositories/auth_repository.dart`** — Defines what auth must do: sign in, sign up, sign out, get current user, and stream auth changes.

**`domain/repositories/report_repository.dart`** — Defines what report storage must do: create, fetch, update status, delete, and geo-query nearby reports.

**`domain/repositories/camera_service.dart`** — One method: take a picture, return the file path or null.

**`domain/repositories/location_service.dart`** — Two methods: request location permission, and get current coordinates.

**`domain/repositories/storage_service.dart`** — One method: upload a report image to cloud storage, return the download URL.

---

## Domain – Use Cases (business logic)

**`domain/usecases/submit_new_report_usecase.dart`** — Handles the full report submission: checks login → gets GPS → optionally takes/uploads a photo → saves the report. The most complex use case in the app.

**`domain/usecases/fetch_reports_usecase.dart`** — Fetches all reports, or just one user's reports.

**`domain/usecases/fetch_nearby_reports_usecase.dart`** — Fetches reports within a given radius (in km) from a location.

**`domain/usecases/update_report_status_usecase.dart`** — Updates a report's status (e.g. Pending → In Progress).

**`domain/usecases/delete_report_usecase.dart`** — Deletes a report by ID.

---

## Data – Implementations (real Firebase logic)

**`data/repositories/auth_repository_impl.dart`** — Implements auth using Firebase Auth + Firestore. Fetches the user's `role` from Firestore on login so role changes reflect in real time without logging out.

**`data/repositories/report_repository_impl.dart`** — Saves and fetches reports from Firestore. Uses `GeoFlutterFirePlus` for the nearby/radius queries.

**`data/services/camera_service_impl.dart`** — Opens the native camera via `ImagePicker` at 80% quality. Returns null silently if the user cancels.

**`data/services/location_service_impl.dart`** — Gets GPS coordinates using `geolocator`. Has a smart fallback: tries high accuracy first, then cached position, then low accuracy — returns null only if all three fail.

**`data/services/storage_service_impl.dart`** — Uploads a report photo to Firebase Storage at `reports/{userId}/{reportId}.jpg` and returns the download URL. Returns null silently on failure.

---

## Presentation – ViewModels

**`presentation/viewmodels/auth_viewmodel.dart`** — Manages login state for the whole app. Automatically updates when auth changes (stream-based), and exposes `signIn`, `signUp`, `signOut` with loading/error states.

**`presentation/viewmodels/report_viewmodel.dart`** — Manages all report lists (all reports, user's reports, nearby reports). When a status is updated, it patches the local list directly so the UI doesn't need to refetch everything.

---

## Screens & UI

**`features/splash/splash_screen.dart`** — Animated splash screen. Tap to trigger a logo zoom + green flood-fill animation, then routes to the map (if logged in) or login screen.

**`auth/login_screen.dart`** — Email/password login form with inline validation and a show/hide password toggle. Navigates to the map on success.

**`auth/signin_screen.dart`** — Registration form with email, password, and confirm password fields. Auto-derives a display name from the email prefix.

**`reports/map_feed_screen.dart`** — The main home screen. Shows all reports on an interactive map or as a scrollable list. The list automatically filters to only show reports visible in the current map viewport.

**`reports/report_screen.dart`** — The report submission form. User picks a category, writes a description, optionally attaches a photo, and submits. Auto-fetches GPS on load.

**`reports/my_reports_screen.dart`** — Shows only the current user's reports with filter chips for status (All, Submitted, In Progress, Resolved).

**`reports/report_details_screen.dart`** — Full detail view of a single report: photo, description, location, timestamp, and status. Owners and admins can update the status here.

**`reports/widgets/custom_bottom_navbar.dart`** — The shared bottom nav bar (5 tabs: Map, Report, My Reports, Emergency, Admin). Navigates between screens using instant (zero-duration) transitions.

**`features/admin/admin_dashboard_screen.dart`** — Admin-only screen with three tabs: Pending, In Progress, Resolved. Shows an "Access Denied" message to non-admins.

**`features/admin/widgets/admin_report_list.dart`** — Reusable list of report cards filtered by status. Used by each tab in the admin dashboard. Tapping a card opens the status modal.

**`features/admin/widgets/admin_status_modal.dart`** — Bottom sheet that lets an admin change a report's status. Shows the current status pre-selected with a loading state during the update.

**`emergency/emergency_screen.dart`** — Static screen listing 5 emergency hotlines (911, 311, Poison Control, etc.). Tapping any card dials the number directly.

**`settings/account_settings_screen.dart`** — Lets the user update their display name, change their password (requires re-authentication), or sign out with a confirmation dialog.

**`settings/widgets/theme_toggle.dart`** — A reusable icon button (sun/moon) that toggles dark/light mode. Used wherever a standalone toggle is needed.

---

## Tests

**`test/auth/login_screen_test.dart`** — Widget tests for the login screen: validation errors, successful login navigation, failed login snackbar, loading state.

**`test/auth/signin_screen_test.dart`** — Widget tests for the registration screen: validation, password mismatch, success/failure flows.

**`test/domain/models/app_user_test.dart`** — Unit tests for `AppUser` JSON serialization and the `isAdmin` getter.

**`test/domain/usecases/fetch_reports_usecase_test.dart`** — Tests that `FetchReportsUseCase` correctly delegates to the repository for all reports and user-specific reports.

**`test/domain/usecases/submit_new_report_usecase_test.dart`** — Tests the full report submission flow: missing user throws, missing location throws, photo upload path, no-photo path.

**`test/domain/usecases/submit_new_report_usecase_test.mocks.dart`** — Auto-generated mock classes for the 5 dependencies of `SubmitNewReportUseCase`. Don't edit manually.

**`test/domain/usecases/update_report_status_usecase_test.dart`** — Tests that `UpdateReportStatusUseCase` calls the repository with the right arguments and propagates errors.

**`test/domain/usecases/update_report_status_usecase_test.mocks.dart`** — Auto-generated mock for `ReportRepository`. Don't edit manually.

**`test/features/admin/admin_dashboard_screen_test.dart`** — Widget tests for the admin dashboard: access denied for non-admins, correct tabs shown for admins.

**`test/features/admin/widgets/admin_report_list_test.dart`** — Tests that `AdminReportList` shows an empty state, renders report cards, and filters by status correctly.

**`test/features/admin/widgets/admin_status_modal_test.dart`** — Tests that the status modal pre-selects the current status and calls the update callback when a new one is tapped.

**`test/presentation/viewmodels/auth_viewmodel_test.dart`** — Unit tests for `AuthViewModel`: initial state, sign-in success/failure, sign-out behavior.

**`test/test_utils.dart`** — Shared helper that wraps widgets in the required `MultiProvider` + `MaterialApp` for widget tests. Prevents boilerplate duplication across test files.
