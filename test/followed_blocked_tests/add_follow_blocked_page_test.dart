import 'package:doggo_frontend/FollowedBlocked/add_followed_blocked_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Find by Type', () {
    testWidgets('Test to see if elements render properly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AddFollowedBlockedPage(),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Follow or Block'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(MaterialButton), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });
  });
}