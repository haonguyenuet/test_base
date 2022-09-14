import 'package:hive_flutter/hive_flutter.dart';

class LocalDatabase {
  static late Box<String> _box;

  static Future<void> init() async {
    _box = await Hive.openBox('localDB');
  }

  static Future<void> put(dynamic key, String value) async {
    return await _box.put(key, value);
  }

  static String get(dynamic key) {
    return _box.get(key) ?? "{}";
  }

  static Future<void> delele(String key) async {
    return await _box.delete(key);
  }
}
