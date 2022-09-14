import 'package:custom_widgets/data/models/product_model.dart';
import 'package:custom_widgets/data/repositories/base/base_repository.dart';
import 'package:custom_widgets/data/repositories/base/base_response.dart';
import 'package:custom_widgets/data/repositories/base/repo_result.dart';
import 'package:custom_widgets/data/sources/local/database/local_db.dart';
import 'package:custom_widgets/data/sources/remote/api_client.dart';

class ProductRepository extends BaseRepository {
  final apiClient = ApiClient();

  Stream<RepoResult<ListEntriesResponse<ProductModel>>> fetchProducts({
    FetchType fetchType = FetchType.both,
  }) async* {
    if (fetchType.needFetchFromLocal) {
      yield safeLocalCall(
        key: "/products" ,
        mapParser: ProductModel.fromMap,
      );
    }

    if (fetchType.needFetchFromRemote) {
      final request = apiClient.get(path: "/products");
      yield await safeRemoteCall<ListEntriesResponse<ProductModel>, ProductModel>(
        request: request,
        mapParser: ProductModel.fromMap,
        cacheData: (data) {
          LocalDatabase.put("/products", data);
        },
      );
    }
  }
}
