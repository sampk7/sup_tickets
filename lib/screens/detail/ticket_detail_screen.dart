import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:support_ticket_inbox/models/ticket.dart';
import 'package:support_ticket_inbox/providers/providers.dart';

String _formatCreated(DateTime createdAt) {
  return DateFormat('MMM d, y').format(createdAt.toLocal());
}

Color _priorityColor(String priority) {
  switch (priority) {
    case 'Critical':
      return Colors.red;
    case 'High':
      return Colors.orange;
    case 'Medium':
      return Colors.blue;
    case 'Low':
    default:
      return Colors.grey;
  }
}

Color _statusColor(String status) {
  switch (status) {
    case 'Open':
      return Colors.green;
    case 'In Progress':
      return Colors.amber;
    case 'Resolved':
      return Colors.teal;
    case 'Closed':
    default:
      return Colors.grey;
  }
}

class TicketDetailScreen extends ConsumerWidget {
  const TicketDetailScreen({super.key, required this.ticketId});

  final String ticketId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsAsync = ref.watch(ticketListProvider);

    return Scaffold(
      appBar: AppBar(),
      body: ticketsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stack) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Center(
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
        data: (List<Ticket> tickets) {
          Ticket? found;
          for (final Ticket t in tickets) {
            if (t.id == ticketId) {
              found = t;
              break;
            }
          }
          if (found == null) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Center(
                child: Text('Ticket not found'),
              ),
            );
          }
          return _TicketBody(ticket: found);
        },
      ),
    );
  }
}

class _TicketBody extends StatelessWidget {
  const _TicketBody({required this.ticket});

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            ticket.title,
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _Badge(label: ticket.priority, color: _priorityColor(ticket.priority)),
              const SizedBox(width: 8),
              _Badge(label: ticket.status, color: _statusColor(ticket.status)),
            ],
          ),
          const Divider(height: 32),
          Text('Description', style: textTheme.titleSmall),
          const SizedBox(height: 8),
          Text(ticket.description, style: textTheme.bodyLarge),
          const Divider(height: 32),
          Text('Project', style: textTheme.titleSmall),
          const SizedBox(height: 8),
          Text('${ticket.project.name} (${ticket.project.code})',
              style: textTheme.bodyLarge),
          const Divider(height: 32),
          Text('Assignee', style: textTheme.titleSmall),
          const SizedBox(height: 8),
          Text(ticket.assignee.fullName, style: textTheme.bodyLarge),
          Text(ticket.assignee.role, style: textTheme.bodyMedium),
          const Divider(height: 32),
          Text('Reporter', style: textTheme.titleSmall),
          const SizedBox(height: 8),
          Text(ticket.reporter.fullName, style: textTheme.bodyLarge),
          Text(ticket.reporter.role, style: textTheme.bodyMedium),
          const Divider(height: 32),
          Text('Tags', style: textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ticket.tags
                .map(
                  (t) => Chip(
                    label: Text(t.label),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                )
                .toList(),
          ),
          const Divider(height: 32),
          Text('Created', style: textTheme.titleSmall),
          const SizedBox(height: 8),
          Text(_formatCreated(ticket.createdAt), style: textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
