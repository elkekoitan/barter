import 'package:shared_preferences/shared_preferences.dart';

abstract class CacheManager {
  Future<bool> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<bool> remove(String key);
  Future<bool> clearAll();
}

class CacheManagerImpl implements CacheManager {
  final SharedPreferences _prefs;

  CacheManagerImpl(this._prefs);

  @override
  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  @override
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
