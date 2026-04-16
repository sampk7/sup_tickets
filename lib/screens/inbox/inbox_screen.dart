import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:support_ticket_inbox/models/ticket.dart';
import 'package:support_ticket_inbox/providers/providers.dart';
import 'package:support_ticket_inbox/screens/inbox/widgets/empty_state.dart';
import 'package:support_ticket_inbox/screens/inbox/widgets/error_state.dart';
import 'package:support_ticket_inbox/screens/inbox/widgets/filter_bar.dart';
import 'package:support_ticket_inbox/screens/inbox/widgets/ticket_card.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    final max = position.maxScrollExtent;
    if (max <= 0) {
      return;
    }
    if (position.pixels / max > 0.8) {
      ref.read(ticketListProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ticketsAsync = ref.watch(ticketListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const FilterBar(),
          Expanded(
            child: ticketsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object error, StackTrace stack) => ErrorState(
                message: error.toString(),
                onRetry: () => ref.invalidate(ticketListProvider),
              ),
              data: (List<Ticket> tickets) {
                if (tickets.isEmpty) {
                  return const EmptyState();
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount: tickets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TicketCard(ticket: tickets[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/ticket/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
