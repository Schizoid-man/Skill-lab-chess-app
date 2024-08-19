
import 'package:bishop/bishop.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:chess_app/constants.dart';
import 'package:flutter/material.dart';
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
  PlayerColor _playerColor = PlayerColor.white;
  GameDifficulty _gameDifficulty = GameDifficulty.easy;
  Duration _whitesTime = Duration.zero;
  Duration _blacksTime = Duration.zero;

  // saved time
  Duration _savedWhitesTime = Duration.zero;
  Duration _savedBlacksTime = Duration.zero;

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
}