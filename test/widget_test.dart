// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase/supabase.dart';
import 'package:mockito/mockito.dart';

import 'package:todo_supabase/main.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {
  MockSupabaseClient(String url, String key);
}

void main() {
  testWidgets('Home', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle(const Duration(seconds: 30));
    expect(find.text('SupaBase Demo Home Page'), findsOneWidget);
  });
}
