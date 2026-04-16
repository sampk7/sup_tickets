import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:support_ticket_inbox/data/mock_data.dart';
import 'package:support_ticket_inbox/models/project.dart';
import 'package:support_ticket_inbox/models/ticket.dart';
import 'package:support_ticket_inbox/models/tag.dart';
import 'package:support_ticket_inbox/providers/providers.dart';

class CreateTicketScreen extends ConsumerStatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  ConsumerState<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends ConsumerState<CreateTicketScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _status = 'Open';
  String _priority = 'Medium';
  Project? _project;

  static const List<String> _statusOptions = [
    'Open',
    'In Progress',
    'Resolved',
    'Closed',
  ];

  static const List<String> _priorityOptions = [
    'Low',
    'Medium',
    'High',
    'Critical',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final Project project = _project!;
    final Ticket ticket = Ticket(
      id: 'TCK-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      status: _status,
      priority: _priority,
      createdAt: DateTime.now(),
      project: project,
      assignee: kDefaultSarahUser,
      reporter: kDefaultSarahUser,
      tags: const <Tag>[],
    );
    ref.read(ticketListProvider.notifier).addTicket(ticket);
    if (context.mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);
    _project ??= projects.isNotEmpty ? projects.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Ticket'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (String? value) {
                final String v = value?.trim() ?? '';
                if (v.isEmpty) {
                  return 'Title is required';
                }
                if (v.length < 3) {
                  return 'Title must be at least 3 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: _statusOptions
                  .map(
                    (String s) => DropdownMenuItem<String>(
                      value: s,
                      child: Text(s),
                    ),
                  )
                  .toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() => _status = value);
                }
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: _priorityOptions
                  .map(
                    (String p) => DropdownMenuItem<String>(
                      value: p,
                      child: Text(p),
                    ),
                  )
                  .toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() => _priority = value);
                }
              },
            ),
            const SizedBox(height: 12),
            if (_project != null)
              DropdownButtonFormField<Project>(
                value: _project,
                decoration: const InputDecoration(
                  labelText: 'Project',
                  border: OutlineInputBorder(),
                ),
                items: projects
                    .map(
                      (Project p) => DropdownMenuItem<Project>(
                        value: p,
                        child: Text(p.name),
                      ),
                    )
                    .toList(),
                onChanged: (Project? value) {
                  if (value != null) {
                    setState(() => _project = value);
                  }
                },
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _project == null ? null : _submit,
              child: const Text('Create Ticket'),
            ),
          ],
        ),
      ),
    );
  }
}
