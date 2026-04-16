import 'package:support_ticket_inbox/models/project.dart';
import 'package:support_ticket_inbox/models/tag.dart';
import 'package:support_ticket_inbox/models/user.dart';

class Ticket {
  const Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.project,
    required this.assignee,
    required this.reporter,
    required this.tags,
  });

  final String id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final DateTime createdAt;
  final Project project;
  final User assignee;
  final User reporter;
  final List<Tag> tags;

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      priority: json['priority'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      project: Project.fromJson(json['project'] as Map<String, dynamic>),
      assignee: User.fromJson(json['assignee'] as Map<String, dynamic>),
      reporter: User.fromJson(json['reporter'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Ticket copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? priority,
    DateTime? createdAt,
    Project? project,
    User? assignee,
    User? reporter,
    List<Tag>? tags,
  }) {
    return Ticket(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      project: project ?? this.project,
      assignee: assignee ?? this.assignee,
      reporter: reporter ?? this.reporter,
      tags: tags ?? this.tags,
    );
  }
}
