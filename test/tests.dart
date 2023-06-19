import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/dateUser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/auth.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('Autorization Widget', () {
    // Create a MockFirebaseAuth instance for testing
    final mockFirebaseAuth = MockFirebaseAuth();

    testWidgets('Widget has a logo', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Autorization(),
        ),
      );

      // Verify that the widget has a logo
      expect(find.text('SchoolDis'), findsOneWidget);
    });

    testWidgets('Sign in with valid credentials', (WidgetTester tester) async {
      // Set up the mock FirebaseAuth instance
      when(mockFirebaseAuth.signInWithEmailAndPassword(email: 'test@example.com', password: 'password'))
          .thenAnswer((_) => Future.value(UserCredentialMock()));

      await tester.pumpWidget(
        MaterialApp(
          home: Autorization(),
        ),
      );

      // Enter valid email and password
      await tester.enterText(
          find.byKey(ValueKey('email_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(ValueKey('password_field')), 'password');

      // Tap the sign in button
      await tester.tap(find.text('Вход'));
      await tester.pumpAndSettle();

      // Verify that the user is navigated to the home page
      expect(find.byType(MyPage), findsOneWidget);
    });
  });
}

// Mock FirebaseAuth class for testing
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Mock UserCredential class for testing
class UserCredentialMock extends Mock implements UserCredential {}
