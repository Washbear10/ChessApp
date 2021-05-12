import 'globals.dart' as global;
import 'package:flutter/foundation.dart';
import 'package:flutter_app/game_setting.dart';

class ConfigurationModel extends ChangeNotifier {

  List _gameList = global.globalGameList;
  List get gameList => _gameList;


  Future<void> addGameToList(Game newGame) async {
    await global.writeGame(newGame);
    await global.setGameListFromFile();
    _gameList = global.globalGameList;
    notifyListeners();
  }

  Future<void> removeGameFromList(Game oldGame){
    _gameList.remove(oldGame);
    notifyListeners();
  }

  Future<void> removeGamesWithDeletionList(List deletionList) async {
    await global.deleteGamesWithList(deletionList);
    _gameList = global.globalGameList;
    notifyListeners();
  }

}