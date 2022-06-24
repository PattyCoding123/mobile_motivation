class NetworkErrorAuthException implements Exception {
  final String dialogTitle = 'Network Error';
  final String dialogText = 'Could not retrieve your motivation quote.';

  const NetworkErrorAuthException();
}
