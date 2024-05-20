import 'package:cocktailproject/pages/HomePage.dart';
import 'package:cocktailproject/pages/SettingPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/SearchPage.dart';
import '../pages/LoginPage.dart';
import '../pages/SavedPage.dart';
import '../pages/ExplorePage.dart';
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
    SearchPage(),
    ExplorePage(),
    SavedPage(),
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

    if (_selectedIndex == 4 && !isLoggedIn() || _selectedIndex == 3 && !isLoggedIn()) {
      Get.to(()=>const LoginPage(), transition: Transition.rightToLeftWithFade);
      _selectedIndex = 0;
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
          icon: Icon(Icons.explore_outlined),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      selectedItemColor: Colors.white,
      backgroundColor: Colors.brown,
      type: BottomNavigationBarType.fixed,
    );
  }
}
