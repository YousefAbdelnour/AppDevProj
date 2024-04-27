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
}
