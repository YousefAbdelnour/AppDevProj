import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cocktail.dart';

class ApiManager {
  final String baseUrl = "https://www.thecocktaildb.com/api/json/v1/1";

  Future<CocktailList> fetchCocktails(String cocktailName) async {
    var url = Uri.parse('$baseUrl/search.php?s=$cocktailName');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return CocktailList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load cocktails');
    }
  }

  Future<dynamic> fetchCocktailsByFirstLetter(String firstLetter) async {
    var url = Uri.parse('$baseUrl/search.php?f=$firstLetter');
    return _fetchData(url);
  }

  Future<dynamic> fetchIngredientByName(String ingredientName) async {
    var url = Uri.parse('$baseUrl/search.php?i=$ingredientName');
    return _fetchData(url);
  }

  Future<dynamic> fetchCocktailDetailsById(int cocktailId) async {
    var url = Uri.parse('$baseUrl/lookup.php?i=$cocktailId');
    return _fetchData(url);
  }

  Future<dynamic> fetchIngredientDetailsById(int ingredientId) async {
    var url = Uri.parse('$baseUrl/lookup.php?iid=$ingredientId');
    return _fetchData(url);
  }

  Future<dynamic> fetchRandomCocktail() async {
    var url = Uri.parse('$baseUrl/random.php');
    return _fetchData(url);
  }

  Future<dynamic> filterCocktailsByIngredient(String ingredient) async {
    var url = Uri.parse('$baseUrl/filter.php?i=$ingredient');
    return _fetchData(url);
  }

  Future<dynamic> filterCocktailsByType(String type) async {
    var url = Uri.parse('$baseUrl/filter.php?a=$type');
    return _fetchData(url);
  }

  Future<dynamic> filterCocktailsByCategory(String category) async {
    var url = Uri.parse('$baseUrl/filter.php?c=$category');
    return _fetchData(url);
  }

  Future<dynamic> filterCocktailsByGlass(String glassType) async {
    var url = Uri.parse('$baseUrl/filter.php?g=$glassType');
    return _fetchData(url);
  }

  Future<dynamic> listOptions(String listType) async {
    var url = Uri.parse('$baseUrl/list.php?${listType}=list');
    return _fetchData(url);
  }

  Future<dynamic> _fetchData(Uri url) async {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
