import 'package:flutter/material.dart';
import 'game_setting.dart';


class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  List<Game> savedGames = [
    Game(Duration(minutes: 29), 41, "Game 1"),
    Game(Duration(seconds: 29), 15, "Game 2"),
    Game(Duration(seconds: 50), 20, "Game 3"),
    Game(Duration(minutes: 2), 31, "Game 4"),
    Game(Duration(minutes: 29), 41, "Game 1"),
    Game(Duration(seconds: 29), 15, "Game 2"),
    Game(Duration(seconds: 50), 20, "Game 3"),
    Game(Duration(minutes: 2), 31, "Game 4"),
    Game(Duration(minutes: 29), 41, "Game 1"),
    Game(Duration(seconds: 29), 15, "Game 2"),
    Game(Duration(seconds: 50), 20, "Game 3"),
    Game(Duration(minutes: 2), 31, "Game 4"),
    Game(Duration(minutes: 29), 41, "Game 1"),
    Game(Duration(seconds: 29), 15, "Game 2"),
    Game(Duration(seconds: 50), 20, "Game 3"),
    Game(Duration(minutes: 2), 31, "Game 4"),
    Game(Duration(minutes: 29), 41, "Game 1"),
    Game(Duration(seconds: 29), 15, "Game 2"),
    Game(Duration(seconds: 50), 20, "Game 3"),
    Game(Duration(minutes: 2), 31, "Game 4"),
    Game(Duration(minutes: 29), 41, "Game 1"),
    Game(Duration(seconds: 29), 15, "Game 2"),
    Game(Duration(seconds: 50), 20, "Game 3"),
    Game(Duration(minutes: 2), 31, "Game 4"),
    Game(Duration(minutes: 29), 41, "Game 1"),
    Game(Duration(seconds: 29), 15, "Game 2"),
    Game(Duration(seconds: 50), 20, "Game 3"),
    Game(Duration(minutes: 2), 31, "Game 4"),
    Game(Duration(minutes: 29), 41, "Game 1"),
    Game(Duration(seconds: 29), 15, "Game 2"),
    Game(Duration(seconds: 50), 20, "Game 3"),
    Game(Duration(minutes: 2), 31, "Game 4"),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text("hallo test")
        ),
        body: Container(
          color: Colors.red,
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: savedGames.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(savedGames[index].name),
                onTap: () {
                  Navigator.pop(
                      context,
                      savedGames[index]
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
