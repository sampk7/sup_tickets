import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:support_ticket_inbox/models/ticket_filter.dart';

final ticketFilterProvider =
    StateProvider<TicketFilter>((ref) => const TicketFilter());
