
class Pagination {
  final int page;
  final int pageSize;
  final int pageCount;
  final int total;

  const Pagination({
    this.page = 0,
    this.pageSize = 0,
    this.pageCount = 0,
    this.total = 0,
  });

  factory Pagination.fromMap(Map<String, dynamic> map) {
    return Pagination(
      page: map['page'] ?? 0,
      pageSize: map['pageSize'] ?? 0,
      pageCount: map['pageCount'] ?? 0,
      total: map['total'] ?? 0,
    );
  }
}