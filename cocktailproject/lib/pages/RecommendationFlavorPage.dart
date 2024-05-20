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
  late Future<List<Cocktail>> _flavorRecommendationsFuture;

  @override
  void initState() {
    super.initState();
    _flavorRecommendationsFuture = fetchFlavorRecommendations();
  }

  Future<List<Cocktail>> fetchFlavorRecommendations() async {
    List<Cocktail> recommendations = [];
    try {
      for (String drinkId in sessionManager.currentUser?.recentlyViewedDrinks ?? []) {
        var cocktailData = await api.fetchCocktailDetailsById(int.parse(drinkId));
        var cocktail = Cocktail.fromJson(cocktailData['drinks'][0]);
        for (String? ingredient in cocktail.ingredients) {
          if (ingredient != null) {
            var ingredientData = await api.filterCocktailsByIngredient(ingredient);
            for (var drink in ingredientData['drinks']) {
              recommendations.add(Cocktail.fromJson(drink));
            }
          }
        }
      }
    } catch (e) {
      print("Error fetching flavor recommendations: $e");
    }
    return recommendations;
  }

  bool isLoggedIn() {
    bool loggedIn = sessionManager.isLoggedIn();
    return loggedIn;
  }

  bool isDrinkSaved(String drinkId) {
    if (sessionManager.isLoggedIn()) {
      List<String>? saved = sessionManager.currentUser?.savedDrinks;
      if (saved!.contains(drinkId)) {
        return true;
      }
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
                height: 50, // Adjust height as needed
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
                                fontSize: 25.0, // Adjust font size as needed
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
                            Get.to(() => RecommendationHistoryPage(), transition: Transition.rightToLeftWithFade);
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
                      child: FutureBuilder<List<Cocktail>>(
                        future: _flavorRecommendationsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error fetching data"));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text("No recommendations available"));
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final cocktail = snapshot.data![index];
                                return GestureDetector(
                                  onTap: () async {
                                    if (isLoggedIn()) {
                                      sessionManager.addRecentlyViewedDrink(cocktail.id);
                                    }
                                    Get.to(() => IngredientPage(cocktail: cocktail), transition: Transition.native, duration: Duration(seconds: 2));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                                    child: Container(
                                      width: 300, // Adjusted width
                                      height: 350,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(cocktail.thumbnail), // Replace with your image asset
                                          fit: BoxFit.cover,
                                        ),
                                        border: Border.all(
                                          color: Colors.black, // Border color
                                          width: 1, // Border width
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
                                              width: 363, // Adjusted width
                                              height: 120,
                                              decoration: BoxDecoration(
                                                color: Colors.brown,
                                                border: Border.all(
                                                  color: Colors.black, // Border color set to white
                                                  width: 2, // Border width
                                                ),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(15),
                                                  bottomRight: Radius.circular(15),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "${cocktail.name}\n${cocktail.alcoholic}", // Replace with the cocktail name
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
