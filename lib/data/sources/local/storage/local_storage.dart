import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static late Box _basicStorage;
  static late FlutterSecureStorage _secureStorage;

  static late SecureKey cookie;
  static late BasicKey<bool> isDarkMode;

  static Future<void> init() async {
    _basicStorage = await Hive.openBox('basicStorage');
    _secureStorage = const FlutterSecureStorage();

    cookie = SecureKey("cookie", _secureStorage);
    isDarkMode = BasicKey("isDarkMode", _basicStorage);
  }
}

class SecureKey {
  final String key;
  final FlutterSecureStorage storage;

  SecureKey(this.key, this.storage);

  Future<void> set(String? value) async {
    return await storage.write(key: key, value: value);
  }

  Future<String?> get() async {
    return await storage.read(key: key);
  }

  Future<void> delete() async {
    return await storage.delete(key: key);
  }
}

class BasicKey<T> {
  final String key;
  final Box storage;

  BasicKey(this.key, this.storage);

  Future<void> set(T value) async {
    return await storage.put(key, value);
  }

  T? get() {
    return storage.get(key);
  }

  Future<void> delete() async {
    return await storage.delete(key);
  }
}
