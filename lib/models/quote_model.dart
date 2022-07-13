// The following class will be used to convert quote information
// in JSON format into class objects. We will be handling JSON
// objects from the zenquotes.io daily quote API

class QuoteModel {
  String? quoteText;
  String? author;
  String? help;

  QuoteModel({this.quoteText, this.author, this.help});

  QuoteModel.fromJson(Map<String, dynamic> json) {
    quoteText = json['q'];
    author = json['a'];
    help = json['h'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['q'] = quoteText;
    data['a'] = author;
    data['h'] = help;
    return data;
  }
}
