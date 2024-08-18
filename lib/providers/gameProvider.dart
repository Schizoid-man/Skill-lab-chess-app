

import 'package:bishop/bishop.dart';
import 'package:chess_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:squares/squares.dart';
 
class GameProvider extends ChangeNotifier{
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