import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences _prefs;
  static const _keyUser = 'user_id';
  static const _keySim = 'sim_slot';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? getUserId() => _prefs.getString(_keyUser);
  static Future<void> setUserId(String id) async => await _prefs.setString(_keyUser, id);

  static int? getSimSlot() => _prefs.getInt(_keySim);
  static Future<void> setSimSlot(int slot) async => await _prefs.setInt(_keySim, slot);

  static Future<void> clear() async {
    await _prefs.remove(_keyUser);
    await _prefs.remove(_keySim);
  }
}
