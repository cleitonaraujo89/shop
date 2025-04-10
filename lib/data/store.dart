import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(key, value);
  }

  static Future<void> saveMap(String key, Map<String, dynamic> value) async {
    await saveString(key, jsonEncode(value));
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key);
  }

  static Future<Map<String, dynamic>?> getMap(String key) async {
    try {
      final stringValue = await getString(key);
      if (stringValue == null) return null;

      final decoded = jsonDecode(stringValue);
      if (decoded is Map<String, dynamic>){
         return decoded;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }    
  }

  static Future<bool?> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.remove(key);
  }
}
