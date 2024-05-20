import 'package:cocktailproject/widgets/BottomNavBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../ApiManager.dart';
import '../cocktail.dart';
import '../sessionmanager.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  Color buttonColor = Color(0xFFE0D9CB);
  ApiManager api = ApiManager();
  SessionManager sessionManager = SessionManager();
  late Future<List<Cocktail>> _cocktailListFuture;

  @override
  void initState() {
    super.initState();
    _cocktailListFuture = loadDrinkToList();
  }

  Future<List<Cocktail>> loadDrinkToList() async {
    List<Cocktail> list = [];
    try {
      for (var i = 0; i < sessionManager.currentUser!.savedDrinks.length; i++) {
        var cocktailData = await api.fetchCocktailDetailsById(int.parse(sessionManager.currentUser!.savedDrinks[i]));
        var cocktail = Cocktail.fromJson(cocktailData['drinks'][0]);
        list.add(cocktail);
      }
    } catch (e) {
      // Handle error appropriately
      print("Error fetching random cocktails: $e");
    }
    return list;
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
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  // Account and Animation
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Saved Recipes',
                          style: TextStyle(
                            fontSize: 25.0, // Adjust font size as needed
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
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
                  SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                            return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final cocktail = snapshot.data![index];
                                return GestureDetector(
                                  onTap: () {
                                    // Handle tap on the grid item
                                  },
                                  child: Container(
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
                                        // Bookmark icon
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () async {
                                              sessionManager.removeUserDrink(cocktail.id);
                                              setState(() {
                                                snapshot.data!.removeAt(index); // Remove the item from the snapshot data
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(8),
                                              child: Icon(
                                                Icons.bookmark,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Positioned for the text at the bottom
                                        Positioned(
                                          bottom: 0,
                                          child: Container(
                                            width: 170, // Adjusted width
                                            height: 50,
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
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(index: 3),
    );
  }
}
