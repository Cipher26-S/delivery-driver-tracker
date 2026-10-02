import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:delivery_driver_app/main.dart';

void main() {
  testWidgets("L'application démarre sur l'écran de connexion", (WidgetTester tester) async {
    await tester.pumpWidget(const DeliveryDriverApp());

    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });

  testWidgets('Un email invalide est refusé', (WidgetTester tester) async {
    await tester.pumpWidget(const DeliveryDriverApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'pas-un-email');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret123');
    await tester.tap(find.text('Se connecter'));
    await tester.pump();

    expect(find.text('Email invalide'), findsOneWidget);
  });

  testWidgets('Un email valide passe la validation', (WidgetTester tester) async {
    await tester.pumpWidget(const DeliveryDriverApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'chauffeur@exemple.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret123');
    await tester.tap(find.text('Se connecter'));
    await tester.pump();

    expect(find.text('Email invalide'), findsNothing);
  });
}
