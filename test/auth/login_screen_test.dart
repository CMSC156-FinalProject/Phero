import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:phero_app/auth/login_screen.dart';
import 'package:phero_app/auth/signin_screen.dart';
import 'package:phero_app/core/theme/theme_notifier.dart';
import 'package:phero_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:phero_app/domain/models/app_user.dart';

/// A fake AuthViewModel to test the LoginScreen without real backend dependencies
class FakeAuthViewModel extends ChangeNotifier implements AuthViewModel {
  @override
  bool isLoading = false;

  @override
  String? errorMessage;

  @override
  AppUser? currentUser;

  @override
  bool get isAdmin => false;

  @override
  bool get isAuthenticated => currentUser != null;

  bool signInWasCalled = false;
  String? capturedEmail;
  String? capturedPassword;

  @override
  Future<bool> signIn(String email, String password) async {
    signInWasCalled = true;
    capturedEmail = email;
    capturedPassword = password;
    
    // return false so the Navigator doesn't try to load the MapFeedScreen
    return false; 
  }

  // dummy implementations to satisfy the compiler
  @override Future<void> checkAuthStatus() async {}
  @override Future<void> signOut() async {}
  @override Future<bool> signUp(String email, String password, String name) async => true;
}

void main() {
  late FakeAuthViewModel fakeAuthViewModel;
  late ThemeNotifier themeNotifier;

  setUp(() {
    fakeAuthViewModel = FakeAuthViewModel();
    themeNotifier = ThemeNotifier();
  });

  // this isolates the LoginScreen to test only the UI logic without any real backend or theme dependencies
  Widget createWidgetForTesting({bool isDark = false}) {
    if (isDark) {
      themeNotifier.toggle();
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>.value(value: fakeAuthViewModel),
        ChangeNotifierProvider<ThemeNotifier>.value(value: themeNotifier),
      ],
      child: const MaterialApp(
        home: LoginScreen(),
      ),
    );
  }

  // ====== LOGIN VALIDATION TESTS ======
  group('Login Validation Tests', () {
    testWidgets('Submitting empty fields show validation errors', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());

      final loginBtn = find.byType(ElevatedButton);
      await tester.tap(loginBtn);
      await tester.pump(); // so that the setState validation errors can show up

      expect(find.text('Email is required', skipOffstage: false), findsOneWidget);
      expect(find.text('Password is required', skipOffstage: false), findsOneWidget);
    });

    testWidgets('Submitting email without password shows only password errors', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());

      final emailField = find.byType(TextField).first;
      final loginBtn = find.byType(ElevatedButton);

      await tester.enterText(emailField, 'isko@up.edu.ph');

      await tester.tap(loginBtn);
      await tester.pump();

      expect(find.text('Password is required', skipOffstage: false), findsOneWidget);
      expect(find.text('Email is required', skipOffstage: false), findsNothing);
    });
  });

  // ====== THEME TOGGLE TESTS ======
  group('Theme Toggle Tests', () {
      testWidgets('Show moon icon in light mode', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetForTesting(isDark: false));

        expect(find.byIcon(Icons.nightlight_round), findsOneWidget);
      });

      testWidgets('Show sun icon in dark mode', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetForTesting(isDark: true));

        expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
      });

      testWidgets('Toggle theme button is triggered', (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetForTesting());

        final themeToggleBtn = find.byType(IconButton).first;
        expect(find.byIcon(Icons.nightlight_round), findsOneWidget);

        await tester.tap(themeToggleBtn);
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.nightlight_round), findsNothing);
        expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
      });
  });

  // ====== PASSWORD VISIBILITY TESTS ======
  group('Password Visibility Tests', () {
    testWidgets('Password Visibility Test', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });
  });

  // ====== LOGIN NAVIGATION TESTS ======
  group('Login Navigation Tests', () {
    testWidgets('Elevated "LOG IN" button triggers signIn behavior without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());

      final loginBtn = find.byType(ElevatedButton);
      expect(loginBtn, findsOneWidget);

      await tester.enterText(find.byType(TextField).at(0), 'isko@up.edu.ph');
      await tester.enterText(find.byType(TextField).at(1), 'password123');

      await tester.tap(loginBtn);
      await tester.pump();

      // the ui should call the signIn method in the ViewModel with correct params
      expect(fakeAuthViewModel.signInWasCalled, isTrue);
      expect(fakeAuthViewModel.capturedEmail, 'isko@up.edu.ph');
      expect(fakeAuthViewModel.capturedPassword, 'password123');
    });

    testWidgets('TextButton "Don\'t have an account? SIGN IN" navigates to Sign In Page', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());

      final signInLink = find.descendant(
        of: find.byType(GestureDetector),
        matching: find.text('SIGN IN'),
      );
      expect(signInLink, findsOneWidget);

      await tester.tap(signInLink);
      await tester.pumpAndSettle();

      expect(find.byType(SignInScreen), findsOneWidget); 

      expect(find.text('Confirm Password'), findsOneWidget);
    });
  });
}