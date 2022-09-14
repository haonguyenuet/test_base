import 'package:custom_widgets/data/repositories/product_repository.dart';
import 'package:custom_widgets/data/sources/local/database/local_db.dart';
import 'package:custom_widgets/data/sources/local/storage/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

var logger = Logger();
void main() async {
  await Hive.initFlutter();
  await LocalStorage.init();
  await LocalDatabase.init();

  final repo = ProductRepository();
  repo.fetchProducts().listen((repoResult) {
    print(repoResult.response?.data);
  });
}
