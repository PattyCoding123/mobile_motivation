import 'package:flutter/material.dart';
import 'package:mobile_motivation/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog({
  required BuildContext context,
  required String title,
  required String text,
}) {
  return showGenericDialog<void>(
    context: context,
    title: title,
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
