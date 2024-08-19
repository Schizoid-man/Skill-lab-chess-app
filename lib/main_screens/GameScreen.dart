
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
    super.initState();
  }


  void _onMove(Move move) async {
    print("move: $move ");
    // bool result = game.makeSquaresMove(move);
    // if (result) {
    //   setState(() => state = game.squaresState(player));
    // }
    // if (state.state == PlayState.theirTurn && !aiThinking) {
    //   setState(() => aiThinking = true);
    //   await Future.delayed(
    //       Duration(milliseconds: Random().nextInt(4750) + 250));
    //   game.makeRandomMove();
    //   setState(() {
    //     aiThinking = false;
    //     state = game.squaresState(player);
    //   });
    // }
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