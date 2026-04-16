class PaginationMeta {
  const PaginationMeta({
    required this.nextCursor,
    required this.pageSize,
    required this.totalCount,
  });

  final String? nextCursor;
  final int pageSize;
  final int totalCount;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      nextCursor: json['nextCursor'] as String?,
      pageSize: json['pageSize'] as int,
      totalCount: json['totalCount'] as int,
    );
  }

  PaginationMeta copyWith({
    String? nextCursor,
    int? pageSize,
    int? totalCount,
    bool clearNextCursor = false,
  }) {
    return PaginationMeta(
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
