import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_motivation/constants/font_constants.dart';
import 'package:mobile_motivation/models/preferences.dart';
import 'package:mobile_motivation/services/system/cubit/preferences_cubit.dart';
import 'package:mobile_motivation/utilities/dialogs/reset_preferences_dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesCubit, Preferences>(
      builder: (context, preferences) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Settings',
              style: TextStyle(
                fontFamily: courgetteFamily,
                fontSize: 30.0,
              ),
            ),
            automaticallyImplyLeading: true,
            actions: <Widget>[
              IconButton(
                onPressed: () async {
                  // Show the user a dialog to confirm whether they want
                  // to reset their current application preferences.
                  final shouldRestart =
                      await showResetPreferencesDialog(context);

                  // If the user decided to restart, then call
                  // on the Preferences bloc to delete all their preferences.
                  if (shouldRestart) {
                    if (!mounted) return;
                    context.read<PreferencesCubit>().deleteAllPreferences();
                  }
                },
                icon: const Icon(
                  Icons.restore,
                ),
              )
            ],
          ),
          body: ListView(
            children: [
              _buildThemeSelectionSettings(
                preferences,
                context,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeSelectionSettings(
    Preferences preferences,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(
        8.0,
      ),
      child: Column(
        children: <Widget>[
          RadioListTile<ThemeMode>(
            title: const Text(
              "Dark Mode",
              style: TextStyle(
                fontFamily: courgetteFamily,
                fontSize: 25.0,
              ),
            ),
            value: ThemeMode.dark,
            groupValue: preferences.themeMode,
            onChanged: (_) {
              context.read<PreferencesCubit>().changePreferences(
                    preferences.copyWith(
                      ThemeMode.dark,
                    ),
                  );
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text(
              "Light Mode",
              style: TextStyle(
                fontFamily: courgetteFamily,
                fontSize: 25.0,
              ),
            ),
            value: ThemeMode.light,
            groupValue: preferences.themeMode,
            onChanged: (_) {
              context.read<PreferencesCubit>().changePreferences(
                    preferences.copyWith(
                      ThemeMode.light,
                    ),
                  );
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text(
              "Automatic (follows system setting)",
              style: TextStyle(
                fontFamily: courgetteFamily,
                fontSize: 25.0,
              ),
            ),
            value: ThemeMode.system,
            groupValue: preferences.themeMode,
            onChanged: (_) {
              context.read<PreferencesCubit>().changePreferences(
                    preferences.copyWith(
                      ThemeMode.system,
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}
