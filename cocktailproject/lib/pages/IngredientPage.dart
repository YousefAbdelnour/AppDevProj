import 'package:cocktailproject/ApiManager.dart';
import 'package:cocktailproject/pages/HomePage.dart';
import 'package:cocktailproject/pages/RecipePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../cocktail.dart';
import '../sessionmanager.dart';
import 'LoginPage.dart';

class IngredientPage extends StatefulWidget {
  final Cocktail cocktail; // Add parameter for cocktail ID
  const IngredientPage({Key? key, required this.cocktail}) : super(key: key);

  @override
  State<IngredientPage> createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {
  Color buttonColor = Color(0xFFE0D9CB);
  List<bool> _checkState = [];
  ApiManager api = ApiManager();
  late Cocktail cocktail;
  int lenghtOfIng = 0;
  SessionManager sessionManager = SessionManager();
  @override
  void initState() {
    super.initState();
    fetchCocktailDetails();
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

  void fetchCocktailDetails() async {
      cocktail = widget.cocktail;
      //the api returns ingredients with null value, find the cutoff index
      for(int i = 0; i < cocktail.ingredients.length; i++){
        if(cocktail.ingredients[i] == null){
          lenghtOfIng = i;
          break;
        }
      }
      setState(() {
        _checkState = List.generate(cocktail.ingredients.length, (index) => false);
      });
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

            //POP BACK BUTTON
            Positioned(
              top: 10.0, // 25 padding below the top of the page
              left: 0,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  onPressed: (){
                    Get.off(()=>HomePage());
                    //Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                  color: Colors.black,
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
                        cocktail.name,
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
                    Stack(
                      alignment: Alignment.topRight, // Ensure the alignment of the Stack is set properly
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            cocktail.thumbnail,
                            fit: BoxFit.cover,
                            width: 330,
                            height: 320,
                          ),
                        ),
                        //BOOKMARK ICON
                        Positioned(
                          top: 8, // Add top padding to ensure it's not too close to the edge
                          right: 8, // Add right padding to ensure it's not too close to the edge
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
                                    print(sessionManager.currentUser?.savedDrinks);
                                  });
                                } else {
                                  Get.to(() => const LoginPage(), transition: Transition.rightToLeftWithFade);
                                }
                              },
                              icon: Icon(Icons.bookmark),
                              color: isDrinkSaved(cocktail.id) ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                      ],
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
                          itemCount: lenghtOfIng,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              value: _checkState[index],
                              onChanged: (value) {
                                setState(() {
                                  _checkState[index] = value ?? false;
                                });
                              },
                              title: Text(
                                "${cocktail.ingredients[index] ?? ''} ${cocktail.measures[index] ?? ''}",
                                style: TextStyle(fontSize: 20),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: Colors.brown,
                            );
                          },
                        ),
                        thickness: 10,
                        thumbVisibility: true,
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0, // Adjust the value as needed for vertical spacing
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(()=>RecipePage(cocktail: cocktail),
                        transition: Transition.circularReveal, duration: Duration(seconds: 2));
                  },
                  child: Text(
                    "Start Mixing!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
