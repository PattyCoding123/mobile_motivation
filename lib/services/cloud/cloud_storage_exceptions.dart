class CloudStorageException implements Exception {
  const CloudStorageException();
}

// Create exception in CRUD
// class CouldNotCreateQuoteException extends CloudStorageException {}

// Read exception in CRUD
// class CouldNotGetAllQuotesException extends CloudStorageException {}

// Update exception in CRUD
// class CouldNotUpdateQuoteException extends CloudStorageException {}

// Delete exception in CRUD
class CouldNotDeleteQuoteException extends CloudStorageException {
  final dialogTitle = 'Deletion Error';
  final dialogText = 'We could not delete the quote at this time.';
}
