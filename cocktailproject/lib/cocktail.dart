import 'ApiManager.dart';

class CocktailList {
  final List<Cocktail> drinks;

  CocktailList({required this.drinks});

  factory CocktailList.fromJson(Map<String, dynamic> json) {
    var list = json['drinks'] as List;
    List<Cocktail> drinksList = list.map((i) => Cocktail.fromJson(i)).toList();
    return CocktailList(drinks: drinksList);
  }

  Map<String, dynamic> toJson() {
    return {
      'drinks': drinks.map((drink) => drink.toJson()).toList(),
    };
  }
}

class Cocktail {
  final String id;
  final String name;
  final String? alternateName;
  final String? tags;
  final String? video;
  final String category;
  final String? iba;
  final String alcoholic;
  final String glass;
  final String instructions;
  final String? instructionsES;
  final String? instructionsDE;
  final String? instructionsFR;
  final String? instructionsIT;
  final String? instructionsZH_HANS;
  final String? instructionsZH_HANT;
  final String thumbnail;
  final List<String?> ingredients;
  final List<String?> measures;
  final String? imageSource;
  final String? imageAttribution;
  final String? creativeCommonsConfirmed;
  final String? dateModified;

  Cocktail({
    required this.id,
    required this.name,
    this.alternateName,
    this.tags,
    this.video,
    required this.category,
    this.iba,
    required this.alcoholic,
    required this.glass,
    required this.instructions,
    this.instructionsES,
    this.instructionsDE,
    this.instructionsFR,
    this.instructionsIT,
    this.instructionsZH_HANS,
    this.instructionsZH_HANT,
    required this.thumbnail,
    required this.ingredients,
    required this.measures,
    this.imageSource,
    this.imageAttribution,
    this.creativeCommonsConfirmed,
    this.dateModified,
  });

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    List<String?> ingredients = [];
    List<String?> measures = [];

    for (int i = 1; i <= 15; i++) {
      ingredients.add(json['strIngredient$i']);
      measures.add(json['strMeasure$i']);
    }

    return Cocktail(
      id: json['idDrink'],
      name: json['strDrink'],
      alternateName: json['strDrinkAlternate'],
      tags: json['strTags'],
      video: json['strVideo'],
      category: json['strCategory'],
      iba: json['strIBA'],
      alcoholic: json['strAlcoholic'],
      glass: json['strGlass'],
      instructions: json['strInstructions'],
      instructionsES: json['strInstructionsES'],
      instructionsDE: json['strInstructionsDE'],
      instructionsFR: json['strInstructionsFR'],
      instructionsIT: json['strInstructionsIT'],
      instructionsZH_HANS: json['strInstructionsZH-HANS'],
      instructionsZH_HANT: json['strInstructionsZH-HANT'],
      thumbnail: json['strDrinkThumb'],
      ingredients: ingredients,
      measures: measures,
      imageSource: json['strImageSource'],
      imageAttribution: json['strImageAttribution'],
      creativeCommonsConfirmed: json['strCreativeCommonsConfirmed'],
      dateModified: json['dateModified'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idDrink'] = this.id;
    data['strDrink'] = this.name;
    data['strDrinkAlternate'] = this.alternateName;
    data['strTags'] = this.tags;
    data['strVideo'] = this.video;
    data['strCategory'] = this.category;
    data['strIBA'] = this.iba;
    data['strAlcoholic'] = this.alcoholic;
    data['strGlass'] = this.glass;
    data['strInstructions'] = this.instructions;
    data['strInstructionsES'] = this.instructionsES;
    data['strInstructionsDE'] = this.instructionsDE;
    data['strInstructionsFR'] = this.instructionsFR;
    data['strInstructionsIT'] = this.instructionsIT;
    data['strInstructionsZH-HANS'] = this.instructionsZH_HANS;
    data['strInstructionsZH-HANT'] = this.instructionsZH_HANT;
    data['strDrinkThumb'] = this.thumbnail;
    for (int i = 1; i <= ingredients.length; i++) {
      data['strIngredient$i'] = ingredients[i - 1];
      data['strMeasure$i'] = measures[i - 1];
    }
    data['strImageSource'] = this.imageSource;
    data['strImageAttribution'] = this.imageAttribution;
    data['strCreativeCommonsConfirmed'] = this.creativeCommonsConfirmed;
    data['dateModified'] = this.dateModified;
    return data;
  }
}

// Usage
// To decode JSON:
// var cocktailList = CocktailList.fromJson(jsonDecode(jsonString));

// To encode JSON:
// String jsonString = jsonEncode(cocktailList.toJson());
