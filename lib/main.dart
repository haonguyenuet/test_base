// ignore_for_file: avoid_print

import 'package:custom_widgets/data/repositories/base/base_repository.dart';
import 'package:custom_widgets/data/repositories/product_repository.dart';
import 'package:custom_widgets/data/sources/local/database/local_db.dart';
import 'package:custom_widgets/data/sources/local/storage/local_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await LocalStorage.init();
  await LocalDatabase.init();

  final repo = ProductRepository();
  repo.fetchProducts(fetchType: FetchType.both).listen((repoResult) {
    repoResult.when(
      success: (response) {
        print("Response data: ${response?.data}");
      },
      failure: (error) {
        print("Error: $error");
      },
    );
  });
}
