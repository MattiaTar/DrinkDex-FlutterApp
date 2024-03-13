import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  writeSecureData(String key, String value,)async {
    await storage.write(key: key, value: value);
  }
  readSecureData(String key) async {
    String value = await storage.read(key: key) ?? 'non Trovato';
    print('Dati letti dal Secure Storage: $value');
  }
  deleteSecureData(String key) async {
    await storage.delete(key: key);
  }
}