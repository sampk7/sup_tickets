class Tag {
  const Tag({
    required this.id,
    required this.label,
  });

  final String id;
  final String label;

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] as String,
      label: json['label'] as String,
    );
  }

  Tag copyWith({
    String? id,
    String? label,
  }) {
    return Tag(
      id: id ?? this.id,
      label: label ?? this.label,
    );
  }
}
