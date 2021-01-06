
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:doggo_frontend/Calendar/edit_event_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Find by Type', () {
    testWidgets('Test to see if elements render properly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: EditEventPage(),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsNWidgets(3));
      expect(find.byType(DateTimeField), findsNWidgets(2));
      expect(find.text('Edit Event In Your Calendar'), findsOneWidget);
      expect(find.byType(MaterialButton), findsOneWidget);
      expect(find.byType(DropdownButtonHideUnderline), findsOneWidget);
    });
  });
}