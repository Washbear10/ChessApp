
import 'package:flutter/foundation.dart';
import 'package:flutter_app/game_setting.dart';

class MyModel extends ChangeNotifier {
  int _button = 0;
  bool _hasStarted = false;
  Game _game = Game(Duration(seconds: 15), 20, "Default game");
  int get button => _button;
  bool get hasStarted => _hasStarted;
  Game get game => _game;
  void setPlayingNumber(int playingNumber){
    _button = playingNumber;
    notifyListeners();
  }
  void setStarted(){
    _hasStarted = true;
    notifyListeners();
  }
  void restart(){
    _hasStarted = false;
    _button = 0;
    notifyListeners();
  }
  void setGame(Game newGame){
    _game = newGame;
    notifyListeners();
  }
}