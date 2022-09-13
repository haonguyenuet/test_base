import 'package:custom_widgets/data/models/error_model.dart';

class RepoResult<T> {
  final bool isSuccess;
  final T? response;
  final ErrorModel? error;

  const RepoResult({
    this.isSuccess = false,
    this.response,
    this.error,
  });

  factory RepoResult.success(T? response) {
    return RepoResult(
      isSuccess: true,
      response: response,
    );
  }

  factory RepoResult.failure(ErrorModel? error) {
    return RepoResult(
      isSuccess: false,
      error: error,
    );
  }

  void when({
    void Function(T?)? success,
    void Function(ErrorModel?)? failure,
  }) {
    if (isSuccess) {
      return success?.call(response);
    } else {
      return failure?.call(error);
    }
  }
}
