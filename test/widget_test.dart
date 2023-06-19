import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/updateCurse.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/screens/settingsScreen.dart';


void main() {
  testWidgets('Settings screen', (WidgetTester tester) async {
    // Создаем экземпляр виджета SettingsScreen
    await tester.pumpWidget(
      MaterialApp(
        home: SettingsPage1(),
      ),
    );

    // Проверяем наличие AppBar с определенным заголовком
    expect(find.text('Настройки'), findsOneWidget);

    // Проверяем наличие списка элементов
    expect(find.byType(ListView), findsOneWidget);

    // Проверяем наличие элементов списка
    expect(find.text('О приложении'), findsOneWidget);
    expect(find.text('Темная тема'), findsOneWidget);
    expect(find.text('Поддержка'), findsOneWidget);

    // Нажимаем на элемент списка "О приложении"
    await tester.tap(find.text('О приложении'));
    await tester.pumpAndSettle();

    // Нажимаем на элемент списка "Темная тема"
    await tester.tap(find.text('Темная тема'));
    await tester.pumpAndSettle();

    // Проверяем, что состояние isTheme изменилось
    // Здесь требуется доступ к переменной isTheme (либо сделать ее публичной, либо использовать GlobalKey)
    // expect(isTheme, isTrue);
  });
  testWidgets('CourseEditScreen test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Curse_Update(
          idCurs1: '',
        ),
      ),
    );

    expect(find.text('Schooldis'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Добавление курса'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  
}
