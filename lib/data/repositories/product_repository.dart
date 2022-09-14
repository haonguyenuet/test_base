import 'package:custom_widgets/data/models/product_entry.dart';
import 'package:custom_widgets/data/repositories/base/base_repository.dart';
import 'package:custom_widgets/data/repositories/base/base_response.dart';
import 'package:custom_widgets/data/repositories/base/repo_result.dart';
import 'package:custom_widgets/data/sources/remote/api_client.dart';

class ProductRepository extends BaseRepository {
  final apiClient = ApiClient();

  Stream<RepoResult<ListEntriesResponse<ProductEntry>>> fetchProducts({
    FetchType fetchType = FetchType.both,
  }) async* {
    final request = apiClient.get(path: "/products");
    yield* expectListEntriesResponse<ProductEntry>(
      remoteReq: request,
      localKey: "/products",
      mapParser: ProductEntry.fromMap,
      fetchType: fetchType,
    );
  }

  Stream<RepoResult<SingleEntryResponse<ProductEntry>>> fetchProductById(
    String id, {
    FetchType fetchType = FetchType.both,
  }) async* {
    final request = apiClient.get(path: "/products");
    yield* expectSingleEntryResponse<ProductEntry>(
      remoteReq: request,
      localKey: "/products/$id",
      mapParser: ProductEntry.fromMap,
      fetchType: fetchType,
    );
  }
}
