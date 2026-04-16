import 'dart:math';

import 'package:support_ticket_inbox/models/pagination_meta.dart';
import 'package:support_ticket_inbox/models/ticket.dart';
import 'package:support_ticket_inbox/models/ticket_filter.dart';

import 'mock_data.dart';

class TicketPageResult {
  const TicketPageResult({
    required this.tickets,
    required this.meta,
  });

  final List<Ticket> tickets;
  final PaginationMeta meta;
}

class TicketRepository {
  TicketRepository() : _allTickets = List<Ticket>.unmodifiable(MockData.tickets);

  final List<Ticket> _allTickets;
  bool _firstFetchPending = true;

  int filteredCount(TicketFilter filter) {
    return _applyFilter(filter).length;
  }

  Future<TicketPageResult> fetchTickets({
    required TicketFilter filter,
    String? cursor,
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
    final start = cursor == null
        ? 0
        : (filtered.indexWhere((ticket) => ticket.id == cursor) + 1);
    if (start >= filtered.length) {
      return TicketPageResult(
        tickets: const <Ticket>[],
        meta: PaginationMeta(
          nextCursor: null,
          pageSize: pageSize,
          totalCount: filtered.length,
        ),
      );
    }
    final end = start + pageSize;
    final tickets =
        filtered.sublist(start, end > filtered.length ? filtered.length : end);
    final reachedEnd = start + tickets.length >= filtered.length;
    return TicketPageResult(
      tickets: tickets,
      meta: PaginationMeta(
        nextCursor: reachedEnd || tickets.isEmpty ? null : tickets.last.id,
        pageSize: pageSize,
        totalCount: filtered.length,
      ),
    );
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
