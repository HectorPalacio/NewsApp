import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/src/models/category_model.dart';
import 'package:newsapp/src/models/news_models.dart';
import 'package:http/http.dart' as http;

final _URL_NEWS = 'https://newsapi.org/v2';
final _APIKEY = '9278549875e54b69b3976a5ea72d8f1e';

class NewsService with ChangeNotifier {
  List<Article> headlines = [];
  String _selectedCategory = 'Business';

  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'Business'),
    Category(FontAwesomeIcons.tv, 'Entertainment'),
    Category(FontAwesomeIcons.addressCard, 'General'),
    Category(FontAwesomeIcons.headSideVirus, 'Health'),
    Category(FontAwesomeIcons.volleyballBall, 'Sports'),
    Category(FontAwesomeIcons.memory, 'Technology'),
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    this.getTopHeadlines();
    categories.forEach((item) {
      this.categoryArticles[item.name] = new List();
    });
  }

  getTopHeadlines() async {
    final url = '$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=co';
    final resp = await http.get(url);
    final newsResponse = newsResponseFromJson(resp.body);
    this.headlines.addAll(newsResponse.articles);
    notifyListeners();
  }

  get selectedCategory => this._selectedCategory;
  set selectedCategory(String valor) {
    this._selectedCategory = valor;
    this.getArticlesByCategory(valor);
    notifyListeners();
  }

  getArticlesByCategory(String category) async {
    if (this.categoryArticles[category].length > 0) {
      return this.categoryArticles[category];
    }
    final url =
        '$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=co&category=$category';
    final resp = await http.get(url);
    final newsResponse = newsResponseFromJson(resp.body);
    this.categoryArticles[category].addAll(newsResponse.articles);
    notifyListeners();
  }

  List<Article> get getArticulosCategoriaSeleccionada =>
      this.categoryArticles[this.selectedCategory];
}
