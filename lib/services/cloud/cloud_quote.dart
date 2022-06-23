import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_motivation/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudQuote {
  final String documentId;
  final String ownerUserId;
  final String text;
  final String author;

  const CloudQuote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
    required this.author,
  });

  // Factory constructor to make a CloudQuote object from a
  // QueryDocumentSnapshot object which is from Cloud Firestore.
  // A document in represented as a QueryDocumentSnapshot.
  CloudQuote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String,
        author = snapshot.data()[authorFieldName] as String;
}
