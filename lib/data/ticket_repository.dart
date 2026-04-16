import 'dart:math';

import 'package:support_ticket_inbox/models/ticket.dart';
import 'package:support_ticket_inbox/models/ticket_filter.dart';

import 'mock_data.dart';

class TicketRepository {
  TicketRepository() : _allTickets = List<Ticket>.unmodifiable(MockData.tickets);

  final List<Ticket> _allTickets;
  bool _firstFetchPending = true;

  int filteredCount(TicketFilter filter) {
    return _applyFilter(filter).length;
  }

  Future<List<Ticket>> fetchTickets({
    required TicketFilter filter,
    required int page,
    int pageSize = 5,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (_firstFetchPending) {
      _firstFetchPending = false;
      if (Random().nextDouble() < 0.3) {
        throw Exception('Failed to load tickets');
      }
    }
    final filtered = _applyFilter(filter);
    final start = (page - 1) * pageSize;
    if (start >= filtered.length) {
      return <Ticket>[];
    }
    final end = start + pageSize;
    return filtered.sublist(start, end > filtered.length ? filtered.length : end);
  }

  List<Ticket> _applyFilter(TicketFilter filter) {
    return _allTickets.where((t) {
      if (filter.status != null && t.status != filter.status) {
        return false;
      }
      if (filter.priority != null && t.priority != filter.priority) {
        return false;
      }
      if (filter.projectId != null && t.project.id != filter.projectId) {
        return false;
      }
      if (filter.assigneeId != null && t.assignee.id != filter.assigneeId) {
        return false;
      }
      return true;
    }).toList();
  }
}
