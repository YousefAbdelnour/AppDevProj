import 'dart:ffi';

import 'package:cocktailproject/pages/AboutAppPage.dart';
import 'package:cocktailproject/pages/LogOutPage.dart';
import 'package:cocktailproject/pages/LandingPage.dart';
import 'package:cocktailproject/pages/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IngredientPage extends StatefulWidget {
  const IngredientPage({Key? key}) : super(key: key);

  @override
  State<IngredientPage> createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {
  Color buttonColor = Color(0xFFE0D9CB);
  bool _selected = false;
  List<String> ingredients = [
    'Ingredient 1',
    'Ingredient 2',
    'Ingredient 3',
    'Ingredient 4',
    'Ingredient 5',
    'Ingredient 6',
    'Ingredient 7',
    'Ingredient 8',
    'Ingredient 9'
    // Add more ingredients as needed
  ];

  List<bool> _checkState = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkState = List.generate(ingredients.length, (index) => false);
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
                height: 50,
                color: Colors.blue,
                child: Image.asset(
                  'assets/cocktailHomePage.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Background Image at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
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
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    //Name Of Drink
                    Flexible(
                      child: Text(
                        'Coco for coconut',
                        style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade700,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: Offset(0, 4),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //DISPLAY IMAGE
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          'assets/testCocktail.jpg',
                          fit: BoxFit.cover,
                          width: 330,
                          height: 320,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade700,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: Offset(0, 4),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // List of ingredients
                    Expanded(
                      child: Scrollbar(
                        child: ListView.builder(
                          itemCount: ingredients.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              value: _checkState[index],
                              onChanged: (value) {
                                setState(() {
                                  _checkState[index] = value ?? false;
                                });
                              },
                              title: Text(ingredients[index], style: TextStyle(
                                fontSize: 20
                              ),),
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: Colors.brown,
                            );
                          },
                        ),
                        thickness: 10,
                        thumbVisibility: true,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add your onPressed functionality here
                      },
                      child: Text(
                        "Start Mixing!",
                        style: TextStyle(
                          color: Colors.white, // White text color
                          fontSize: 16, // Adjust font size as needed
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Adjust border radius as needed
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
