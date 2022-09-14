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
  RepoResult<R> safeLocalCall<R extends BaseResponse<E>, E>({
    required String key,
    required MapParser<E> mapParser,
  }) {
    try {
      final data = LocalDatabase.get(key);
      final response = _handleData<R, E>(data, mapParser);
      return RepoResult.success(response);
    } on Exception catch (exception) {
      final error = ErrorModel.parseException(exception);
      return RepoResult.failure(error);
    } catch (e) {
      return RepoResult.failure(null);
    }
  }

  Future<RepoResult<R>> safeRemoteCall<R extends BaseResponse<E>, E>({
    required Future request,
    required MapParser<E> mapParser,
    Function(Map<String, dynamic>)? cacheData,
  }) async {
    // (Dio documents)
    // The request was made and the server responded with a status code
    // Failed when out of the range of 2xx and jump into catch scope
    // => don't need to check status code == 200, et...
    try {
      // response data is Map (Map is expected)
      final data = (await request) as Map<String, dynamic>;
      if (cacheData != null) {
        cacheData(data);
      }
      final response = _handleData<R, E>(data, mapParser);
      return RepoResult.success(response);
    } on Exception catch (exception) {
      final error = ErrorModel.parseException(exception);
      return RepoResult.failure(error);
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
