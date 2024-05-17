import 'package:cocktailproject/pages/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../cocktail.dart';
import '../widgets/BottomNavBar.dart';
import 'IngredientPage.dart';

class RecipePage extends StatefulWidget {
  final Cocktail cocktail; // Add parameter for cocktail ID
  const RecipePage({Key? key, required this.cocktail}) : super(key: key);

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  List<bool> _checkState = [];
  List<String> recipes = [];
  late Cocktail cocktail;
  int lengthOfIng = 0;
  Color buttonColor = Color(0xFFE0D9CB);

  @override
  void initState() {
    super.initState();
    fetchCocktailDetails();
  }

  void fetchCocktailDetails() async {
    cocktail = widget.cocktail;
    //the api returns ingredients with null value, find the cutoff index
    for (int i = 0; i < cocktail.ingredients.length; i++) {
      if (cocktail.ingredients[i] == null) {
        lengthOfIng = i;
        break;
      }
    }
    //Split the recipe by .
    recipes = cocktail.instructions.split(".");
    print(cocktail.instructions);
    setState(() {
      _checkState = List.generate(cocktail.ingredients.length, (index) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Color(0xFFE0D9CB),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //POP BACK BUTTON
              Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          cocktail.thumbnail,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  cocktail.name,
                  style: TextStyle(
                    fontSize: 35.0,
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
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 25),
                child: Text(
                  'Ingredients',
                  style: TextStyle(
                    fontSize: 25.0,
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

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: lengthOfIng,
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
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 25),
                child: Text(
                  'Method',
                  style: TextStyle(
                    fontSize: 25.0,
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
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: recipes.length - 1,
                itemBuilder: (context, index) {
                  int step = index;
                  step++;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Step $step",
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${recipes[index]}\n",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  );
                },
              ),
              // Bottom button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Show congratulatory message
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Congratulations!"),
                          content: Text("You've completed the recipe for ${cocktail.name}. Enjoy your drink!"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.offAll(()=>HomePage(), transition: Transition.fade, duration: Duration(seconds: 1));
                              },
                              child: Text("OK", style: TextStyle(color: Colors.brown),),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text("Finish?", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.brown),
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
