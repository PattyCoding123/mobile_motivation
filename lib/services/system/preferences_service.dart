import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_motivation/models/preferences.dart';

// The PreferencesService class is what we will use to implement
// the shared_preferences plugin with out Preferences objects for the
// theme modes.
abstract class PreferencesService {
  Preferences get();
  Future<void> set(
    Preferences preferences,
  );
  Future<void> clear();
}

// Here is the main implementation of Preferences Service class.
class MainPreferencesService implements PreferencesService {
  // Key needed to utilize the shared_preferences plugin
  static const prefsKey = 'prefs';

  // private shared_preferences member - responsible for saving the users
  // preferences in the file system of their device
  final SharedPreferences _sharedPreferences;

  // Constructor of the Preferences Service class that will initialize the
  // private shared preferences member of the object.
  MainPreferencesService(
    this._sharedPreferences,
  );

  // The clear() function will call the currently initialized shared preferences
  // object in order to clear all the users currently saved preferences for
  // the application.
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
  /// which we can then retrieve later whenever the user opens
  /// the application.
  @override
  Future<void> set(Preferences preferences) async {
    final data = jsonEncode(
      preferences.toJson(),
    );

    await _sharedPreferences.setString(prefsKey, data);
  }
}
