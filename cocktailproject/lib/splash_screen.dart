import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cocktailproject/pages/LandingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(Duration(seconds: 3), (){
      Get.off(()=>LandingPage(),
          transition: Transition.circularReveal, duration: Duration(milliseconds: 3700));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Color(0xFFE0D9CB)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText('Drink Me',
                    textStyle: TextStyle(
                      fontSize: 50.0, // Adjust font size as needed
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    )),
              ],
              repeatForever: true,
              isRepeatingAnimation: true,
              pause: Duration(seconds: 2),
            ),
            SizedBox(height: 20,),
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE0D9CB),
              ),
              child: Lottie.asset("assets/cocktailGuy.json"),
            ),
          ],
        ),
      ),
    );
  }
}
