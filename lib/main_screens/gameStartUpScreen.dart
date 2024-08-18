import 'package:chess_app/constants.dart';
import 'package:chess_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GameStartUpScreen extends StatefulWidget {
  const GameStartUpScreen({super.key, required this.isCustomTime, required this.gameTime});
final bool isCustomTime;
final String gameTime;
  @override
  State<GameStartUpScreen> createState() => _GameStartUpScreenState();
}

class _GameStartUpScreenState extends State<GameStartUpScreen> {
  PlayerColor playerColorGroup = PlayerColor.white;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text("Setup Game", style: TextStyle(color: Colors.amber),),
        leading: IconButton( icon: const Icon(Icons.arrow_back, color: Colors.amber,), onPressed: (){
          Navigator.pop(context);
        },),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //radio with list style ('_')
            SizedBox(
              width: MediaQuery.of(context).size.width *0.5,
              child: PlayerColorRadioButton(
                title: 'Play as ${PlayerColor.white.name}', 
                value: PlayerColor.white,
                 groupValue: playerColorGroup, 
                 onChanged: (value){
                  setState(() {
                    playerColorGroup = value!;

                  });
              
                 },),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: MediaQuery.of(context).size.width *0.5,
              child: PlayerColorRadioButton(
                title: 'Play as ${PlayerColor.black.name}', 
                value: PlayerColor.black,
                 groupValue: playerColorGroup, 
                 onChanged: (value){
                  setState(() {
                    playerColorGroup = value!;
                  });
              
                 },),
            )
          ],
        ),
      ),
    );
  }
}

