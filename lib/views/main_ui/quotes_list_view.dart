import 'package:flutter/material.dart';
import 'package:mobile_motivation/services/cloud/cloud_quote.dart';
import 'package:mobile_motivation/utilities/dialogs/delete_dialog.dart';

// typedef function that will be called if user decides to delete the quote.
// The function definition will be defined as a parameter in the call
// to QuotesListView (this is the beauty of typedef functions!).
typedef QuoteCallback = void Function(CloudQuote note);

class QuotesListView extends StatelessWidget {
  final Iterable<CloudQuote> quotes;
  final QuoteCallback onDeleteQuote;

  const QuotesListView({
    Key? key,
    required this.quotes, // Need an Iterable of CloudNotes for ListView widget
    required this.onDeleteQuote, // Widget utilizing this view must handle onDeleteNote
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (quotes.isNotEmpty) {
      return Card(
        child: ListView.builder(
          itemCount: quotes.length,
          itemBuilder: (context, index) {
            // Individual quote in the Iterable of CloudQuotes
            final quote = quotes.elementAt(index);
            return ListTile(
              title: Text(
                quote.text,
                style: const TextStyle(
                  fontFamily: 'Courgette',
                  fontSize: 25.0,
                ),
                softWrap: true,
              ),
              subtitle: Text(
                quote.author,
                style: const TextStyle(
                  fontFamily: 'Courgette',
                  fontSize: 20.0,
                ),
                softWrap: true,
              ),
              trailing: IconButton(
                onPressed: () async {
                  // First, wait for user confirmation from Dialog
                  final shouldDelete = await showDeleteDialog(context);
                  // If user wants to delete, call onDeleteNote with parameter definition
                  // passing whatever note was selected for onDeleteNote.
                  if (shouldDelete) {
                    onDeleteQuote(quote);
                  }
                },
                icon: const Icon(
                  Icons.remove,
                  color: Colors.red,
                ),
              ),
            );
          },
        ),
      );
    } else {
      return const Center(
        child: Text(
          'You have no favorite quotes!',
          style: TextStyle(
            fontFamily: 'Courgette',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
}
