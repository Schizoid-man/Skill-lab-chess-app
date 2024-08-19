
import 'dart:math';


import 'package:bishop/bishop.dart' as bishop;
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
      gameProvider.setSquaresState();
    }
    });
  }

  void _onMove(Move move) async {
    final gameProvider = context.read<GameProvider>();

    print("move: $move ");
    bool result = gameProvider.makeSquaresMove(move);
    if (result) {
      gameProvider.setSquaresState();
    }
    if (gameProvider.state.state == PlayState.theirTurn && !gameProvider.aiThinking) {
      gameProvider.setAiThinking(true);
      await Future.delayed(
          Duration(milliseconds: Random().nextInt(4750) + 250));
      gameProvider.game.makeRandomMove();
      gameProvider.setAiThinking(false);
      gameProvider.setSquaresState();
      
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
                    gameProvider.blacksTime.toString(),
                    style: TextStyle(fontSize: 16),
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
                  trailing: const Text("05:00",style: TextStyle(fontSize: 16),),
                ),
          
          
              
            ],
          );
          },
        ),
    );
  }
}