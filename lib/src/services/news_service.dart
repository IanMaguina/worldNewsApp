import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/src/models/category_models.dart';
import 'package:newsapp/src/models/news_models.dart';
import 'package:http/http.dart' as http;

final  _urlNews = 'https://newsapi.org/v2';
final  _apikey = '3cd173b288964d2cbbe831d88b432830';


class NewsService with ChangeNotifier {
  
  List<Article> headlines = [];
  String _selectedCategory = 'business';

  List<Category> categories =[
    Category( FontAwesomeIcons.building, 'business'),
    Category( FontAwesomeIcons.tv, 'entertainment'),
    Category( FontAwesomeIcons.addressCard, 'general'),
    Category( FontAwesomeIcons.headSideVirus, 'health'),
    Category( FontAwesomeIcons.vials, 'science'),
    Category( FontAwesomeIcons.footballBall, 'sports'),
    Category( FontAwesomeIcons.memory, 'technology'),
  ];

  Map<String, List<Article>> categoryArticles = {};


  NewsService() {
    
    this.getTopHeadlines();

    categories.forEach((item) {
      this.categoryArticles[item.name] = new List();
     });


  }

  get selectedCategory => this._selectedCategory;
  set selectedCategory( String valor ){

    this._selectedCategory = valor;

    this.getArticlesByCategory(valor);

    notifyListeners();
  
  }


  getTopHeadlines() async{
    
    
    final url = '$_urlNews/top-headlines?apiKey=$_apikey&country=ca';

    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson( resp.body );

    this.headlines.addAll( newsResponse.articles );

    notifyListeners();
  }

  List<Article> get getArticulosCategoriaSeleccionada => this.categoryArticles[ this.selectedCategory ];







  getArticlesByCategory( String category) async{

    if( this.categoryArticles[category].length > 0){
      return this.categoryArticles[category];
    }

    final url = '$_urlNews/top-headlines?apiKey=$_apikey&category=$category';

    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson( resp.body );

    this.categoryArticles[category].addAll( newsResponse.articles );

    notifyListeners();

  }



}