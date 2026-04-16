import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:support_ticket_inbox/core/theme.dart';
import 'package:support_ticket_inbox/screens/create/create_ticket_screen.dart';
import 'package:support_ticket_inbox/screens/detail/ticket_detail_screen.dart';
import 'package:support_ticket_inbox/screens/inbox/inbox_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const InboxScreen(),
      routes: [
        GoRoute(
          path: 'ticket/create',
          builder: (BuildContext context, GoRouterState state) =>
              const CreateTicketScreen(),
        ),
        GoRoute(
          path: 'ticket/:id',
          builder: (BuildContext context, GoRouterState state) =>
              TicketDetailScreen(
            ticketId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
  ],
);

class SupportTicketApp extends StatelessWidget {
  const SupportTicketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: appTheme,
      routerConfig: router,
    );
  }
}
