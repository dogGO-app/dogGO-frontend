import 'package:doggo_frontend/Location/people_in_location_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Find by Type', () {
    testWidgets('Test to see if elements render properly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: PeopleAndDogsInLocationPage(),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('People In Current Location'), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
    });
  });
}