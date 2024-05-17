import 'package:cocktailproject/ApiManager.dart';
import 'package:cocktailproject/pages/RecipePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../cocktail.dart';

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
  @override
  void initState() {
    super.initState();
    fetchCocktailDetails();
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
                    Navigator.pop(context);
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        cocktail.thumbnail,
                        fit: BoxFit.cover,
                        width: 330,
                        height: 320,
                      ),
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
