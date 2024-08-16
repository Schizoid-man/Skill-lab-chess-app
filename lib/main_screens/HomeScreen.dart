
import 'dart:math';
import 'dart:ui';

import 'package:bishop/bishop.dart' as bishop;
import 'package:chess_app/service/assetsManager.dart';
import 'package:flutter/material.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late bishop.Game game;
  late SquaresState state;
  int player = Squares.white;
  bool aiThinking = false;
  bool flipBoard = false;

  @override
  void initState() {
    _resetGame(false);
    super.initState();
  }

  void _resetGame([bool ss = true]) {
    game = bishop.Game(variant: bishop.Variant.standard());
    state = game.squaresState(player);
    if (ss) setState(() {});
  }

  void _flipBoard() => setState(() => flipBoard = !flipBoard);

  void _onMove(Move move) async {
    bool result = game.makeSquaresMove(move);
    if (result) {
      setState(() => state = game.squaresState(player));
    }
    if (state.state == PlayState.theirTurn && !aiThinking) {
      setState(() => aiThinking = true);
      await Future.delayed(
          Duration(milliseconds: Random().nextInt(4750) + 250));
      game.makeRandomMove();
      setState(() {
        aiThinking = false;
        state = game.squaresState(player);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: _resetGame,
              icon: const Text('New Game'),
            ),
            IconButton(
              onPressed: _flipBoard,
              icon: const Icon(Icons.rotate_left, color: Colors.amberAccent,),
            ),
        ],
        ),
        body: Column(
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
                trailing: const Text("05:00"),
              ),
            
        
        
        
        
        
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: BoardController(
                state: flipBoard ? state.board.flipped() : state.board,
                playState: state.state,
                pieceSet: PieceSet.merida(),
                theme: BoardTheme.brown,
                moves: state.moves,
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
                trailing: const Text("05:00"),
              ),
        
        
            
          ],
        ),
    );
  }
}