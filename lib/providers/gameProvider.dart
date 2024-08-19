
import 'dart:async';
import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:bishop/bishop.dart' as bishop;
import 'package:chess_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';
 
class GameProvider extends ChangeNotifier{

   late bishop.Game _game = bishop.Game(variant: bishop.Variant.standard());
  late SquaresState _state = SquaresState.initial(0);
  
  bool _aiThinking = false;
  bool _flipBoard = false;

  bool _vsComputer = false;
  bool _isLoading = false;
  int _gameLevel =1;
  int _incrementalValue = 0;
  int _player = Squares.white;
  Timer? _whitesTimer;
  Timer? _blacksTimer;
  PlayerColor _playerColor = PlayerColor.white;
  GameDifficulty _gameDifficulty = GameDifficulty.easy;

  Duration _whitesTime = Duration.zero;
  Duration _blacksTime = Duration.zero;

  // saved time
  Duration _savedWhitesTime = Duration.zero;
  Duration _savedBlacksTime = Duration.zero;

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
    void startBlacksTimer({required BuildContext context, required Function onNewGame}){
      _blacksTimer = Timer.periodic(const Duration(seconds: 1),(_){
        _blacksTime = _blacksTime - const Duration(seconds: 1);
        notifyListeners();

        if (_blacksTime <= Duration.zero){
          //blacks timeout - black has lost the game 
          _blacksTimer!.cancel();
          notifyListeners();
          //todo: show game over dialog
          print("Black has lost");
        }
      });
  
    }
    void startWhitesTimer({required BuildContext context, required Function onNewGame}){
      _whitesTimer = Timer.periodic(const Duration(seconds: 1),(_){
        _whitesTime = _blacksTime - const Duration(seconds: 1);
        notifyListeners();

        if (_whitesTime <= Duration.zero){
          //whites timeout - white has lost the game 
          _whitesTimer!.cancel();
          notifyListeners();
          //todo: show game over dialog
          print("White has lost");
        }
      });
  
    }

}