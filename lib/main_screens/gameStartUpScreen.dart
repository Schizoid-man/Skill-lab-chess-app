import 'package:chess_app/constants.dart';
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
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child){
          return Padding(
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
                    groupValue: gameProvider.playerColor, 
                    onChanged: (value){
                    gameProvider.setPlayerColor(player: 0);
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
                        groupValue: gameProvider.playerColor, 
                        onChanged: (value){
                          
                          gameProvider.setPlayerColor(player: 1);                       
                         
                      
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
                   const Padding(
                    padding:  EdgeInsets.all(20.0),
                    child: Text(
                      'Game Difficult',
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
                      Row(
                       
                        children: [
                          
                          GameLevelRadioButton(
                            title: GameDifficulty.easy.name, 
                            value: GameDifficulty.easy, 
                            groupValue: gameProvider.gameDifficulty,
                            onChanged: (value){
                              gameProvider.setGameDifficulty(level: 1);
                            },),
                            const SizedBox(width:10,),
                            GameLevelRadioButton(
                            title: GameDifficulty.medium.name, 
                            value: GameDifficulty.medium, 
                            groupValue: gameProvider.gameDifficulty,
                            onChanged: (value){
                             gameProvider.setGameDifficulty(level: 2);
                            },),
                            const SizedBox(width:10,),
        
                            GameLevelRadioButton(
                            title: GameDifficulty.hard.name, 
                            value: GameDifficulty.hard, 
                            groupValue: gameProvider.gameDifficulty,
                            onChanged: (value){
                            gameProvider.setGameDifficulty(level: 3);
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
                playGame(gameProvider: gameProvider);
              },
              child: Text('Play'),
              ),
        
        
        
        
          ],
          ),
        );
        },
        
      )
      );
    
  }
  void playGame({required GameProvider gameProvider,}) async {
    // check if is custom time
    if(widget.isCustomTime){
      //check is all timers are greater than 0
      if(whiteTimeInMinutes <= 0 || blackTimeInMinutes <= 0){
        //show snackbar for 
        showSnackBar(context: context, content: 'Time cannot be 0');
        return;
      }
    

    // 1. show loading dialog
    gameProvider.setisLoading(value: true);

    // 2. save time and player colour for both players
    await gameProvider.setGameTime(
      newSavedWhitesTime: whiteTimeInMinutes.toString(), 
      newSavedBlacksTime: blackTimeInMinutes.toString(),
    )
    
    .whenComplete((){
      if(gameProvider.vsComputer){
        gameProvider.setisLoading(value: false);
    Navigator.pushNamed(context, Constants.gameScreen);
      }else{
        // search for players

      }
    });
      


    
   
  }
  else{
    // not custom time
    // check if its incremental time
    // get the value after the + sign
    final String incrementalTime = widget.gameTime.split('+')[1];

    //get the value before the + sign
    final String gameTime = widget.gameTime.split('+')[0];

    //check if incremental is equal to 0
    if(incrementalTime != '0'){
      // save the incremental value
      gameProvider.setIncrementalValue(value: int.parse(incrementalTime));


    }

    gameProvider.setisLoading(value: true);

     await gameProvider.setGameTime(
      newSavedWhitesTime: gameTime, 
      newSavedBlacksTime: gameTime,
    ).whenComplete((){
      if(gameProvider.vsComputer){
        gameProvider.setisLoading(value: false);
        Navigator.pushNamed(context, Constants.gameScreen);

      }else{
        // search for players

      }
    }
    );

    



  }
  }
}
