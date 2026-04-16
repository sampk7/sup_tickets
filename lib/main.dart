import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:support_ticket_inbox/app.dart';
import 'package:support_ticket_inbox/data/mock_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MockData.init();
  runApp(
    const ProviderScope(
      child: SupportTicketApp(),
    ),
  );
}
