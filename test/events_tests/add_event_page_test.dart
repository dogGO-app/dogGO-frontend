import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:doggo_frontend/Calendar/add_event_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Find by Type', () {
    testWidgets('Test to see if elements render properly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AddEventPage(),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.text('Add Event To Your Calendar'), findsOneWidget);
      expect(find.byType(Column), findsNWidgets(3));
      expect(find.byType(DateTimeField), findsNWidgets(2));
      expect(find.byType(DropdownButtonHideUnderline), findsOneWidget);
      expect(find.byType(MaterialButton), findsOneWidget);
    });
  });
}