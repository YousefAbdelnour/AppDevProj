import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class AboutAppPage extends StatefulWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  @override
  Widget build(BuildContext context) {
    //Beige Color, since flutter doesn't have
    Color buttonColor = Color(0xFFE0D9CB);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/cocktailHomePage.jpg',
            fit: BoxFit.cover,
          ),
          // Semi-transparent Overlay
          Container(
            color: Colors.black.withOpacity(0.5),
            // Adjust opacity as needed
          ),

          //Cocktail Guy Animation
          Lottie.asset("assets/cocktailGuy.json"),


          // Floating Drink Me Text
          Positioned(
            top: 100.0, // 25 padding below the top of the page
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'About App',
                style: TextStyle(
                  fontSize: 50.0, // Adjust font size as needed
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          Positioned(
            top: 10.0, // 25 padding below the top of the page
            left: 0,
            child: Container(
              width: 40,
              height: 40,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: buttonColor,
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

          //Bottom Paragraph
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
                Text(
                  'Drink Me',
                  style: TextStyle(
                    fontSize: 20.0, // Adjust font size as needed
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Divider(color: Colors.white,),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                      'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                  style: TextStyle(
                    fontSize: 20.0, // Adjust font size as needed
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ]
            ),
          ),

        ],
      ),
    );
  }
}
