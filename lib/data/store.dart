import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static Future<void> savedString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(key, value);
  }

  static Future<void> savedMap(String key, Map<String, dynamic> value) async {
    await savedString(key, jsonEncode(value));
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
}
