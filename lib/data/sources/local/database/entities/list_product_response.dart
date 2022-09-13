import 'package:custom_widgets/data/models/pagination_model.dart';
import 'package:custom_widgets/data/models/product_model.dart';
import 'package:hive/hive.dart';

part 'list_product_response.g.dart';

@HiveType(typeId: 0)
class ListProductResponse {
  @HiveField(0)
  final List<ProductModel> data;

  @HiveField(1)
  final Pagination pagination;

  ListProductResponse({
    this.data = const <ProductModel>[],
    required this.pagination,
  });
}
