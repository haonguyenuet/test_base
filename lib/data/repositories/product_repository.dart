import 'package:custom_widgets/data/models/product_model.dart';
import 'package:custom_widgets/data/repositories/base/base_repository.dart';
import 'package:custom_widgets/data/repositories/base/base_response.dart';
import 'package:custom_widgets/data/repositories/base/repo_result.dart';
import 'package:custom_widgets/data/sources/remote/api_client.dart';

class ProductRepository extends BaseRepository {
  final apiClient = ApiClient();

  Future<RepoResult<ListEntriesResponse<ProductModel>>> getProducts() async {
    final request = apiClient.get(path: "/products");
    return await safeApiCall<ListEntriesResponse<ProductModel>, ProductModel>(
      request: request,
      mapParser: ProductModel.fromMap,
    );
  }

  Future<RepoResult<SingleEntryResponse<ProductModel>>> getProductById(
    String id,
  ) async {
    final request = apiClient.get(path: "/products/$id");
    return await safeApiCall<SingleEntryResponse<ProductModel>, ProductModel>(
      request: request,
      mapParser: ProductModel.fromMap,
    );
  }

  // Future<RepoResult<SingleEntryResponse<ProductModel>>> postProduct() async {
  //   final request = apiClient.post(
  //     path: "/products",
  //     body: {},
  //   );
  //   return await safeApiCall<SingleEntryResponse<ProductModel>, ProductModel>(
  //     request: request,
  //     mapParser: ProductModel.fromMap,
  //   );
  // }

  // Future<RepoResult<SingleEntryResponse<ProductModel>>> deleteProduct(
  //   String id,
  // ) async {
  //   final request = apiClient.delete(path: "/product/$id");
  //   return await safeApiCall<SingleEntryResponse<ProductModel>, ProductModel>(
  //     request: request,
  //     mapParser: ProductModel.fromMap,
  //   );
  // }
}
