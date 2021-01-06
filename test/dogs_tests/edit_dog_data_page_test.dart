import 'package:doggo_frontend/Dog/edit_dog_data_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Find by Type', () {
    testWidgets('Test to see if elements render properly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: EditDogDataPage(),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.text('Edit Dog\'s Details'), findsOneWidget);
      expect(find.byType(Column), findsNWidgets(3));
      expect(find.byType(TextField), findsNWidgets(5));
      expect(find.byType(MaterialButton), findsOneWidget);
    });
  });
}