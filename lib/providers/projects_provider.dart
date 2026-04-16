import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:support_ticket_inbox/data/mock_data.dart';
import 'package:support_ticket_inbox/models/project.dart';

final projectsProvider = Provider<List<Project>>((ref) => MockData.projects);
