import 'package:flutter/material.dart';
import 'package:mobile_motivation/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing Error',
    content: 'There is no quote to share!',
    optionsBuilder: () => {'OK': null},
  );
}
