import 'package:flutter_clean_architecture_bloc_template/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesDataSource {
  // Setter Section
  Future<void> setString(String key, String value);

  // Getter Section
  Future<String?> getString(String key);
  String getStringSync(String key);

  // Clear Data Section
  Future<void> clearData();
  Future<void> clearUserData();
}

class SharedPreferencesDataSourceImpl implements SharedPreferencesDataSource {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesDataSourceImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  String getStringSync(String key) {
    return _sharedPreferences.getString(key) ?? '';
  }

  @override
  Future<String?> getString(String key) async {
    return _sharedPreferences.getString(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  @override
  Future<void> clearData() async {
    await _sharedPreferences.clear();
  }

  @override
  Future<void> clearUserData() async {
    await _sharedPreferences.remove(Constants.accessTokenKey);
    await _sharedPreferences.remove(Constants.refreshTokenKey);
  }
}
