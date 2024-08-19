import 'package:chess_app/constants.dart';
import 'package:chess_app/helper/helperMethods.dart';
import 'package:chess_app/main_screens/gameStartupScreen.dart';
import 'package:chess_app/providers/gameProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameTimeScreen extends StatefulWidget {
  const GameTimeScreen({super.key});

  @override
  State<GameTimeScreen> createState() => _GameTimeScreenState();
}

class _GameTimeScreenState extends State<GameTimeScreen> {
  @override
  Widget build(BuildContext context) {
    final gameProvider = context.read<GameProvider>();
    print("VS VALUE: {$gameProvider.vsComputer}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Choose Game mode', 
        style: TextStyle(color: Colors.amber),),
        leading: IconButton(
          onPressed: (){ 
            Navigator.pop(context);
            }, 
          icon: const Icon(Icons.arrow_back, color: Colors.amberAccent,)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.5),
            itemCount: gameTimes.length, 
          itemBuilder: (context, index){
            //get the first word of the gametime
            final String label = gameTimes[index].split(' ')[0];
        
            //get the second half of the gametime
            final String gameTime = gameTimes[index].split(' ')[1];
        
            return buildGameType(
              label: label,
              gameTime: gameTime,
              onTap: (){
                if (label == Constants.custom){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => GameStartUpScreen(
                    isCustomTime:true,
                    gameTime: gameTime,
                  ),),);
                }
                else{
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => GameStartUpScreen(
                        isCustomTime:false,
                        gameTime: gameTime,
                      )));
                }
              
            });
          }),
      )
    );
  }
}