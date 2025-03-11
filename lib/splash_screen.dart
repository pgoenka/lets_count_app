import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'main_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      splash: 
          Center(
            child: Lottie.asset('assets/Animation - 1741683870680.json'),
          ),
        
      nextScreen: const MainScreen(),
      splashTransition: SplashTransition.fadeTransition,
      // pageTransitionType: PageTransitionType.scale,
      backgroundColor: Colors.white,
      splashIconSize: 200,
    );
  }
  
  

}