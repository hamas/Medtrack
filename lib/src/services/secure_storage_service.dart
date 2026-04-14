import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final Provider<SecureStorageService> secureStorageProvider = Provider<SecureStorageService>((Ref ref) {
  return SecureStorageService();
});

class SecureStorageService {
  SecureStorageService()
    : _storage = const FlutterSecureStorage(
        aOptions: AndroidOptions.defaultOptions,
      );

  final FlutterSecureStorage _storage;

  Future<void> writeData({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> readData({required String key}) async {
    return _storage.read(key: key);
  }

  Future<void> deleteData({required String key}) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
