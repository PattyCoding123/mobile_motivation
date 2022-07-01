import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_motivation/models/preferences.dart';

abstract class PreferencesService {
  Preferences get();
  Future<void> set(
    Preferences preferences,
  );
  Future<void> clear();
}

class MyPreferencesService implements PreferencesService {
  // Key needed to utilize the shared_preferences plugin
  static const prefsKey = 'prefs';

  // shared_preferences member - responsible for saving the users
  // preferences in the file system of their device
  final SharedPreferences _sharedPreferences;

  MyPreferencesService(
    this._sharedPreferences,
  );

  @override
  Future<void> clear() async {
    _sharedPreferences.clear();
  }

  /// Gets the Preferences json as a string under [prefKey]
  /// Parses into a [Preferences] instance from json
  @override
  Preferences get() {
    final data = _sharedPreferences.getString(
      prefsKey,
    );
    if (data == null) {
      return Preferences.defaultValues();
    }

    final map = Map<String, dynamic>.from(
      jsonDecode(
        data,
      ),
    );

    return Preferences.fromJson(map);
  }

  /// Stores the entire Preferences json as a string under [prefsKey]
  @override
  Future<void> set(Preferences preferences) async {
    final data = jsonEncode(
      preferences.toJson(),
    );

    await _sharedPreferences.setString(prefsKey, data);
  }
}
