import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:support_ticket_inbox/data/ticket_repository.dart';

final ticketRepositoryProvider = Provider<TicketRepository>((ref) {
  return TicketRepository();
});
