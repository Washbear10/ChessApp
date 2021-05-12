import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'game_setting.dart';


List<Game> globalGameList = [];

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}
Future<File> get _localFile async {
  final path = await _localPath;
  print("$path");
  return File('$path/games_file.txt');
}
Future<File> writeGame(Game game) async {
  final file = await _localFile;
  // Write the file.
  int gameDurationInSeconds = game.duration == null ? null : game.duration.inSeconds;

  print(game);
  return file.writeAsString('$gameDurationInSeconds;${game.maxMoves};${game.name}#', mode: FileMode.append);
}
Future<String> readGames() async {
  try {
    final file = await _localFile;
    // Read the file.
    String contents = await file.readAsString();
    return contents;
  } catch (e) {
    // If encountering an error, return 0.
    return "ERROR, Bruh...";
  }
}


Future<List<Game>> setGameListFromFile() async {
  String gamesString = await readGames();
  List<String> gamesStringList = gamesString.split("#");
  gamesStringList.removeLast();
  List<Game> fetchedGamesList = gamesStringList.map((e) => convertStringToGame(e)).toList();
  globalGameList = fetchedGamesList;

}

Game convertStringToGame(String gameString){ //Hilfsfunktion für setGameListFromFile

  List<String> gameSettingsStringList = gameString.split(";");
  String time = gameSettingsStringList[0];
  final moves = int.tryParse(gameSettingsStringList[1]);
  String name = gameSettingsStringList[2];
  final regexp = RegExp(r"([0-9]+)");
  int seconds = null;
  try {
    final match = regexp.firstMatch(time);
    String matchedString = match.group(0);
    seconds = int.tryParse(match.group(0));
  } on NoSuchMethodError catch(_) {
    print("Keine Zeit supplied, macht nix");
  }
  Duration duration;
  if (seconds == null) duration = null;
  else duration = Duration(seconds: seconds);
  Game game = Game(duration, moves, name);
  print(game);

  return game;
}


Future<void> deleteGamesWithList(List<Game> deletionList) async {
  String fileContent = await readGames();
  print("File content before: $fileContent");
  deletionList.forEach((element) {
    String time = element.duration != null ? element.duration.inSeconds.toString() : "null";
    String moves = element.maxMoves.toString();
    String name = element.name;
    RegExp exp = RegExp("$time;$moves;$name#");
    fileContent = fileContent.replaceAll(exp, "");
  });
  print("File content after: $fileContent");
  final file = await _localFile;
  // Write the new String as the new configuration.
  await file.writeAsString(fileContent, mode: FileMode.write);
  await setGameListFromFile();
}