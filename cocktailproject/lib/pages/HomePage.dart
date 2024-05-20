import 'package:cocktailproject/pages/IngredientPage.dart';
import 'package:cocktailproject/widgets/BottomNavBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../ApiManager.dart';
import '../cocktail.dart';
import '../sessionmanager.dart';
import 'LoginPage.dart';
import 'SettingPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color buttonColor = Color(0xFFE0D9CB);
  ApiManager api = ApiManager();
  late Future<List<Cocktail>> _cocktailListFuture;
  SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    _cocktailListFuture = fetchRandomCocktails();
  }

  Future<List<Cocktail>> fetchRandomCocktails() async {
    List<Cocktail> randomCocktails = [];
    try {
      for (int i = 0; i < 5; i++) {
        var cocktailData = await api.fetchRandomCocktail();
        var cocktail = Cocktail.fromJson(cocktailData['drinks'][0]);
        randomCocktails.add(cocktail);
      }
    } catch (e) {
      // Handle error appropriately
      print("Error fetching random cocktails: $e");
    }
    return randomCocktails;
  }

  bool isLoggedIn(){
    bool loggedIn = sessionManager.isLoggedIn();
    return loggedIn;
  }

  bool isDrinkSaved(String drinkId){
    if(sessionManager.isLoggedIn()){
      List<String>? saved = sessionManager.currentUser?.savedDrinks;
      if(saved!.contains(drinkId)){
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
              colors: [
                Colors.white,
                buttonColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
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
                    //Account and Animation
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text(
                            'What Would You Like \nto Make Today?',
                            style: TextStyle(
                              fontSize: 25.0, // Adjust font size as needed
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
                    Expanded(
                      child: FutureBuilder<List<Cocktail>>(
                        future: _cocktailListFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error fetching data"));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text("No saved recipes"));
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data!.length, // Number of items in the list
                              itemBuilder: (context, index) {
                                final cocktail = snapshot.data![index];
                                // IF LOGGED IN, ON CLICK ADD CLICKED DRINK TO RECENTLY VIEW
                                // TRAVEL
                                return GestureDetector(
                                  onTap: () async {
                                    if(isLoggedIn()){
                                      sessionManager.addRecentlyViewedDrink(cocktail.id);
                                    }
                                    Get.to(()=>IngredientPage(cocktail: cocktail), transition: Transition.native, duration: Duration(seconds: 2));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:15, right: 15, bottom: 10),

                                    // IMAGE THUMBNAIL
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

                                      // Stack for containing bookmark icon and text
                                      child: Stack(
                                        children: [
                                          //BOOKMARK ICON
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
                                                      // Check if the drink is already saved
                                                      bool alreadySaved = isDrinkSaved(cocktail.id);
                                                      // Add or remove the drink from the user's saved drinks list
                                                      if (alreadySaved) {
                                                        await sessionManager.removeUserDrink(cocktail.id);
                                                      } else {
                                                        await sessionManager.addUserDrink(cocktail.id);
                                                      }
                                                      setState(() {

                                                      });
                                                    } else {
                                                      Get.to(()=>const LoginPage(), transition: Transition.rightToLeftWithFade);
                                                    }
                                                  },
                                                  icon: Icon(Icons.bookmark),
                                                  color: isDrinkSaved(cocktail.id) ? Colors.red : Colors.grey,
                                                ),

                                              ),
                                            ),
                                          ),

                                          // Positioned for the text at the bottom
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
                                                child: Text("${cocktail.name}\n"
                                                    "${cocktail.alcoholic}", // Replace with the cocktail name
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
            // Background Image at the bottom (now in front of the ListView)
          ],
        ),

      ),
      bottomNavigationBar: BottomNavBar(index: 0),
    );
  }
}
