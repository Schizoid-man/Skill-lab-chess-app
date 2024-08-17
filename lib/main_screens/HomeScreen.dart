import 'package:bishop/bishop.dart';
import 'package:chess_app/helper/helperMethods.dart';
import 'package:chess_app/main.dart';
import 'package:chess_app/main_screens/SettingsScreen.dart';
import 'package:chess_app/main_screens/aboutScreen.dart';
import 'package:chess_app/main_screens/gameTimeScreen.dart';
import 'package:chess_app/providers/gameProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.read<GameProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Flutter Chess', style: TextStyle(color: Colors.amber),),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            children: [
              buildGameType(
                label: 'vs Computer', 
                icon: Icons.computer, 
                onTap: (){
                  gameProvider.setVsComputer(value: true);
                  // navigate to gametimescreen
                  Navigator.push(context,
                   MaterialPageRoute(builder: (context)=> const GameTimeScreen(),),);
                }),
              buildGameType(
                label: 'vs Player', 
                icon: Icons.person, 
                onTap: (){
                  gameProvider.setVsComputer(value: false);
                  // navigate to gametimescreen
                  Navigator.push(context,
                   MaterialPageRoute(builder: (context)=> const GameTimeScreen(),),);
                }),
                buildGameType(
                label: 'Settings', 
                icon: Icons.settings, 
                onTap: (){
                  //navigate to settings screen
                  Navigator.push(context,
                   MaterialPageRoute(builder: (context)=> const SettingsScreen(),),);
                }),
                buildGameType(
                label: 'About', 
                icon: Icons.info, 
                onTap: (){
                  //navigate to about screen
                  Navigator.push(context,
                   MaterialPageRoute(builder: (context)=> const AboutScreen(),),);
                }),
              
            ],),
        )
        
    );
  }
}

