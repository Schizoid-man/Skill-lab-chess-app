

import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier{
  bool _vsComputer = false;
  bool _isLoading = false;
  //get method
  bool get vsComputer => _vsComputer;
  bool get isLoading => _isLoading;
  //set vs computer
  void setVsComputer({required bool value}){
    _vsComputer = value;
    notifyListeners();
  }
  void setisLoading({required bool value}){
    _isLoading = value;
    notifyListeners();
  }
}