import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cocktailproject/ApiManager.dart';
import 'package:cocktailproject/cocktail.dart';
import 'package:cocktailproject/pages/RecommendationHistoryPage.dart';
import 'package:cocktailproject/widgets/BottomNavBar.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'IngredientPage.dart';
import 'LoginPage.dart';
import '../sessionmanager.dart';

class RecommendationFlavorPage extends StatefulWidget {
  @override
  _RecommendationFlavorPageState createState() => _RecommendationFlavorPageState();
}

class _RecommendationFlavorPageState extends State<RecommendationFlavorPage> {
  Color buttonColor = Color(0xFFE0D9CB);
  ApiManager api = ApiManager();
  SessionManager sessionManager = SessionManager();
  late Future<Map<String, List<Cocktail>>> _relatedCocktailsFuture;

  @override
  void initState() {
    super.initState();
    _relatedCocktailsFuture = fetchRelatedCocktails();
  }

  Future<Map<String, List<Cocktail>>> fetchRelatedCocktails() async {
    if (SessionManager().isLoggedIn()) {
      List<String> recentlyViewedDrinkIds = SessionManager().currentUser!.recentlyViewedDrinks;
      List<Cocktail> recentlyViewedCocktails = await Future.wait(recentlyViewedDrinkIds.map((id) async {
        var cocktail = await api.fetchCocktailDetailsById2(int.parse(id));
        return cocktail;
      }));
      Map<String, List<Cocktail>> relatedCocktails = {};

      Set<String> recentlyViewedIngredients = {};
      for (Cocktail cocktail in recentlyViewedCocktails) {
        for (String? ingredient in cocktail.ingredients) {
          if (ingredient != null && ingredient.isNotEmpty) {
            recentlyViewedIngredients.add(ingredient);
          }
        }
      }

      var allCocktailsData = await api.listAllCocktails();
      if (allCocktailsData['drinks'] != null) {
        List<Cocktail> allCocktails = (allCocktailsData['drinks'] as List)
            .map((drink) => Cocktail.fromJson(drink))
            .toList();

        for (var cocktail in allCocktails) {
          for (String? ingredient in cocktail.ingredients) {
            if (ingredient != null && ingredient.isNotEmpty && recentlyViewedIngredients.contains(ingredient)) {
              if (!relatedCocktails.containsKey(ingredient)) {
                relatedCocktails[ingredient] = [];
              }
              relatedCocktails[ingredient]!.add(cocktail);
            }
          }
        }
      }
      return relatedCocktails;
    } else {
      throw Exception("User not logged in");
    }
  }

  bool isLoggedIn() {
    return sessionManager.isLoggedIn();
  }

  bool isDrinkSaved(String drinkId) {
    if (isLoggedIn()) {
      List<String>? saved = sessionManager.currentUser?.savedDrinks;
      return saved != null && saved.contains(drinkId);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, buttonColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Background Image at the top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: 50,
                child: Image.asset(
                  'assets/cocktailHomePage.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    // Account and Animation
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Flavor Based Recommendations',
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: buttonColor,
                            ),
                            child: Lottie.asset("assets/cocktailGuy.json"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Get.to(() => RecommendationHistoryPage(),
                                transition: Transition.rightToLeftWithFade);
                          },
                          icon: Icon(Icons.history, color: Colors.white),
                          label: Text("History", style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: FutureBuilder<Map<String, List<Cocktail>>>(
                        future: _relatedCocktailsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error fetching data: ${snapshot.error}"));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text("No recommendations available"));
                          } else {
                            // Select 3 random categories and 2 drinks under each
                            var categories = snapshot.data!.entries.toList();
                            categories.shuffle();
                            var selectedCategories = categories.take(3).toList();

                            return ListView.builder(
                              itemCount: selectedCategories.length,
                              itemBuilder: (context, index) {
                                final entry = selectedCategories[index];
                                final cocktails = entry.value.take(2).toList();
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Because you liked ${entry.key}:",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      ...cocktails.map((cocktail) {
                                        return GestureDetector(
                                          onTap: () async {
                                            if (isLoggedIn()) {
                                              sessionManager.addRecentlyViewedDrink(cocktail.id);
                                            }
                                            Get.to(() => IngredientPage(cocktail: cocktail),
                                                transition: Transition.native,
                                                duration: Duration(seconds: 2));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                                            child: Container(
                                              width: 300,
                                              height: 350,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(cocktail.thumbnail),
                                                  fit: BoxFit.cover,
                                                ),
                                                border: Border.all(
                                                  color: Colors.black,
                                                  width: 1,
                                                ),
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    right: 0,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        width: 40,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.all(Radius.circular(30)),
                                                        ),
                                                        child: IconButton(
                                                          onPressed: () async {
                                                            if (isLoggedIn()) {
                                                              bool alreadySaved = isDrinkSaved(cocktail.id);
                                                              if (alreadySaved) {
                                                                await sessionManager.removeUserDrink(cocktail.id);
                                                              } else {
                                                                await sessionManager.addUserDrink(cocktail.id);
                                                              }
                                                              setState(() {});
                                                            } else {
                                                              Get.to(() => const LoginPage(), transition: Transition.rightToLeftWithFade);
                                                            }
                                                          },
                                                          icon: Icon(Icons.bookmark),
                                                          color: isDrinkSaved(cocktail.id) ? Colors.red : Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    child: Container(
                                                      width: 363,
                                                      height: 120,
                                                      decoration: BoxDecoration(
                                                        color: Colors.brown,
                                                        border: Border.all(
                                                          color: Colors.black,
                                                          width: 2,
                                                        ),
                                                        borderRadius: BorderRadius.only(
                                                          bottomLeft: Radius.circular(15),
                                                          bottomRight: Radius.circular(15),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          "${cocktail.name}\n${cocktail.alcoholic}",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(index: 2),
    );
  }
}
