import 'package:flutter/material.dart';
import 'package:mobile_motivation/data/quote_data.dart';

class QOTDView extends StatefulWidget {
  const QOTDView({Key? key}) : super(key: key);

  @override
  State<QOTDView> createState() => _QOTDViewState();
}

class _QOTDViewState extends State<QOTDView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Our main quotes page will be a Scaffold widget whose body
    // is a centered stack widget.
    return Scaffold(
      body: Center(
        // The stack widget will allow for overlapping the text in front
        // of a background image asset.
        child: Stack(
          children: <Widget>[
            // First, create the centered image asset.
            Center(
              child: Image.asset(
                'assets/images/background.jpg',
                width: size.width,
                height: size.height,
                fit: BoxFit.fill,
              ),
            ),
            const Quote(),
          ],
        ),
      ),
    );
  }
}
