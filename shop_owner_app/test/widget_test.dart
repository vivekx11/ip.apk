import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shop_owner_app/main.dart';
import 'package:shop_owner_app/services/network_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Create a mock network service
    final networkService = NetworkService();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(networkService: networkService));

    // Verify that the app starts
    expect(find.byType(MyApp), findsOneWidget);
  });
}
