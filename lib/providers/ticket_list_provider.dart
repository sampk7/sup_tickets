import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:support_ticket_inbox/data/ticket_repository.dart';
import 'package:support_ticket_inbox/models/ticket.dart';
import 'package:support_ticket_inbox/models/ticket_filter.dart';
import 'package:support_ticket_inbox/providers/ticket_filter_provider.dart';
import 'package:support_ticket_inbox/providers/ticket_repository_provider.dart';

class TicketList extends AsyncNotifier<List<Ticket>> {
  String? _nextCursor;
  bool _isLoadingMore = false;

  bool get hasMore => _nextCursor != null;
  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<List<Ticket>> build() async {
    _nextCursor = null;
    _isLoadingMore = false;
    final filter = ref.watch(ticketFilterProvider);
    final TicketRepository repo = ref.watch(ticketRepositoryProvider);
    final page = await repo.fetchTickets(
      filter: filter,
      cursor: null,
      pageSize: 5,
    );
    _nextCursor = page.meta.nextCursor;
    return page.tickets;
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || _nextCursor == null) {
      return;
    }
    final current = state;
    final list = current.valueOrNull;
    if (list == null) {
      return;
    }
    _isLoadingMore = true;
    try {
      final filter = ref.read(ticketFilterProvider);
      final repo = ref.read(ticketRepositoryProvider);
      final page = await repo.fetchTickets(
        filter: filter,
        cursor: _nextCursor,
        pageSize: 5,
      );
      _nextCursor = page.meta.nextCursor;
      if (page.tickets.isEmpty) {
        return;
      }
      state = AsyncData([...list, ...page.tickets]);
    } finally {
      _isLoadingMore = false;
    }
  }

  void applyFilter(TicketFilter filter) {
    _nextCursor = null;
    ref.read(ticketFilterProvider.notifier).state = filter;
  }

  void addTicket(Ticket ticket) {
    final list = state.valueOrNull;
    if (list == null) {
      return;
    }
    state = AsyncData([ticket, ...list]);
  }
}

final ticketListProvider =
    AsyncNotifierProvider<TicketList, List<Ticket>>(TicketList.new);
