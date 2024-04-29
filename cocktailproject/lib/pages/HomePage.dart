import 'dart:ffi';

import 'package:cocktailproject/pages/AboutAppPage.dart';
import 'package:cocktailproject/pages/IngredientPage.dart';
import 'package:cocktailproject/pages/LogOutPage.dart';
import 'package:cocktailproject/pages/LandingPage.dart';
import 'package:cocktailproject/pages/RegisterPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

import '../ApiManager.dart';
import '../cocktail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color buttonColor = Color(0xFFE0D9CB);
  ApiManager api = ApiManager();
  List<Cocktail> cocktailList = [];

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
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => IngredientPage(cocktail: cocktailList[index])),
                              );
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
                                    // Positioned for the bookmark icon
                                    Positioned(
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
                                            onPressed: () {
                                              // Implement bookmark functionality here
                                            },
                                            icon: Icon(Icons.bookmark),
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      right: 0,
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
                                              fontSize: 30,
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
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Image.asset(
                  'assets/cocktailHomePage.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}
