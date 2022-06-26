import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_motivation/constants/font_constants.dart';
import 'package:mobile_motivation/data/quote_model.dart';
import 'package:mobile_motivation/services/auth/bloc/auth_bloc.dart';

import 'package:share_plus/share_plus.dart';

// The following widget will represent the logic for presenting the quote
// as a widget.
class ShowQuoteView extends StatelessWidget {
  final QuoteModel? quoteOfTheDay;
  const ShowQuoteView({
    Key? key,
    this.quoteOfTheDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (quoteOfTheDay != null) {
      final text = quoteOfTheDay!.quoteText;
      final author = quoteOfTheDay!.author;
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(30.0),
                child: Text(
                  text!,
                  style: const TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                    fontFamily: courgetteFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                '- ${author!}',
                style: const TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                  fontFamily: courgetteFamily,
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () async {
                      if (text.isEmpty) {
                        // Implement dialog
                      } else {
                        Share.share('$text - $author');
                      }
                    },
                    icon: const Icon(
                      Icons.share,
                      size: 30.0,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            AuthEventAddFavoriteQuote(
                              quoteOfTheDay!,
                            ),
                          );
                      // FirebaseCloudStorage().createNewQuote(
                      //   ownerUserId: FirebaseAuthProvider().currentUser!.id,
                      //   quote: quoteOfTheDay!,
                      // );
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
                      size: 30.0,
                      color: Colors.red,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: const Text(
            'A quote is not visible right now. Instead, check out previously liked quotes.',
            style: TextStyle(
              fontFamily: courgetteFamily,
              fontSize: 30.0,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}
