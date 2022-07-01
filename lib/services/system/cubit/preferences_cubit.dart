import 'package:bloc/bloc.dart';
import 'package:mobile_motivation/models/preferences.dart';
import 'package:mobile_motivation/services/system/preferences_service.dart';

// Fluttter Bloc to control night and day themes
class PreferencesCubit extends Cubit<Preferences> {
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

  Future<void> deleteAllPreferences() async {
    await _service.clear();
    emit(
      Preferences.defaultValues(),
    );
  }
}
