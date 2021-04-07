import 'package:flutter_app/constants.dart';
import 'package:flutter_app/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/model.dart';
import 'package:flutter/material.dart';
import 'game_setting.dart';


class MyPauseButton extends StatefulWidget {
  const MyPauseButton({
    Key key,
  }) : super(key: key);

  @override
  _MyPauseButtonState createState() => _MyPauseButtonState();
}

class _MyPauseButtonState extends State<MyPauseButton> {
  bool playing;
  int mostRecentPlayer;
  @override
  Widget build(BuildContext context) {
    var myModelInfo = context.watch<MyModel>();
    //0 means paused => show play button; 1 means playing => show pause button
    playing = myModelInfo.button!=0;
    //everytime it rebuilds from watching the TimeButtons refresh the Model, save last recent player
    //that was playing
    if (myModelInfo.button == 1) mostRecentPlayer = 1;
    else if (myModelInfo.button == 2) mostRecentPlayer = 2;

    return IconButton(
        icon: Icon(
            playing ? Icons.pause : Icons.play_arrow
        ),
        color: Colors.amber,
        disabledColor: Colors.amber.withOpacity(0.3),
        iconSize: 50,
        onPressed: myModelInfo.hasStarted ? //  //if game has started, let button behave how implemented, else disable it

            (){
              // myModelInfo.setPausedButtonNumber(0);
              if (myModelInfo.hasStarted)
                playing ? myModelInfo.setPlayingNumber(0) : myModelInfo.setPlayingNumber(mostRecentPlayer);
            }
            :   // else if game not yet started return null as callback --> flutter regards button as disabled
            null
    );
  }
}







class MyRestartButton extends StatefulWidget {
  @override
  _MyRestartButtonState createState() => _MyRestartButtonState();
}

class _MyRestartButtonState extends State<MyRestartButton> {
  int mostRecentPlayer = 0;
  @override
  Widget build(BuildContext context) {
    var myModelInfo = context.watch<MyModel>();
    //leave check for myModelInfo.button == 0 on purpose, so that if it gets updated to 0, you
    //keep the information of last player to play on 1 or 2, not on 0.
    if (myModelInfo.button == 1) mostRecentPlayer = 1;
    else if (myModelInfo.button == 2) mostRecentPlayer = 2;
    return IconButton(
        icon: Icon(
            Icons.restore,
        ),
        disabledColor: Colors.amber.withOpacity(0.3),
        iconSize: 50,
        color: Colors.amber,
        onPressed: myModelInfo.hasStarted ? // same ternary logic as with StartButton, look it up
            (){
                bool wasPaused = myModelInfo.button == 0; // remember if it was already paused before button clicked
                myModelInfo.setPlayingNumber(0); //pause the game
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Color(0XFFFF4B4B4B),
                        titleTextStyle: AlertTitleStyle,
                        title: Text("Restart Time?"),
                        actions: [
                          TextButton( //Button to restart the time
                              child: Text("Restart", style: TextStyle(fontSize: 30),),
                              style: TextButton.styleFrom(
                                primary: Colors.amber,
                                enableFeedback: true,
                              ),
                              onPressed: () {
                                mostRecentPlayer = 0;  //might not be needed, check later
                                myModelInfo.restart();
                                Navigator.pop(context);
                              }
                          ),
                          TextButton( //Button to keep playing, not restart time
                              child: Text("Discard", style: TextStyle(fontSize: 30)),
                              style: TextButton.styleFrom(
                                primary: Colors.amber,
                                enableFeedback: true,
                              ),
                              onPressed: () {
                                if (!wasPaused) myModelInfo.setPlayingNumber(mostRecentPlayer); // continue with last player if the game was not paused.
                                                                                                //otherwise just leave it paused (=> myModelInfo.button = 0)
                                Navigator.pop(context);
                              }
                          )
                        ],
                      );
                    }
                );
              }
              :
              null
    );
  }
}







class MySettingsButton extends StatefulWidget {
  @override
  _MySettingsButtonState createState() => _MySettingsButtonState();
}

class _MySettingsButtonState extends State<MySettingsButton> {
  int mostRecentPlayer;

  @override
  Widget build(BuildContext context) {
    var myModelInfo = context.watch<MyModel>();

    return IconButton(
        icon: Icon(
            Icons.settings
        ),
        iconSize: 50,
        color: Colors.amber,
        onPressed: () async {
          myModelInfo.setPlayingNumber(0);
          Game returnedGame = await Navigator.push(context, MaterialPageRoute(builder: (context) { return SettingsScreen(); } ));
          if (returnedGame != null){
            print("nich null, game: ${returnedGame.name}");
            myModelInfo.restart();
            myModelInfo.setGame(returnedGame);
          } else print("null game");
        }
    );

  }
}
