import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:support_ticket_inbox/data/ticket_repository.dart';
import 'package:support_ticket_inbox/models/ticket.dart';
import 'package:support_ticket_inbox/models/ticket_filter.dart';
import 'package:support_ticket_inbox/providers/ticket_filter_provider.dart';
import 'package:support_ticket_inbox/providers/ticket_repository_provider.dart';

class TicketList extends AsyncNotifier<List<Ticket>> {
  int _page = 1;
  bool _isLoadingMore = false;
  bool _hasMore = false;
  int _loadedFromRepo = 0;
  int _totalFiltered = 0;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<List<Ticket>> build() async {
    _page = 1;
    _isLoadingMore = false;
    final filter = ref.watch(ticketFilterProvider);
    final TicketRepository repo = ref.watch(ticketRepositoryProvider);
    final tickets = await repo.fetchTickets(
      filter: filter,
      page: 1,
      pageSize: 5,
    );
    _totalFiltered = repo.filteredCount(filter);
    _loadedFromRepo = tickets.length;
    _hasMore = _loadedFromRepo < _totalFiltered;
    return tickets;
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) {
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
      final nextPage = _page + 1;
      final more = await repo.fetchTickets(
        filter: filter,
        page: nextPage,
        pageSize: 5,
      );
      if (more.isEmpty) {
        _hasMore = false;
        return;
      }
      _page = nextPage;
      _loadedFromRepo += more.length;
      _hasMore = _loadedFromRepo < _totalFiltered;
      state = AsyncData([...list, ...more]);
    } finally {
      _isLoadingMore = false;
    }
  }

  void applyFilter(TicketFilter filter) {
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
