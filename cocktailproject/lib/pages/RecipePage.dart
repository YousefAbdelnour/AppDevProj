import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../cocktail.dart';

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
                itemCount: recipes.length-1,
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
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/cocktailHomePage.jpg',
                    ),
                    fit: BoxFit.cover
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
