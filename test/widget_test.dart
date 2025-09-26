import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bogazici_barter/app.dart';

void main() {
  testWidgets('App renders root widget', (WidgetTester tester) async {
    await tester.pumpWidget(const BogaziciBarterApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
