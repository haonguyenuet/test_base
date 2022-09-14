import 'dart:convert';
import 'dart:developer';

import 'package:custom_widgets/data/models/error_model.dart';
import 'package:custom_widgets/data/repositories/base/base_response.dart';
import 'package:custom_widgets/data/repositories/base/repo_result.dart';
import 'package:custom_widgets/data/sources/local/database/local_db.dart';

enum FetchType {
  // only fetch data from databse,
  onlylLocal,
  // only fetch data from remote (api)
  onlyRemote,
  // fetch data from database before remote
  both
}

extension FetchTypeExt on FetchType {
  bool get needFetchFromLocal =>
      this == FetchType.onlylLocal || this == FetchType.both;

  bool get needFetchFromRemote =>
      this == FetchType.onlyRemote || this == FetchType.both;
}

class BaseRepository {
  Stream<RepoResult<SingleEntryResponse<E>>> expectSingleEntryResponse<E>({
    required Future remoteReq,
    required String localKey,
    required MapParser<E> mapParser,
    FetchType fetchType = FetchType.both,
    bool cacheData = true,
  }) async* {
    yield* _handleRequest<SingleEntryResponse<E>, E>(
      remoteReq: remoteReq,
      localKey: localKey,
      mapParser: mapParser,
      fetchType: fetchType,
      cacheData: cacheData,
    );
  }

  Stream<RepoResult<ListEntriesResponse<E>>> expectListEntriesResponse<E>({
    required Future remoteReq,
    required String localKey,
    required MapParser<E> mapParser,
    FetchType fetchType = FetchType.both,
    bool cacheData = true,
  }) async* {
    yield* _handleRequest<ListEntriesResponse<E>, E>(
      remoteReq: remoteReq,
      localKey: localKey,
      mapParser: mapParser,
      fetchType: fetchType,
      cacheData: cacheData,
    );
  }

  Stream<RepoResult<R>> _handleRequest<R extends BaseResponse<E>, E>({
    required Future remoteReq,
    required String localKey,
    required MapParser<E> mapParser,
    FetchType fetchType = FetchType.both,
    bool cacheData = true,
  }) async* {
    try {
      if (fetchType.needFetchFromLocal) {
        log("fetch data from databse");
        final encodedData = LocalDatabase.get(localKey);
        final data = json.decode(encodedData) as Map<String, dynamic>;
        final response = _handleData<R, E>(data, mapParser);
        yield RepoResult.success(response);
      }

      if (fetchType.needFetchFromRemote) {
        log("fetch data from remote");
        // (Dio documents)
        // The request was made and the server responded with a status code
        // Failed when out of the range of 2xx and jump into catch scope
        // => don't need to check status code == 200, et...
        final data = (await remoteReq) as Map<String, dynamic>;
        if (cacheData == true) {
          final decodedData = json.encode(data);
          LocalDatabase.put(localKey, decodedData);
        }
        final response = _handleData<R, E>(data, mapParser);
        yield RepoResult.success(response);
      }
    } catch (exception) {
      log("catch error");
      final error = ErrorModel.parseException(exception);
      yield RepoResult.failure(error);
    }
  }

  R _handleData<R extends BaseResponse<E>, E>(
    Map<String, dynamic> data,
    MapParser<E> mapParser,
  ) {
    if (R.toString() == (SingleEntryResponse<E>).toString()) {
      return SingleEntryResponse<E>.fromMap(data, mapParser) as R;
    } else {
      return ListEntriesResponse<E>.fromMap(data, mapParser) as R;
    }
  }
}
