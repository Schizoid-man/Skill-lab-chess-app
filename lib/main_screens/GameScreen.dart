
import 'dart:math';

import 'package:bishop/bishop.dart' as bishop;
import 'package:chess_app/helper/helperMethods.dart';
import 'package:chess_app/providers/gameProvider.dart';
import 'package:chess_app/service/assetsManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squares/squares.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
 
  @override
  void initState() {
    final gameProvider = context.read<GameProvider>();

    gameProvider.resetGame(newGame: false);
    if(mounted){
      letOtherPlayerPlayFirst();
    }
    super.initState();
  }

  void letOtherPlayerPlayFirst(){
    //wait for widget to rebuild 
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      final gameProvider = context.read<GameProvider>();
      if (gameProvider.state.state == PlayState.theirTurn && !gameProvider.aiThinking) {
      gameProvider.setAiThinking(true);
      await Future.delayed(
          Duration(milliseconds: Random().nextInt(4750) + 250));
      gameProvider.game.makeRandomMove();
      gameProvider.setAiThinking(false);
      gameProvider.setSquaresState().whenComplete((){
        //pause timer for WHITE
        gameProvider.pauseWhitesTimer();
        startTimer(
          isWhitesTimer: false, 
          onNewGame: (){},
          );
      });}
    });
  }

  void _onMove(Move move) async {
    final gameProvider = context.read<GameProvider>();

    print("move: $move ");
    bool result = gameProvider.makeSquaresMove(move);
    if (result) {
      gameProvider.setSquaresState().whenComplete((){

        if(gameProvider.player== Squares.white){
          //pause timer for white
          gameProvider.pauseWhitesTimer();
        startTimer(
          isWhitesTimer: false, 
          onNewGame: (){},
          );
        } else{
          //pause timer for black
          gameProvider.pauseBlacksTimer();
        startTimer(
          isWhitesTimer: true, 
          onNewGame: (){},
          );

        }
        
        
      });
      
    }
    if (gameProvider.state.state == PlayState.theirTurn && !gameProvider.aiThinking) {
      gameProvider.setAiThinking(true);
      await Future.delayed(
          Duration(milliseconds: Random().nextInt(4750) + 250));
      gameProvider.game.makeRandomMove();
      gameProvider.setAiThinking(false);
      gameProvider.setSquaresState().whenComplete((){
        if(gameProvider.player== Squares.white){

        //pause timer for black
        gameProvider.pauseBlacksTimer();
        startTimer(
          isWhitesTimer: true, 
          onNewGame: (){},
          );
        }else{
          //pause timer for white
        gameProvider.pauseWhitesTimer();
        startTimer(
          isWhitesTimer: false, 
          onNewGame: (){},
          );

        }
      });
      
    }

    //listen if it is game over
    checkGameOverListener();
  }
  
  void checkGameOverListener(){
    final gameProvider = context.read<GameProvider>();
    gameProvider.gameOverListener(context: context, onNewGame: (){
      // start new game
    },);

  }
  void startTimer({required bool isWhitesTimer, required Function onNewGame}){
    final gameProvider = context.read<GameProvider>();
    if(isWhitesTimer){
      // start timer for white
      gameProvider.startWhitesTimer(context: context, onNewGame: onNewGame);
    }else{
      //start timer for black
      gameProvider.startBlacksTimer(context: context, onNewGame: onNewGame);
    }
  }
  @override
  Widget build(BuildContext context) {
    final gameProvider = context.read<GameProvider>();

    print('WhitesTime:${gameProvider.whitesTime}');
     print('BlackssTime:${gameProvider.blacksTime}');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,), 
          onPressed: () {
            //TODO: show dialog if true
          Navigator.pop(context);
        },),
        backgroundColor: Colors.black87,
        title: Text('Flutter Chess', style: TextStyle(color: Colors.amber),),
        actions: [
          
            IconButton(
              onPressed: (){
                
                gameProvider.resetGame(newGame: false);
              },
              icon: const Icon(Icons.start, color: Colors.amber,)
            ),
            IconButton(
              onPressed: (){
                gameProvider.flipTheBoard();
              },
              icon: const Icon(Icons.rotate_left, color: Colors.amberAccent,),
            ),
        ],
        ),
        body: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {

            String whitesTimer = getTimerToDisplay(gameProvider: gameProvider, isUser: true,);
            String blacksTimer = getTimerToDisplay(gameProvider: gameProvider, isUser: false,);

            return Column(
            //mainAxisAlignment: MainAxisAlignment.center, //add this later
            children: [
              //Oppponent information
              ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(AssetsManager.stockfishIcon),
                  ),
                  title: const Text("Stockfish"),
                  subtitle: const Text("Rating: jalgaara"),
                  trailing:  Text(
                    blacksTimer,
                    style: const TextStyle(fontSize: 16),
                    ),
                ),
              
          
          
          
          
          
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: BoardController(
                  state: gameProvider.flipBoard ? gameProvider.state.board.flipped() : gameProvider.state.board,
                  playState: gameProvider.state.state,
                  pieceSet: PieceSet.merida(),
                  theme: BoardTheme.brown,
                  moves: gameProvider.state.moves,
                  onMove: _onMove,
                  onPremove: _onMove,
                  markerTheme: MarkerTheme(
                    empty: MarkerTheme.dot,
                    piece: MarkerTheme.corners(),
                  ),
                  promotionBehaviour: PromotionBehaviour.autoPremove,
                ),
              ),
          
              //Player information
              ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(AssetsManager.userIcon),
                  ),
                  title: const Text("Edging Lord"),
                  subtitle: const Text("Rating: 5000"),
                  trailing:  Text(whitesTimer,style: const TextStyle(fontSize: 16),),
                ),
          
          
              
            ],
          );
          },
        ),
    );
  }
}