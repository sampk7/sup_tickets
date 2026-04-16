import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:support_ticket_inbox/data/mock_data.dart';
import 'package:support_ticket_inbox/models/project.dart';
import 'package:support_ticket_inbox/models/ticket_filter.dart';
import 'package:support_ticket_inbox/models/user.dart';
import 'package:support_ticket_inbox/providers/providers.dart';

const List<String> _statusOptions = [
  'Open',
  'In Progress',
  'Resolved',
  'Closed',
];

const List<String> _priorityOptions = [
  'Low',
  'Medium',
  'High',
  'Critical',
];

class FilterBar extends ConsumerWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(ticketFilterProvider);
    final projects = ref.watch(projectsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FilterChip(
              label: filter.status ?? 'Status',
              selected: filter.status != null,
              onTap: () => _showStatusSheet(context, ref, filter),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: filter.priority ?? 'Priority',
              selected: filter.priority != null,
              onTap: () => _showPrioritySheet(context, ref, filter),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: filter.projectId != null
                  ? projects
                      .firstWhere((p) => p.id == filter.projectId)
                      .name
                  : 'Project',
              selected: filter.projectId != null,
              onTap: () => _showProjectSheet(context, ref, filter, projects),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: filter.assigneeId != null
                  ? mockAssignees
                      .firstWhere((u) => u.id == filter.assigneeId)
                      .fullName
                  : 'Assignee',
              selected: filter.assigneeId != null,
              onTap: () => _showAssigneeSheet(context, ref, filter),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showStatusSheet(
    BuildContext context,
    WidgetRef ref,
    TicketFilter filter,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Clear'),
                onTap: () {
                  Navigator.of(context).pop();
                  ref.read(ticketListProvider.notifier).applyFilter(
                        filter.copyWith(clearStatus: true),
                      );
                },
              ),
              const Divider(height: 1),
              ..._statusOptions.map(
                (String s) => ListTile(
                  title: Text(s),
                  onTap: () {
                    Navigator.of(context).pop();
                    ref.read(ticketListProvider.notifier).applyFilter(
                          filter.copyWith(status: s),
                        );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showPrioritySheet(
    BuildContext context,
    WidgetRef ref,
    TicketFilter filter,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Clear'),
                onTap: () {
                  Navigator.of(context).pop();
                  ref.read(ticketListProvider.notifier).applyFilter(
                        filter.copyWith(clearPriority: true),
                      );
                },
              ),
              const Divider(height: 1),
              ..._priorityOptions.map(
                (String p) => ListTile(
                  title: Text(p),
                  onTap: () {
                    Navigator.of(context).pop();
                    ref.read(ticketListProvider.notifier).applyFilter(
                          filter.copyWith(priority: p),
                        );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showProjectSheet(
    BuildContext context,
    WidgetRef ref,
    TicketFilter filter,
    List<Project> projects,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Clear'),
                onTap: () {
                  Navigator.of(context).pop();
                  ref.read(ticketListProvider.notifier).applyFilter(
                        filter.copyWith(clearProjectId: true),
                      );
                },
              ),
              const Divider(height: 1),
              ...projects.map(
                (Project p) => ListTile(
                  title: Text(p.name),
                  subtitle: Text(p.code),
                  onTap: () {
                    Navigator.of(context).pop();
                    ref.read(ticketListProvider.notifier).applyFilter(
                          filter.copyWith(projectId: p.id),
                        );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showAssigneeSheet(
    BuildContext context,
    WidgetRef ref,
    TicketFilter filter,
  ) async {
    final assignees = mockAssignees;
    await showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        String query = '';
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final filteredAssignees = assignees.where((User user) {
              final q = query.trim().toLowerCase();
              if (q.isEmpty) {
                return true;
              }
              return user.fullName.toLowerCase().contains(q) ||
                  user.role.toLowerCase().contains(q);
            }).toList();
            return SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search assignee',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (value) {
                          setState(() {
                            query = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Clear'),
                      onTap: () {
                        Navigator.of(context).pop();
                        ref.read(ticketListProvider.notifier).applyFilter(
                              filter.copyWith(clearAssigneeId: true),
                            );
                      },
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredAssignees.length,
                        itemBuilder: (BuildContext context, int index) {
                          final u = filteredAssignees[index];
                          return ListTile(
                            title: Text(u.fullName),
                            subtitle: Text(u.role),
                            onTap: () {
                              Navigator.of(context).pop();
                              ref.read(ticketListProvider.notifier).applyFilter(
                                    filter.copyWith(assigneeId: u.id),
                                  );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
