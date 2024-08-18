import 'package:bishop/bishop.dart';
import 'package:chess_app/constants.dart';
import 'package:chess_app/providers/gameProvider.dart';
import 'package:chess_app/providers/gameProvider.dart';
import 'package:chess_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameStartUpScreen extends StatefulWidget {
  const GameStartUpScreen({super.key, required this.isCustomTime, required this.gameTime});
  final bool isCustomTime;
  final String gameTime;
  @override
  State<GameStartUpScreen> createState() => _GameStartUpScreenState();
}

class _GameStartUpScreenState extends State<GameStartUpScreen> {
  PlayerColor playerColorGroup = PlayerColor.white;
  GameDifficulty gameLevelGroup = GameDifficulty.easy;


  int whiteTimeInMinutes = 0;
  int blackTimeInMinutes = 0;
  @override
  Widget build(BuildContext context) {
    final gameProvider = context.read<GameProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Setup Game',style: TextStyle(color: Colors.amber),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber,),
          onPressed: (){
            Navigator.pop(context);
          },
      ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //radioListTile
              SizedBox(
                width: MediaQuery.of(context).size.width*0.5,
                child: PlayerColorRadioButton(
                  
                  title: 'Play as ${PlayerColor.white.name}', 
                  value: PlayerColor.white, 
                  groupValue: playerColorGroup, 
                  onChanged: (value){
                   setState(() {
                     playerColorGroup = value!;
                   });
                
                  },
                ),
              ),
              widget.isCustomTime 
                  ? BuildCustomTime(
                    time: whiteTimeInMinutes.toString(), 
                    onLeftArrowClicked: (){
                      setState(() {
                        whiteTimeInMinutes--;
                      });
                    }, onRigthArrowClicked: (){
                      setState(() {
                        whiteTimeInMinutes++;
                      });
                    })
             
               :Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.5,
                    color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                child: Center(
                  child: Text(
                    widget.gameTime,
                    textAlign: TextAlign.center,
                    style: 
                    const TextStyle(fontSize: 20,color: Colors.black),),
              )
                ),
               ),         
              
            ],
          ),
            const SizedBox(
                height: 10,
              ),
             
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width*0.5,
                    child: PlayerColorRadioButton(
                      
                      title: 'Play as ${PlayerColor.black.name}', 
                      value: PlayerColor.black, 
                      groupValue: playerColorGroup, 
                      onChanged: (value){
                        setState(() {
                           playerColorGroup = value!;
                          
                        });
                       
                       
                    
                      },
                    ),
                  ),
                  widget.isCustomTime 
                  ? BuildCustomTime(
                    time: blackTimeInMinutes.toString(), 
                    onLeftArrowClicked: (){
                      setState(() {
                        blackTimeInMinutes--;
                      });
                    }, onRigthArrowClicked: (){
                      setState(() {
                        blackTimeInMinutes++;
                      });
                    })
                  
                  
                  
                  
                  
                  
                  
                  
              
                 : Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.5,
                    color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                child: Center(
                  child: Text(
                    
                    widget.gameTime,
                    textAlign: TextAlign.center,
                    style: 
                    const TextStyle(fontSize: 20,color: Colors.black),),
              )
                ),
               ),  
              ],
            ),

            gameProvider.vsComputer ? Column(
              children:  [
                 Padding(
                  padding:  EdgeInsets.all(20.0),
                  child: Text(
                    'Game Difficult',
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
                    Row(
                     
                      children: [
                        
                        GameLevelRadioButton(
                          title: GameDifficulty.easy.name, 
                          value: GameDifficulty.easy, 
                          groupValue: gameLevelGroup,
                          onChanged: (value){
                            setState(() {
                              gameLevelGroup = value!;
                              
                            });
                          },),
                          const SizedBox(width:10,),
                          GameLevelRadioButton(
                          title: GameDifficulty.medium.name, 
                          value: GameDifficulty.medium, 
                          groupValue: gameLevelGroup,
                          onChanged: (value){
                            setState(() {
                              gameLevelGroup = value!;
                              
                            });
                          },),
                          const SizedBox(width:10,),

                          GameLevelRadioButton(
                          title: GameDifficulty.hard.name, 
                          value: GameDifficulty.hard, 
                          groupValue: gameLevelGroup,
                          onChanged: (value){
                            setState(() {
                              gameLevelGroup = value!;
                              
                            });
                          },),
                          

                      ],
                    ),  
                    
              ], 
            ) 
        : const SizedBox.shrink(),
        
const SizedBox(height:20,),
             ElevatedButton(
              onPressed: (){
              //navigate to the game screen
            },
            child: Text('Play'),
            ),




        ],
        ),
      )
      );
    
  }
}
