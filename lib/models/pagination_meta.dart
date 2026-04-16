class PaginationMeta {
  const PaginationMeta({
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.hasNextPage,
  });

  final int page;
  final int pageSize;
  final int totalCount;
  final bool hasNextPage;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      totalCount: json['totalCount'] as int,
      hasNextPage: json['hasNextPage'] as bool,
    );
  }

  PaginationMeta copyWith({
    int? page,
    int? pageSize,
    int? totalCount,
    bool? hasNextPage,
  }) {
    return PaginationMeta(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }
}
