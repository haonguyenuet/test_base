import 'package:custom_widgets/data/models/error_model.dart';

class RepoResult<R> {
  final bool isSuccess;
  final R? response;
  final ErrorModel? error;

  const RepoResult({
    this.isSuccess = false,
    this.response,
    this.error,
  });

  factory RepoResult.success(R? response) {
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
    void Function(R?)? success,
    void Function(ErrorModel?)? failure,
  }) {
    if (isSuccess) {
      return success?.call(response);
    } else {
      return failure?.call(error);
    }
  }
}
