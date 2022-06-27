import 'package:flutter/material.dart';
import 'package:mobile_motivation/constants/font_constants.dart';

// typedef function that returns a mapping of string keys with value T?.
// The function will be defined as a map of String:T? values
// in the parameter of showGeneric dialog.
typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  // Remember, optionsBuilder returns Map<String, T?>, which is a mapping of
  // all the options and the types they return. Assign to options variable.
  final options = optionsBuilder();
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: courgetteFamily,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(
            fontFamily: courgetteFamily,
            fontSize: 20.0,
          ),
        ),

        // We will create a list of TextButtons using the map that was returned
        // optionsBuilder. optionTitle is the key for each pair.
        actions: options.keys.map((optionTitle) {
          final T value = options[optionTitle];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(
              optionTitle,
              style: const TextStyle(
                fontFamily: courgetteFamily,
                fontSize: 20.0,
              ),
            ),
          );
        }).toList(),
      );
    },
  );
}
