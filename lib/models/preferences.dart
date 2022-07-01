import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'preferences.g.dart';

// To generate toJson model files, run:
// flutter packages pub run build_runner build --delete-conflicting-outputs

// We need to have a Preferences class that is json-serializable in order
// store user's previously saved preferences for the app.
@JsonSerializable()
class Preferences {
  static const themeModeDefaultValue = ThemeMode.system;

  // Make sure all fields have default values so that users
  // don't have their parsing crash if they don't have a new field saved.
  @JsonKey(
    defaultValue: themeModeDefaultValue,
  )

  // ThemeMode value that is to be initialized (since this is what will
  // be used to control the app's themes when the user is in the app.)
  final ThemeMode themeMode;

  // Constructor which initializes this Preferences' theme mode
  // which is
  Preferences(this.themeMode);

  // In the case there are no system preferences already stored,
  // then assign the default value to the themeMode member using
  // this factory constructor.
  factory Preferences.defaultValues() {
    return Preferences(
      themeModeDefaultValue,
    );
  }

  // In the case there are system preferences already stored,
  // they are already stored in the form of a json object which
  factory Preferences.fromJson(json) => _$PreferencesFromJson(
        Map<String, dynamic>.from(
          json,
        ),
      );

  // toJson method that will convert a Preferences object into a json object.
  Map<String, dynamic> toJson() => _$PreferencesToJson(
        this,
      );

  @override
  bool operator ==(Object other) {
    return identical(
          this,
          other,
        ) ||
        (other is Preferences && themeMode == other.themeMode);
  }

  @override
  String toString() {
    return 'Preferences($themeMode)';
  }

  @override
  int get hashCode => themeMode.hashCode;
}
