import 'package:flutter/material.dart';
import 'game_setting.dart';


class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  List<Game> savedGames = [
    Game(Duration(minutes: 29), 41, "Game 1 - 29 minutes and 41 moves"),
    Game(null, 15, "Game 2 - only 15 moves"),
    Game(Duration(minutes: 1), null, "Game 3 - 1 minutes and moves set to null"),

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
