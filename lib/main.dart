import 'package:flutter/material.dart';
import 'package:mobile_motivation/data/quote_data.dart';

void main() async {
  // Since our program will handle asynchronous tasks, we need
  // to ensure that our Widgets are binded.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
