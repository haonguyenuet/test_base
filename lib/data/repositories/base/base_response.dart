/*
Response as an object which usually includes the following keys:

- data: the response data itself, which could be:
  - a single entry, as an object (or null)
  - a list of entries, as an array of objects
- status: status of the request
- message: text from serverside
*/

typedef MapParser<E> = E Function(Map<String, dynamic> map);

class BaseResponse<E> {
  final bool status;
  final String messsage;
  bool get isSuccess => status == true;

  BaseResponse(this.status, this.messsage);
}

class SingleEntryResponse<E> extends BaseResponse<E> {
  final E? data;

  SingleEntryResponse({
    this.data,
    bool status = false,
    String messsage = "",
  }) : super(status, messsage);

  factory SingleEntryResponse.fromMap(
    Map<String, dynamic> map,
    MapParser<E> mapParser,
  ) {
    return SingleEntryResponse<E>(
      status: map.containsKey("status") ? map["status"] : false,
      messsage: map.containsKey("message") ? map["message"] : "",
      data: map.containsKey("data") && map['data'] != null
          ? mapParser(map["data"])
          : null,
    );
  }
}

class ListEntriesResponse<E> extends BaseResponse<E> {
  final List<E> data;
  final Pagination pagination;

  ListEntriesResponse({
    required this.data,
    required this.pagination,
    bool status = false,
    String messsage = "",
  }) : super(status, messsage);

  factory ListEntriesResponse.fromMap(
    Map<String, dynamic> map,
    MapParser<E> mapParser,
  ) {
    return ListEntriesResponse<E>(
      status: map.containsKey("status") ? map["status"] : false,
      messsage: map.containsKey("message") ? map["message"] : "",
      data: map.containsKey("data") && map['data'] != null
          ? List<E>.from(map['data']?.map((x) => mapParser(x)))
          : [],
      pagination: map.containsKey("pagination") && map['pagination'] != null
          ? Pagination.fromMap(map['pagination'])
          : const Pagination(),
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
