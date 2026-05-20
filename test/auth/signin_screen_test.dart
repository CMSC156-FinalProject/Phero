import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:phero_app/auth/signin_screen.dart';
import 'package:phero_app/auth/login_screen.dart';
import 'package:phero_app/core/theme/theme_notifier.dart';
import 'package:phero_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:phero_app/domain/models/app_user.dart';

/// A fake AuthViewModel to test the SignInScreen without real backend dependencies
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

  bool signUpWasCalled = false;
  String? capturedEmail;
  String? capturedPassword;

  @override
  Future<bool> signUp(String email, String password, String displayName) async {
    signUpWasCalled = true;
    capturedEmail = email;
    capturedPassword = password;
    
    // return false so the Navigator doesn't try to load the MapFeedScreen
    return false; 
  }

  // dummy implementations to satisfy the compiler
  @override Future<bool> signIn(String email, String password) async => true;
  @override Future<void> checkAuthStatus() async {}
  @override Future<void> signOut() async {}
}

void main() {
  late FakeAuthViewModel fakeAuthViewModel;
  late ThemeNotifier themeNotifier;

  setUp(() {
    fakeAuthViewModel = FakeAuthViewModel();
    themeNotifier = ThemeNotifier();
  });

  // this is to isolate the SignInScreen with fake ViewModel and ThemeNotifier,
  // so we can test only the UI logic without any real backend or theme dependencies
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
        home: SignInScreen(),
      ),
    );
  }

  // ====== SIGN IN VALIDATION TESTS ======
  group('Sign In Validation Tests', () {
    testWidgets('Submitting empty fields show validation errors', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());
      
      final signInBtn = find.byType(ElevatedButton);
      await tester.tap(signInBtn);
      await tester.pump(); // so that the setState validation errors can show up

      expect(find.text('Email is required', skipOffstage: false), findsOneWidget);
      expect(find.text('Password is required', skipOffstage: false), findsOneWidget);
    });

    testWidgets('Unmatching Password and Confirm Password show error', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());
      
      final emailField = find.byType(TextField).at(0);
      final passwordField = find.byType(TextField).at(1);
      final confirmPasswordField = find.byType(TextField).at(2);
      final signInBtn = find.byType(ElevatedButton);

      await tester.enterText(emailField, 'isko@up.edu.ph');
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmPasswordField, 'differentpassword');

      await tester.tap(signInBtn);
      await tester.pump();

      expect(find.text('Passwords do not match. Please try again.'), findsOneWidget);
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
      
      // Password and Confirm Password fields both use Icons.visibility_off_outlined
      expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(2));

      await tester.tap(find.byIcon(Icons.visibility_off_outlined).first);
      await tester.tap(find.byIcon(Icons.visibility_off_outlined).last);
      
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(2));
    });
  });

  // ====== SIGN IN NAVIGATION TESTS ======
  group('Sign in Navigation Tests', () {
    testWidgets('Elevated "Sign In" button triggers signUp behavior without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());

      final signInBtn = find.byType(ElevatedButton);
      expect(signInBtn, findsOneWidget);

      await tester.enterText(find.byType(TextField).at(0), 'isko@up.edu.ph');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.enterText(find.byType(TextField).at(2), 'password123');

      await tester.tap(signInBtn);
      await tester.pump();

      // the UI should call the signUp method in the ViewModel with correct params
      expect(fakeAuthViewModel.signUpWasCalled, isTrue);
      expect(fakeAuthViewModel.capturedEmail, 'isko@up.edu.ph');
    });

    testWidgets('TextButton "Already have an account? Log in" navigates to Login Page', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting());

      final loginLink = find.descendant(
        of: find.byType(GestureDetector),
        matching: find.text('LOG IN'),
      );
      expect(loginLink, findsOneWidget);
  
      await tester.tap(loginLink);
      await tester.pumpAndSettle();
  
      expect(find.byType(LoginScreen), findsOneWidget); 
      expect(find.text('Confirm Password'), findsNothing);
    });
  });
}