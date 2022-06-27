import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_motivation/data/quote_model.dart';
import 'package:mobile_motivation/services/cloud/cloud_quote.dart';
import 'package:mobile_motivation/services/cloud/cloud_storage_constants.dart';
import 'package:mobile_motivation/services/cloud/cloud_storage_exceptions.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class FirebaseCloudStorage {
  // Database member that is initialized via Firebase Cloud Firestore
  // collection method. The collection's name is passed as the argument.
  final quotes = FirebaseFirestore.instance.collection('quotes');

  // Method to delete a specific quote
  Future<void> deleteQuote({required String documentId}) async {
    try {
      // quotes.doc(documentId) is the path towards the specific quote document
      // that is in the "quotes" collection
      await quotes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteQuoteException();
    }
  }

  // // Method to update a specific quote
  // Future<void> updateQuote({
  //   required String documentId,
  //   required String text,
  // }) async {
  //   try {
  //     // quotes.doc(documentId) is the path towards the specific note document
  //     // that is in the "quotes" collection
  //     await quotes.doc(documentId).update({textFieldName: text});
  //   } catch (e) {
  //     throw CouldNotUpdateQuoteException();
  //   }
  // }

  // Method to get all the notes for a specified user as a Stream of an Iterable
  // of CloudQuotes
  Stream<Iterable<CloudQuote>> allQuotes({required String ownerUserId}) {
    final allQuotes = quotes
        // where filters out all quotes by the ownerUserIdFieldName constant
        // or 'user_id' such that we only retrieve the notes that have
        // a user_id equal to the parameter of this function.
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        // "snapshot" subscribes us to all the changes happening to the firestore
        // data, and we will map these changes to the stream (since snapshots
        // is a stream of QuerySnapshots). We will be inserting an Iterable of
        // CloudQuotes to the stream.
        .snapshots()
        .map((event) => event.docs // Get documents from snapshot
            // Return an Iterable of CloudNotes. These notes are constructed
            // by the documents from firestore.
            .map((doc) => CloudQuote.fromSnapshot(doc)));

    return allQuotes;
  }

  // Method to create new quotes and store them into the Cloud Firestore database.
  // Use cloud_storage_constants to fill in field name requirements.
  Future<void> createNewQuote({
    required String ownerUserId,
    required QuoteModel quote,
  }) async {
    // Check to see if the quote actually does exist.
    final doesQuoteExist = await quotes
        .where(
          ownerUserIdFieldName,
          isEqualTo: ownerUserId,
        )
        .where(
          textFieldName,
          isEqualTo: quote.quoteText,
        )
        .get()
        .then(
      (docSnapshot) {
        if (docSnapshot.size != 0) {
          return true;
        } else {
          return false;
        }
      },
    );

    // If quote exists, add it the collection.
    if (!doesQuoteExist) {
      quotes.add({
        ownerUserIdFieldName: ownerUserId,
        textFieldName: quote.quoteText,
        authorFieldName: quote.author,
      });
    }
  }

  // Instance that calls to private factory constructor
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  // Private factory constructor
  FirebaseCloudStorage._sharedInstance();

  // Singleton constructor that calls to the _shared instance
  factory FirebaseCloudStorage() => _shared;
}
