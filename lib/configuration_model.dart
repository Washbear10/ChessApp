
import 'package:flutter/foundation.dart';
import 'package:flutter_app/game_setting.dart';
import 'package:flutter_app/settings_screen.dart';

class ConfigurationModel extends ChangeNotifier {
  List _gameList = [
    Game(Duration(minutes: 29), 41, "Ok Test this list comes from the model, not from state"),
    Game(null, 15, "Gameves"),
    Game(Duration(minutes: 1), null, "Gamfll"),
  ];

  List get gameList => _gameList;


  void addGameToList(Game newGame){
    _gameList.add(newGame);
    notifyListeners();
  }

  void removeGameFromList(Game oldGame){
    _gameList.remove(oldGame);
    notifyListeners();
  }
}