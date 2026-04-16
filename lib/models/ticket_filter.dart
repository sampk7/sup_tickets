class TicketFilter {
  const TicketFilter({
    this.status,
    this.priority,
    this.projectId,
    this.assigneeId,
  });

  final String? status;
  final String? priority;
  final String? projectId;
  final String? assigneeId;

  TicketFilter copyWith({
    String? status,
    String? priority,
    String? projectId,
    String? assigneeId,
    bool clearStatus = false,
    bool clearPriority = false,
    bool clearProjectId = false,
    bool clearAssigneeId = false,
  }) {
    return TicketFilter(
      status: clearStatus ? null : (status ?? this.status),
      priority: clearPriority ? null : (priority ?? this.priority),
      projectId: clearProjectId ? null : (projectId ?? this.projectId),
      assigneeId: clearAssigneeId ? null : (assigneeId ?? this.assigneeId),
    );
  }
}
