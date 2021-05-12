
import 'package:flutter/foundation.dart';

import 'game_setting.dart';

class DeletionModel extends ChangeNotifier {

  bool _deleteMode = false;
  bool get deleteMode => _deleteMode;

  List _deletionList = <Game>[];
  List get deletionList => _deletionList;

  void activateDeleteMode(){
    _deleteMode = true;
    _deletionList = <Game>[];
    notifyListeners();
  }
  void deActivateDeleteMode(){
    _deleteMode = false;
    notifyListeners();
  }
  void addGameToDeletionList (Game game){
    _deletionList.add(game);
    print("adding for deletion: $game");
    notifyListeners();
  }
  void removeGameFromDeletionList (Game game){
    _deletionList.remove(game);
    print("removing  from deletion: $game");
    notifyListeners();
  }




}