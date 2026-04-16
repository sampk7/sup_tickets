import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:support_ticket_inbox/app.dart';
import 'package:support_ticket_inbox/data/mock_data.dart';

void main() {
  testWidgets('Inbox screen loads', (WidgetTester tester) async {
    await MockData.init();
    await tester.pumpWidget(
      const ProviderScope(
        child: SupportTicketApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1200));
    if (find.text('Retry').evaluate().isNotEmpty) {
      await tester.tap(find.text('Retry'));
      await tester.pump(const Duration(milliseconds: 1200));
    }
    expect(find.text('Inbox'), findsOneWidget);
  });
}
