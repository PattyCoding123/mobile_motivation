import 'package:flutter/material.dart';
import 'package:mobile_motivation/data/quote_model.dart';
import 'package:mobile_motivation/services/api_provider.dart';

void main() async {
  // Since our program will handle asynchronous tasks, we need
  // to ensure that our Widgets are binded.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
  late Future<QuoteModel> _quote;

  @override
  void initState() {
    // Call the fetchQuote method from our API provider class
    // in order to get the daily quote from zenquotes
    _quote = ApiProvider().fetchQuote();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // It is best to display the data using a FutureBuilder since we need to
    // wait for a response from the API which happens asyncronously.
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/images/background.jpg',
                width: size.width,
                height: size.height,
                fit: BoxFit.fill,
              ),
            ),
            FutureBuilder<QuoteModel>(
              future: _quote,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final quote = snapshot.data as QuoteModel;

                  return SafeArea(
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 50.0,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 50.0),
                          child: Text(
                            quote.quoteText!,
                            style: const TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontFamily: 'Courgette',
                            ),
                          ),
                        ),
                        Text(
                          quote.author!,
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    '${snapshot.error}',
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
