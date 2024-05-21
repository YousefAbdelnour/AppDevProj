import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cocktail.dart';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle; // Import rootBundle

class ApiManager {
  final String baseUrl = "https://www.thecocktaildb.com/api/json/v1/1";
  Map<String, List<String>>? flavorProfiles;

  ApiManager() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadFlavorProfiles();
  }

  Future<void> _loadFlavorProfiles() async {
    String data = await rootBundle.loadString('assets/flavor_profiles.json');
    Map<String, dynamic> jsonResult = json.decode(data);
    flavorProfiles = jsonResult.map((key, value) => MapEntry(key, List<String>.from(value)));
    print("Flavor Profiles Loaded: $flavorProfiles"); // Debug print
  }



  Future<List<Cocktail>> fetchRelatedCocktailsByFlavor(List<Cocktail> recentlyViewedDrinkIds) async {
    List<Cocktail> relatedCocktails = [];

    // Ensure flavor profiles are loaded before proceeding
    await _initialize();

    try {
      Set<String> recentlyViewedIngredients = {};

      // Loop through each recently viewed drink ID
      for (Cocktail drinkId in recentlyViewedDrinkIds) {
        var cocktailData = await fetchCocktailDetailsById(int.parse(drinkId.id));
        if (cocktailData['drinks'] != null && cocktailData['drinks'].isNotEmpty) {
          var cocktail = Cocktail.fromJson(cocktailData['drinks'][0]);
          print("Analyzing Cocktail: ${cocktail.name}");

          // Collect all ingredients from recently viewed cocktails
          for (String? ingredient in cocktail.ingredients) {
            if (ingredient != null && ingredient.isNotEmpty) {
              recentlyViewedIngredients.add(ingredient);
            }
          }
        } else {
          print("No drinks found for ID: ${drinkId.id}");
        }
      }

      // Fetch all cocktails
      var allCocktailsData = await listAllCocktails();
      if (allCocktailsData['drinks'] != null) {
        List<Cocktail> allCocktails = (allCocktailsData['drinks'] as List)
            .map((drink) => Cocktail.fromJson(drink))
            .toList();

        // Check for any ingredient match
        for (var cocktail in allCocktails) {
          bool matchFound = false;
          for (String? ingredient in cocktail.ingredients) {
            if (ingredient != null && ingredient.isNotEmpty && recentlyViewedIngredients.contains(ingredient)) {
              matchFound = true;
              break;
            }
          }
          if (matchFound) {
            relatedCocktails.add(cocktail);
            print("Cocktail ${cocktail.name} matches based on ingredient");
          }
        }
      } else {
        print("No drinks found in allCocktailsData");
      }
    } catch (e) {
      print("Error fetching related cocktails by flavor: $e");
    }

    print("Related Cocktails: $relatedCocktails");
    return relatedCocktails;
  }







  Future<dynamic> listAllCocktails() async {
    var url = Uri.parse('$baseUrl/search.php?s=');
    return _fetchData(url);
  }


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

  Future<Cocktail> fetchCocktailDetailsById2(int cocktailId) async {
    var url = Uri.parse('$baseUrl/lookup.php?i=$cocktailId');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['drinks'] != null && data['drinks'].isNotEmpty) {
        return Cocktail.fromJson(data['drinks'][0]);
      } else {
        throw Exception('No cocktail found');
      }
    } else {
      throw Exception('Failed to load cocktail details');
    }
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
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      } else {
        print('Failed to load data: ${response.statusCode} ${response.reasonPhrase}');
        return {'error': 'Failed to load data: ${response.statusCode} ${response.reasonPhrase}'};
      }
    } catch (e) {
      print('Error fetching data: $e');
      return {'error': 'Error fetching data: $e'};
    }
  }

}
