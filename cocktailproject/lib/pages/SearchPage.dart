import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../ApiManager.dart';
import '../cocktail.dart';
import '../sessionmanager.dart';
import 'IngredientPage.dart';
import 'LoginPage.dart';
import 'SettingPage.dart';
import 'package:cocktailproject/widgets/BottomNavBar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Color buttonColor = Color(0xFFE0D9CB);
  ApiManager api = ApiManager();
  late Future<Map<String, List<Cocktail>>> _cocktailListFuture;
  SessionManager sessionManager = SessionManager();
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _cocktailListFuture = fetchRandomCocktails();
  }

  Future<Map<String, List<Cocktail>>> fetchRandomCocktails() async {
    List<Cocktail> randomCocktails = [];
    try {
      for (int i = 0; i < 5; i++) {
        var cocktailData = await api.fetchRandomCocktail();
        var cocktail = Cocktail.fromJson(cocktailData['drinks'][0]);
        randomCocktails.add(cocktail);
      }
    } catch (e) {
      print("Error fetching random cocktails: $e");
    }
    return _categorizeCocktails(randomCocktails);
  }

  Future<void> _searchCocktails() async {
    setState(() {
      _cocktailListFuture = api.fetchCocktails(_searchQuery).then((cocktailList) {
        return _categorizeCocktails(cocktailList.drinks);
      }).catchError((error) {
        print("Error fetching data: $error");
        return <String, List<Cocktail>>{
          'Alcoholic': [],
          'Non_Alcoholic': [],
        };
      });
    });
  }

  Map<String, List<Cocktail>> _categorizeCocktails(List<Cocktail> cocktails) {
    Map<String, List<Cocktail>> categorizedCocktails = {
      'Alcoholic': [],
      'Non_Alcoholic': [],
    };
    for (var cocktail in cocktails) {
      if (cocktail.alcoholic == 'Alcoholic') {
        categorizedCocktails['Alcoholic']!.add(cocktail);
      } else {
        categorizedCocktails['Non_Alcoholic']!.add(cocktail);
      }
    }
    return categorizedCocktails;
  }

  bool isLoggedIn() {
    return sessionManager.isLoggedIn();
  }

  bool isDrinkSaved(String drinkId) {
    if (sessionManager.isLoggedIn()) {
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
            colors: [
              Colors.white,
              buttonColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: 50,
                color: Colors.blue,
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text(
                            'What Would You Like \nto Make Today?',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(
                            width: 10,
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
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search by name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                _searchQuery = _searchController.text;
                                _searchCocktails();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<Map<String, List<Cocktail>>>(
                        future: _cocktailListFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error fetching data"));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text("No cocktails found"));
                          } else {
                            var alcoholicCocktails = snapshot.data!['Alcoholic']!;
                            var nonAlcoholicCocktails = snapshot.data!['Non_Alcoholic']!;
                            return ListView(
                              children: [
                                if (alcoholicCocktails.isNotEmpty) ...[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Alcoholic:',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ...alcoholicCocktails.map((cocktail) => _buildCocktailCard(cocktail)),
                                ],
                                if (nonAlcoholicCocktails.isNotEmpty) ...[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Non-Alcoholic:',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ...nonAlcoholicCocktails.map((cocktail) => _buildCocktailCard(cocktail)),
                                ],
                              ],
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
      bottomNavigationBar: BottomNavBar(index: 1),
    );
  }

  Widget _buildCocktailCard(Cocktail cocktail) {
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

  }
}
