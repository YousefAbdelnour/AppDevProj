import 'dart:ffi';

import 'package:cocktailproject/pages/AboutAppPage.dart';
import 'package:cocktailproject/pages/HistoryPage.dart';
import 'package:cocktailproject/pages/LogOutPage.dart';
import 'package:cocktailproject/pages/LandingPage.dart';
import 'package:cocktailproject/pages/RegisterPage.dart';
import 'package:cocktailproject/pages/SavedPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../sessionmanager.dart';
import '../widgets/BottomNavBar.dart';
import 'SearchPage.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Color buttonColor = Color(0xFFE0D9CB);
  SessionManager sessionManager = SessionManager();

  bool isLoggedIn(){
    bool loggedIn = sessionManager.isLoggedIn();
    return loggedIn;
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
            // Background Image at the bottom
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    //Account and Animation
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: buttonColor,
                            ),
                            child: Lottie.asset("assets/cocktailGuy.json"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Account',
                            style: TextStyle(
                              fontSize: 35.0, // Adjust font size as needed
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),
                    //To HomePage button
                    //To Search button
                    InkWell(
                      onTap: () {
                        Get.off(()=>const SearchPage(), transition: Transition.leftToRight);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Search",
                              style: TextStyle(
                                fontSize: 20.0, // Adjust font size as needed
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    //To HomePage button
                    InkWell(
                      onTap: () {
                        Get.off(()=>const SavedPage(), transition: Transition.leftToRight);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Saved Recipes",
                              style: TextStyle(
                                fontSize: 20.0, // Adjust font size as needed
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    //To HomePage button
                    InkWell(
                      onTap: () {
                        Get.off(()=>const HistoryPage(), transition: Transition.leftToRight);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "History",
                              style: TextStyle(
                                fontSize: 20.0, // Adjust font size as needed
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    //To HomePage button
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutAppPage()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "About",
                              style: TextStyle(
                                fontSize: 20.0, // Adjust font size as needed
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LogOutPage()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 50.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Log Out",
                              style: TextStyle(
                                fontSize: 20.0, // Adjust font size as needed
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Icon(Icons.arrow_forward),
                          ],
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
      bottomNavigationBar: BottomNavBar(index: 4),
    );
  }
}

