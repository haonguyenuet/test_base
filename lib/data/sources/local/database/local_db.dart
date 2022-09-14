import 'package:hive_flutter/hive_flutter.dart';

class LocalDatabase {
  static late Box _box;

  static Future<void> init() async {
    _box = await Hive.openBox('localDB');
  }

  static Future<void> put(String key, Map<String, dynamic> value) async {
    return await _box.put(key, value);
  }

  static Map<String, dynamic> get(String key) {
    return _box.get(key, defaultValue: <String, dynamic>{});
  }

  static Future<void> delele(String key) async {
    return await _box.delete(key);
  }
}
