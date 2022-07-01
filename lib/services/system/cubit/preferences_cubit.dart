import 'package:bloc/bloc.dart';
import 'package:mobile_motivation/models/preferences.dart';
import 'package:mobile_motivation/services/system/preferences_service.dart';

// Flutter Bloc to control night and day themes
class PreferencesCubit extends Cubit<Preferences> {
  // Private Preferences member
  final PreferencesService _service;

  PreferencesCubit(
    this._service,
    Preferences initialState,
  ) : super(
          initialState,
        );

  Future<void> changePreferences(Preferences preferences) async {
    await _service.set(preferences);
    emit(preferences);
  }

  // The Bloc will call the clear function
  Future<void> deleteAllPreferences() async {
    await _service.clear();
    emit(
      Preferences.defaultValues(),
    );
  }
}
