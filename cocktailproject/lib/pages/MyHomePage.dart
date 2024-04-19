import 'package:flutter/material.dart';

import 'LoginPage.dart';
import 'RegisterPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Define the color from the hexadecimal code
    Color buttonColor = Color(0xFFE0D9CB); // 0xFF is the alpha value, followed by the hexadecimal code

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/cocktailHomePage.jpg', // Replace with your image asset path
            fit: BoxFit.cover,
          ),
          // Semi-transparent Overlay
          Container(
            color: Colors.black.withOpacity(0.5),
            // Adjust opacity as needed
          ),
          // Floating Drink Me Text
          Positioned(
            top: 150.0, // 25 padding below the top of the page
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Drink Me',
                style: TextStyle(
                  fontSize: 50.0, // Adjust font size as needed
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Buttons
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //Login button
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: SizedBox(
                  width: 350.0,
                  height: 50.0,

                  child: ElevatedButton(
                    onPressed: () {
                      //Navigate to Login page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,// Set button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0), // Set border radius to 0 for square shape
                      ),
                    ),
                    child: Text('Login', style: TextStyle(color: Colors.black87, fontSize: 30),),
                  ),
                ),
              ),

              //Register button
              Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: SizedBox(
                  width: 350.0,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0), // Set border radius to 0 for square shape
                      ),
                       // Set button color
                    ),
                    child: Text('Register', style: TextStyle(color: Colors.black87, fontSize: 30)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
