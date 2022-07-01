import 'package:flutter/material.dart';
import 'package:mobile_motivation/utilities/dialogs/generic_dialog.dart';

Future<bool> showResetPreferencesDialog(BuildContext context) {
  // Because showGenericDialog returns T?, we need a safeguard return
  return showGenericDialog(
    context: context,
    title: 'Reset Preferences',
    content:
        'Are you sure you want to reset the preferences for this application?',
    optionsBuilder: () => {
      'Cancel': false,
      'Reset': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
