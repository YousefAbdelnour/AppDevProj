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
  List<Cocktail> cocktailList = [];
  SessionManager sessionManager = SessionManager();
  @override
  void initState() {
    super.initState();
    fetchRandomCocktails();
  }

  void fetchRandomCocktails() async {
    try {
      List<Cocktail> randomCocktails = [];
      for (int i = 0; i < 5; i++) {
        var cocktailData = await api.fetchRandomCocktail();
        var cocktail = Cocktail.fromJson(cocktailData['drinks'][0]);
        randomCocktails.add(cocktail);
      }
      setState(() {
        cocktailList = randomCocktails;
      });
    } catch (e) {
      // Handle error appropriately
      print("Error fetching random cocktails: $e");
    }
  }
  final _pageOptions = [
    HomePage(),
    HomePage(),
    SettingPage()
  ];

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pageOptions[_selectedIndex]),
    );
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
                      child: ListView.builder(
                        itemCount: cocktailList.length, // Number of items in the list
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              Get.to(()=>IngredientPage(cocktail: cocktailList[index]), transition: Transition.native, duration: Duration(seconds: 2));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left:15, right: 15, bottom: 10),
                              child: Container(
                                width: 300, // Adjusted width
                                height: 350,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(cocktailList[index].thumbnail), // Replace with your image asset
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
                                              // Implement bookmark functionality here
                                              if (isLoggedIn()) {
                                                // Check if the drink is already saved
                                                bool alreadySaved = isDrinkSaved(cocktailList[index].id);
                                                // Add or remove the drink from the user's saved drinks list
                                                if (alreadySaved) {
                                                  await sessionManager.removeUserDrink(cocktailList[index].id);
                                                } else {
                                                  await sessionManager.addUserDrink(cocktailList[index].id);
                                                }
                                                // Update the UI to reflect the change
                                                setState(() {
                                                  print(sessionManager.currentUser?.savedDrinks);
                                                });
                                              } else {
                                                // Redirect to the login page if the user is not logged in
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => LoginPage()),
                                                );
                                              }
                                            },
                                            icon: Icon(Icons.bookmark),
                                            color: isDrinkSaved(cocktailList[index].id) ? Colors.red : Colors.grey,
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
                                          child: Text("${cocktailList[index].name}\n"
                                              "${cocktailList[index].alcoholic}", // Replace with the cocktail name
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
