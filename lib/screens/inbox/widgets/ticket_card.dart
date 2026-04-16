import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:support_ticket_inbox/models/ticket.dart';

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

class TicketCard extends StatelessWidget {
  const TicketCard({super.key, required this.ticket});

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () => context.push('/ticket/${ticket.id}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ticket.id,
                style: textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                ticket.title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(ticket.project.name, style: textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(ticket.assignee.fullName, style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    _formatCreated(ticket.createdAt),
                    style: textTheme.bodySmall,
                  ),
                  const Spacer(),
                  _Badge(
                    label: ticket.priority,
                    color: _priorityColor(ticket.priority),
                  ),
                  const SizedBox(width: 8),
                  _Badge(
                    label: ticket.status,
                    color: _statusColor(ticket.status),
                  ),
                ],
              ),
            ],
          ),
        ),
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
