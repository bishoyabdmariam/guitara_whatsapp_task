// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:guitara_whatsapp_task/main.dart';

void main() {
  testWidgets('WhatsApp app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WhatsAppApp());

    // Verify that the app starts with the home screen
    expect(find.text('WhatsApp'), findsOneWidget);
    expect(find.text('Chats'), findsOneWidget);
  });
}
