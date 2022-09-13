/*
Response as an object which usually includes the following keys:

- data: the response data itself, which could be:
  - null,
  - a single entry, as an object:
  - a list of entries, as an array of objects
- status: status of the request
- message: text from serverside
*/

class BaseResponse {
  final bool status;
  final String messsage;

  BaseResponse(this.status, this.messsage);
}

class SingleEntryResponse<T> extends BaseResponse {
  final T? data;

  SingleEntryResponse({
    this.data,
    bool status = false,
    String messsage = "",
  }) : super(status, messsage);

  factory SingleEntryResponse.fromMap(
    Map<String, dynamic> map,
    Function(Map<String, dynamic> map) fromMap,
  ) {
    return SingleEntryResponse<T>(
      status: map["status"],
      messsage: map["message"],
      data: map["data"] != null ? fromMap(map["data"]) : null,
    );
  }
}

class ListEntriesResponse<T> extends BaseResponse {
  final List<T> data;
  final Pagination pagination;

  ListEntriesResponse({
    required this.data,
    required this.pagination,
    bool status = false,
    String messsage = "",
  }) : super(status, messsage);

  factory ListEntriesResponse.fromMap(
    Map<String, dynamic> map,
    Function(Map<String, dynamic> map) fromMap,
  ) {
    return ListEntriesResponse<T>(
      status: map["status"],
      messsage: map["message"],
      data: map['data'] != null
          ? List<T>.from(map['data']?.map((x) => fromMap(x)))
          : [],
      pagination: Pagination.fromMap(map['pagination']),
    );
  }
}

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
