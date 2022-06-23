import 'package:flutter/material.dart';
import 'package:mobile_motivation/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  // Because showGenericDialog returns T?, we need a safeguard return
  return showGenericDialog(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this quote from favorites?',
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
