import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:support_ticket_inbox/models/pagination_meta.dart';
import 'package:support_ticket_inbox/models/project.dart';
import 'package:support_ticket_inbox/models/ticket.dart';
import 'package:support_ticket_inbox/models/user.dart';

const User kDefaultSarahUser = User(
  id: 'USR-101',
  fullName: 'Samuel Petros',
  email: 'samuelpkelbiso@gmail.com',
  role: 'Full-Stack Builder',
);

class MockData {
  static late PaginationMeta meta;
  static late List<Project> projects;
  static late List<Ticket> tickets;
  static late List<User> assignees;

  static Future<void> init() async {
    final jsonString = await rootBundle.loadString('assets/mock_data.json');
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;

    meta = PaginationMeta.fromJson(decoded['meta'] as Map<String, dynamic>);
    projects = (decoded['projects'] as List<dynamic>)
        .map((e) => Project.fromJson(e as Map<String, dynamic>))
        .toList();
    tickets = (decoded['tickets'] as List<dynamic>)
        .map((e) => Ticket.fromJson(e as Map<String, dynamic>))
        .toList();

    final byId = <String, User>{};
    for (final t in tickets) {
      byId[t.assignee.id] = t.assignee;
    }
    assignees = byId.values.toList()
      ..sort((a, b) => a.fullName.compareTo(b.fullName));
  }
}

PaginationMeta get mockPaginationMeta => MockData.meta;
List<Project> get mockProjects => MockData.projects;
List<Ticket> get mockTickets => MockData.tickets;
List<User> get mockAssignees => MockData.assignees;
