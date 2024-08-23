
import 'dart:async';


import 'package:bishop/bishop.dart' as bishop;
import 'package:chess_app/constants.dart';
import 'package:chess_app/helper/uciCommands.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';
import 'package:stockfish/stockfish.dart';
 
class GameProvider extends ChangeNotifier{

   late bishop.Game _game = bishop.Game(variant: bishop.Variant.standard());
  late SquaresState _state = SquaresState.initial(0);
  
  bool _aiThinking = false;
  bool _flipBoard = false;

  bool _vsComputer = false;
  bool _isLoading = false;
  bool _playWhitesTimer = true;
  bool _playBlacksTimer = true;
  int _gameLevel =1;
  int _incrementalValue = 0;
  int _player = Squares.white;
  Timer? _whitesTimer;
  Timer? _blacksTimer;
  int _whitesScore = 0;
  int _blacksScore = 0;
  PlayerColor _playerColor = PlayerColor.white;
  GameDifficulty _gameDifficulty = GameDifficulty.easy;

  Duration _whitesTime = Duration.zero;
  Duration _blacksTime = Duration.zero;

  // saved time
  Duration _savedWhitesTime = Duration.zero;
  Duration _savedBlacksTime = Duration.zero;

  bool get playWhitesTimer => _playWhitesTimer;
  bool get playBlacksTimer => _playBlacksTimer;
  
  int get whitesScore => _whitesScore;
  int get blacksScore => _blacksScore;

  Timer? get whitesTimer => _whitesTimer;
  Timer? get blacksTimer => _blacksTimer;

  bishop.Game get game => _game;
  SquaresState get state => _state;
  bool get aiThinking => _aiThinking;
  bool get flipBoard => _flipBoard;

  int get gameLevel=> _gameLevel;
  GameDifficulty get gameDifficulty => _gameDifficulty;
  int get player => _player;
  int get incrementalValue => _incrementalValue;
  PlayerColor get playerColor => _playerColor;
   
  Duration get whitesTime => _whitesTime;
  Duration get blacksTime => _blacksTime;

  Duration get savedWhitesTime=> _savedWhitesTime;
  Duration get savedBlacksTime=> _savedBlacksTime;

  //get method
  bool get vsComputer => _vsComputer;
  bool get isLoading => _isLoading;

  // set play whitesTimer
  Future<void> setPlayWhitesTimer({required bool value}) async{
    _playWhitesTimer = value;
    notifyListeners();

  }

  //set play blacksTimer
  Future<void> setPlayBlacksTimer({required bool value}) async{
    _playBlacksTimer = value;
    notifyListeners();

  }
  //get position fen
  getPositionFen(){
    return game.fen;
  }

  //reset game
  void resetGame ({required bool newGame}){
    if (newGame) {
      //check if the player was white in the previous game 
      //so that we can give them black in the new game
      if (_player == Squares.white) {
        _player = Squares.black;
      }else{
        _player = Squares.white;
      }
      notifyListeners();
    }
      //reset game
    _game = bishop.Game(variant: bishop.Variant.standard());
    _state = game.squaresState(_player);
    
  }
  // make square move
  bool makeSquaresMove(Move move){
        bool result = game.makeSquaresMove(move);
        notifyListeners();
        return result;
  }

  bool makeStringMove(String bestMove){
        bool result = game.makeMoveString(bestMove);
        notifyListeners();
        return result;
  }
  
  
  
  

  //set squarees state
  Future<void> setSquaresState() async{
    _state = game.squaresState(player);
    notifyListeners();
  }

  //make random move
  void makeRandomMove(){
    _game.makeRandomMove();
    notifyListeners();
  }
  void flipTheBoard(){
    _flipBoard = !_flipBoard;
    notifyListeners();
  }

  void setAiThinking(bool value){
    _aiThinking = value;
    notifyListeners();

  }

  //set incremental value
  void setIncrementalValue({required int value}){
    _incrementalValue = value;
    notifyListeners();
  }
  //set vs computer
  void setVsComputer({required bool value}){
    _vsComputer = value;
    notifyListeners();
  }
  void setisLoading({required bool value}){
    _isLoading = value;
    notifyListeners();
  }


  // set game time
  Future<void> setGameTime({
    required String newSavedWhitesTime, 
    required String newSavedBlacksTime}) async{
      // save the times 
      _savedWhitesTime = Duration(minutes: int.parse(newSavedWhitesTime));
      _savedBlacksTime = Duration(minutes: int.parse(newSavedBlacksTime));
      notifyListeners();
      // set times
      setWhitesTime(_savedWhitesTime);
      setBlacksTime(_savedBlacksTime);


    }

    void setWhitesTime(Duration time){
      _whitesTime = time;
      notifyListeners();
      


    }

    void setBlacksTime(Duration time){
      _blacksTime = time;
      notifyListeners();
    }

    // set player color
    void setPlayerColor({required int player}){
      _player = player;
      _playerColor =
       player == Squares.white ? PlayerColor.white: PlayerColor.black;
       notifyListeners();
    }

    // set difficulty
    void setGameDifficulty({required int level}){

      _gameLevel = level;
      _gameDifficulty  = level == 1? 
      GameDifficulty.easy:
      level ==2 ? 
      GameDifficulty.medium: GameDifficulty.hard; 
      notifyListeners();
    }

    //pause whites timer
    void pauseWhitesTimer(){
      if(_whitesTimer != null){
        _whitesTime+=Duration(seconds: _incrementalValue);
        _whitesTimer!.cancel();
        notifyListeners();
      }    
    }
    void pauseBlacksTimer(){
      if(_blacksTimer != null){
        _blacksTime+=Duration(seconds: _incrementalValue);
        _blacksTimer!.cancel();
        notifyListeners();
      }    
    }
    // start blacks timer 
    void startBlacksTimer({required BuildContext context, required Stockfish stockfish, required Function onNewGame}) {
  _blacksTimer = Timer.periodic(const Duration(seconds: 1), (_) {
    _blacksTime = _blacksTime - const Duration(seconds: 1);
    notifyListeners();

    if (_blacksTime <= Duration.zero) {
      _blacksTimer!.cancel();
      notifyListeners();
      if (context.mounted) {
        gameOverDialog(
          context: context,
          stockfish: stockfish,
          timeOut: true,
          whiteWon: true,
          onNewGame: onNewGame,
        );
      }
    }
  });

  // Start Stockfish move with time control
  makeStockfishMove(stockfish);
}

void makeStockfishMove(Stockfish stockfish) {
  int thinkingTimeMillis = _blacksTime.inMilliseconds > 2000 ? 2000 : _blacksTime.inMilliseconds;
  stockfish.stdin = 'go movetime $thinkingTimeMillis';

  // Optionally, handle asynchronous response from Stockfish here
  stockfish.stdout.listen((line) {
    if (line.startsWith('bestmove')) {
      String bestMove = line.split(' ')[1];
      // Make the move in the game
      makeStringMove(bestMove);
      // Update timer or any other game state
    }
  });
}


    //starts black timer
    void startWhitesTimer({required BuildContext context,Stockfish? stockfish, required Function onNewGame}){
      _whitesTimer = Timer.periodic(const Duration(seconds: 1),(_){
        _whitesTime = _whitesTime - const Duration(seconds: 1);
        notifyListeners();

        if (_whitesTime <= Duration.zero){
        
          //whites timeout - white has lost the game 
          _whitesTimer!.cancel();
          notifyListeners();
          //show game over dialog
          if(context.mounted){
            gameOverDialog(
              context: context, 
              stockfish: stockfish,
              timeOut: true, 
              whiteWon: false, 
              onNewGame: onNewGame,
              );
          }
        }
      });
  
    }

    //game over listener
    void gameOverListener({required BuildContext context, Stockfish? stockfish,required Function onNewGame,}){
      if (game.gameOver){
      
        //pause the timers
        pauseWhitesTimer();
        pauseBlacksTimer();

        //show game over dialog
          if(context.mounted){
            gameOverDialog(
              context: context,
              stockfish: stockfish,
              timeOut: false, 
              whiteWon: false, 
              onNewGame: onNewGame,
              );
          }
      }
    }
  //game over dialog 
  void gameOverDialog({
  required BuildContext context,
  Stockfish? stockfish,
  required bool timeOut,
  required bool whiteWon,
  required Function onNewGame
}) {
  // Stop stockfish engine
  if (stockfish != null) {
    stockfish.stdin = UCICommands.stop;
  }

  String resultsToShow = "";
  int whitesScoresToShow = _whitesScore;
  int blacksScoresToShow = _blacksScore;

  if (timeOut) {
    resultsToShow = whiteWon ? "White won on Time" : "Black won on Time";
    if (whiteWon) {
      whitesScoresToShow += 1;
    } else {
      blacksScoresToShow += 1;
    }
  } else {
    resultsToShow = game.result!.readable;

    if (game.drawn) {
      List<String> results = game.result!.scoreString.split('_');
      if (results.length == 2) {
        String whitesResults = results[0];
        String blacksResults = results[1];

        whitesScoresToShow += safeParse(whitesResults);
        blacksScoresToShow += safeParse(blacksResults);
      }
    } else if (game.winner == 0) {
      String whitesResults = game.result!.scoreString.split('_').first;
      whitesScoresToShow += safeParse(whitesResults);
    } else if (game.winner == 1) {
      String blacksResults = game.result!.scoreString.split('_').last;
      blacksScoresToShow += safeParse(blacksResults);
    } else if (game.stalemate) {
      // Handle stalemate scenario
    }
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(
        "Game Over \n Well played!",
        textAlign: TextAlign.center,
      ),
      content: Text(
        resultsToShow,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
              context,
              Constants.homeScreen,
              (route) => false,
            );
          },
          child: const Text(
            "Return to Home Screen",
            style: TextStyle(color: Colors.red),
          ),
        ),
        
      ],
    ),
  );
}

// Define safeParse method
int safeParse(String value) {
  try {
    return int.parse(value);
  } catch (e) {
    // Handle parsing error, e.g., log it or return a default value
    return 0; // Default value if parsing fails
  }
}

    // String getResultsToShow({required bool whiteWon}){
    //   if (whiteWon){
    //     return "White won on Time";
    //   }else{
    //     return "Black won on Time";
    //   }
    // }
}