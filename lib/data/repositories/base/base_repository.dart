import 'package:custom_widgets/data/models/error_model.dart';
import 'package:custom_widgets/data/repositories/base/base_response.dart';
import 'package:custom_widgets/data/repositories/base/repo_result.dart';

class BaseRepository {
  Future<RepoResult<R>> safeDBCall<R extends BaseResponse<E>, E>({
    required Future<dynamic> request,
  }) async {
    try {
      dynamic response = await request;
      // response data is Map (Map is expected)
      if (R.toString() == (SingleEntryResponse<E>).toString()) {
        return RepoResult.success(
          SingleEntryResponse<E>.fromEntity(response) as R,
        );
      }
      if (R.toString() == (ListEntriesResponse<E>).toString()) {
        return RepoResult.success(
          ListEntriesResponse<E>.fromEntity(response) as R,
        );
      }

      // response data is another type,
      return RepoResult.success(null);
    } on Exception catch (exception) {
      final error = ErrorModel.parseException(exception);
      return RepoResult.failure(error);
    }
  }

  Future<RepoResult<R>> safeApiCall<R extends BaseResponse<E>, E>({
    required Future<dynamic> request,
    MapParser<E>? mapParser,
  }) async {
    // (Dio documents)
    // The request was made and the server responded with a status code
    // Failed when out of the range of 2xx and jump into catch scope
    // => don't need to check status code == 200, et...
    try {
      dynamic responseData = await request;
      // response data is Map (Map is expected)
      if (responseData is Map<String, dynamic>) {
        if (R.toString() == (SingleEntryResponse<E>).toString()) {
          return RepoResult.success(
            SingleEntryResponse<E>.fromMap(responseData, mapParser) as R,
          );
        }
        if (R.toString() == (ListEntriesResponse<E>).toString()) {
          return RepoResult.success(
            ListEntriesResponse<E>.fromMap(responseData, mapParser) as R,
          );
        }
      }

      // response data is another type,
      return RepoResult.success(null);
    } on Exception catch (exception) {
      final error = ErrorModel.parseException(exception);
      return RepoResult.failure(error);
    }
  }
}
