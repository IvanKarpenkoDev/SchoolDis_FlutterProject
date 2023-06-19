import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/curse_add.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Создаем заглушку (mock) для класса FirebaseAuth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class CurseAddWrapper extends StatefulWidget {
  @override
  _CurseAddWrapperState createState() => _CurseAddWrapperState();
}

class _CurseAddWrapperState extends State<CurseAddWrapper> {
  @override
  Widget build(BuildContext context) {
    return Curse_add();
  }
}

void main() {
  group('Curse_add widget test', () {
    late MockFirebaseAuth mockFirebaseAuth;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
    });

    testWidgets('Widget elements are displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CurseAddWrapper(),
        ),
      );

      expect(find.text('Schooldis'), findsOneWidget);
      expect(find.text('Добавление курса'), findsOneWidget);

      final nameTextField = find.byKey(ValueKey('NameField'));
      expect(nameTextField, findsOneWidget);

      final descriptionTextField = find.byKey(ValueKey('DescriptionField'));
      expect(descriptionTextField, findsOneWidget);

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Clicking "Добавить" button triggers course creation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CurseAddWrapper(),
        ),
      );

      final nameTextField = find.byKey(ValueKey('NameField'));
      final descriptionTextField = find.byKey(ValueKey('DescriptionField'));
      final addButton = find.byType(ElevatedButton);

      await tester.enterText(nameTextField, 'Course Name');
      await tester.enterText(descriptionTextField, 'Course Description');

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      verify(mockFirebaseAuth.currentUser?.uid);
      verify(FirebaseFirestore.instance.collection('Curss').add({
        "Description": 'Course Description',
        "Name": 'Course Name',
        "prepod": mockFirebaseAuth.currentUser?.uid,
        "image": anyNamed('image'),
        "students": null
      }));
    });
  });
}
