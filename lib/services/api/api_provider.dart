import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_motivation/data/quote_model.dart';

class ApiProvider {
  final url = 'https://zenquotes.io/api/today';

  // Returns a Quote from the http.Response
  Future<QuoteModel> fetchQuote() async {
    final response = await http.get(
      Uri.parse(
        url,
      ),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK reponse,
      // then parse the JSON using the QuoteModel factory constructor.

      // The API returns data formatted as a JSON array.
      List<dynamic> jsonList = jsonDecode(
        response.body,
      );

      return QuoteModel.fromJson(
        // Since the API returns a JSON array with 1 JSON object, we need to
        // parse the first element.
        jsonList[0],
      );
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
        'Failed to load daily quote',
      );
    }
  }
}
