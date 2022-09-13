/*
Response as an object which usually includes the following keys:

- data: the response data itself, which could be:
  - null,
  - a single entry, as an object:
  - a list of entries, as an array of objects
- status: status of the request
- message: text from serverside
*/

import 'package:custom_widgets/data/models/pagination_model.dart';

typedef MapParser<E> = E Function(Map<String, dynamic> map)?;
typedef EntityMapper<E> = E Function(Map<String, dynamic> map)?;


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
      status: map["status"] ?? false,
      messsage: map["message"] ?? "",
      data: map["data"] != null && mapParser != null
          ? mapParser(map["data"])
          : null,
    );
  }

  factory SingleEntryResponse.fromEntity(entity) {
    return SingleEntryResponse<E>(
      status: true,
      messsage: "",
      data: entity.data,
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
      status: map["status"] ?? false,
      messsage: map["message"] ?? "",
      data: map['data'] != null && mapParser != null
          ? List<E>.from(map['data']?.map((x) => mapParser(x)))
          : [],
      pagination: Pagination.fromMap(map['pagination']),
    );
  }

  factory ListEntriesResponse.fromEntity(entity) {
    return ListEntriesResponse<E>(
      status: true,
      messsage: "",
      data: entity.data,
      pagination: entity.pagination,
    );
  }
}
