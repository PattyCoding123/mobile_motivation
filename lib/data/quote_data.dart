import 'package:flutter/material.dart';
import 'package:mobile_motivation/data/quote_model.dart';
import 'package:mobile_motivation/services/api_provider.dart';
import 'package:share_plus/share_plus.dart';

// The following widget will represent the logic for presenting the quote
// as a widget.
class Quote extends StatefulWidget {
  const Quote({Key? key}) : super(key: key);

  @override
  State<Quote> createState() => _QuoteState();
}

class _QuoteState extends State<Quote> {
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
    // The next widget is a FutureBuilder which receives a
    // Future<QuoteModel> as a snapshot. The quote is fetched
    // from the API provider.
    return FutureBuilder<QuoteModel>(
      future: _quote,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final quote = snapshot.data as QuoteModel;
          final _text = quote.quoteText;
          final _author = quote.author;

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(30.0),
                    child: const Text(
                      //_text!
                      'hellohellohellohellohellohellohellohellohellohhellohellohellohellohellohellohellohellohellohellohellohellohelloellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohello',
                      style: TextStyle(
                        fontSize: 40.0,
                        color: Colors.white,
                        fontFamily: 'Courgette',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '- ${_author!}',
                    style: const TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontFamily: 'Courgette',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () async {
                          if (_text!.isEmpty) {
                            // Implement dialog
                          } else {
                            Share.share('$_text - $_author');
                          }
                        },
                        icon: const Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          const snackBar = SnackBar(
                            content: Text(
                              'Added to your favorite quotes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text(
            '${snapshot.error}',
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
