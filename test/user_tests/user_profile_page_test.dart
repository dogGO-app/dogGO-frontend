import 'package:doggo_frontend/User/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Find by Type', () {
    testWidgets('Test to see if elements render properly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: UserProfilePage(),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Your dogGO Profile'), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(MaterialButton), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });
  });
}