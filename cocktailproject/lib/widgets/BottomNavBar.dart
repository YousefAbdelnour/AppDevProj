import 'package:cocktailproject/pages/HomePage.dart';
import 'package:cocktailproject/pages/SettingPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/LoginPage.dart';
import '../sessionmanager.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key, required this.index});
  int index;
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  SessionManager sessionManager = SessionManager();
  final _pageOptions = [
    HomePage(),
    HomePage(),
    SettingPage()
  ];
  bool isLoggedIn(){
    bool loggedIn = sessionManager.isLoggedIn();
    return loggedIn;
  }
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 2 && !isLoggedIn()) {
      Get.off(()=>const LoginPage(), transition: Transition.rightToLeftWithFade);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _pageOptions[_selectedIndex]),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex, //New
      onTap: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      selectedItemColor: Colors.white,
      backgroundColor: Colors.brown,
    );
  }
}
