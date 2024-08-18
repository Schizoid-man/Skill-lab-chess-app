import 'package:chess_app/constants.dart';
import 'package:chess_app/main_screens/GameScreen.dart';
import 'package:chess_app/main_screens/HomeScreen.dart';
import 'package:chess_app/main_screens/SettingsScreen.dart';
import 'package:chess_app/main_screens/aboutScreen.dart';
import 'package:chess_app/main_screens/gameStartUpScreen.dart';
import 'package:chess_app/main_screens/gameTimeScreen.dart';
import 'package:chess_app/providers/gameProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers:[ChangeNotifierProvider(create: (_) => GameProvider())
    ], 
    child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const HomeScreen(),
      initialRoute: Constants.homeScreen,
      routes: {
        Constants.homeScreen: (context) => const HomeScreen(),
        Constants.gameScreen: (context) => const GameScreen(),
        Constants.settingScreen: (context) => const SettingsScreen(),
        Constants.aboutScreen: (context) => const AboutScreen(),
        
        Constants.gameTimeScreen: (context) => const GameTimeScreen(),
      },
    );
  }
}
