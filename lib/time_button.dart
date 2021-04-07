import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/game_setting.dart';
import 'package:vibration/vibration.dart';
import 'constants.dart';
import 'package:rainbow_color/rainbow_color.dart';
import 'package:provider/provider.dart';
import 'model.dart';
import 'sounds.dart';


class TimeButton extends StatefulWidget {
  @override
  _TimeButtonState createState() => _TimeButtonState();
  final int buttonNumber;
  Game game = Game(Duration(seconds: 15), 20, "Default game");
  TimeButton({Key key, this.buttonNumber}) : super(key: key);
}

class _TimeButtonState extends State<TimeButton> {
  //properties regarding time
  String remainingTime;
  Timer timer;
  bool run;
  Duration remainingDuration;
  //properties regarding moves
  int remainingMoves;
  //properties regarding coloring
  Color currentColor;
  Timer colorTimer;

  void stopRun(){
    run = false;
  }
  void startRun(){
    run = true;
    currentColor = currentColor.withOpacity(1);
  }

  void handleMoves(){
    setState(() {
      remainingMoves--;
      // if game has no time limit, only move limit, then set color according to moves. Else the timer will handle it.
      if (widget.game.duration == null) currentColor = calculateColor(widget.game.maxMoves, remainingMoves);
    });
  }

  void resetGame(){ //this method sets the state attributes according to the new game
    setState(() {
      remainingDuration = widget.game.duration;
      remainingTime = widget.game.duration != null ? DurationToString(remainingDuration) : null;   //if game has no duration, remainingTime is not needed
      currentColor = Color(0xff1fff00).withOpacity(0.3); //at the beginning always green
      remainingMoves = widget.game.maxMoves;  // might be null, might not be. doesnt matter for now
    });
  }

  // Might be needed later, but for now just use black and white. Seems to be overkill otherwise
  Color getComplementaryColor(){
    int complementaryRed = 255 - currentColor.red;
    int complementaryGreen = 255 - currentColor.green;
    int complementaryBlue = 255 - currentColor.blue;
    return Color.fromRGBO(complementaryRed, complementaryGreen, complementaryBlue, 1);
  }


  @override
  void initState() {
    super.initState();

    run = false;
    remainingDuration = widget.game.duration;
    remainingTime = DurationToString(remainingDuration);
    remainingMoves = widget.game.maxMoves;
    currentColor = Color(0xff1fff00).withOpacity(0.3); //at the beginning always green

    //timer gets initialized.
    colorTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (run && widget.game.duration != null){ //update time and color every 100ms if its your turn and (naturally) the game has a time limit
        setState(() {
          remainingDuration = remainingDuration - Duration(milliseconds: 100);
          remainingTime = DurationToString(remainingDuration);
          currentColor = calculateColor(widget.game.duration.inMilliseconds, remainingDuration.inMilliseconds);
        });
        if (remainingDuration == Duration.zero){ // end of game, one player has no time left
          Vibration.vibrate(duration: 1000);
          playSound();
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var myModelInfo = context.watch<MyModel>();
    if(myModelInfo.button == widget.buttonNumber) startRun();
    else {
      stopRun();
      currentColor = currentColor.withOpacity(0.3);
      if(myModelInfo.game != widget.game) { // if Game mode has changed due to user picking new game in pushed screen:
        widget.game = myModelInfo.game;
      }
      if (!myModelInfo.hasStarted && (remainingDuration != widget.game.duration || remainingMoves != widget.game.maxMoves)){ // if game was just restarted / new game picked. Second check is to avoid recursive rebuilding
        resetGame();
      }
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      height: size.height * 0.35,
      width: size.width * 0.9,
      decoration: BoxDecoration(
          color: currentColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40))
      ),
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          enableFeedback: true,
        ),
        child: TimeAndMoves(
          remainingDuration: remainingDuration,
          remainingTime: remainingTime,
          remainingMoves: remainingMoves,
          iconColor: run ? Colors.black : Colors.white,
        ),
        onPressed: () {
          if(run) {
            run = false;
            //if you are player 1, set the playing button to button 2 => it's their turn;
            // if you are player 2, set it to 1
            myModelInfo.setPlayingNumber(widget.buttonNumber == 1 ? 2 : 1);
            if(remainingMoves != null){  //additional check, if game mode includes moves, not (only) time
              handleMoves();
            }
          }
          //first move:
          else if(!myModelInfo.hasStarted) {
            //same here
            myModelInfo.setPlayingNumber(widget.buttonNumber == 1 ? 2 : 1);
            //start the game
            myModelInfo.setStarted();
            //additional check for moves:
            if (widget.game.maxMoves != null) handleMoves();
          }
          else if(myModelInfo.hasStarted) {
            //Do nothing, because this is two situations:
            // 1. The game has started and it's opponents turn ==> do nothing
            // 2. The game has started and it's paused ==> game is supposed to resume only per playbutton which remembers
            //    who's turn it was
          }
        },

      ),
    );
  }
}







//Widget for Displaying Icons and Text for Time and/or Moves Left
class TimeAndMoves extends StatelessWidget {
  const TimeAndMoves({
    Key key,
    @required this.remainingMoves, this.iconColor, this.remainingTime, this.remainingDuration,
  }) : super(key: key);

  final Duration remainingDuration;
  final String remainingTime;
  final int remainingMoves;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    if (remainingDuration != null && remainingMoves != null) {
      return RichText(
          text: TextSpan(
              style: timeStyle,
              children: [
                WidgetSpan(child: Icon(Icons.timer, color: iconColor,),
                    alignment: PlaceholderAlignment.middle),
                TextSpan(text: " $remainingTime\n"),
                WidgetSpan(child: Icon(Icons.alt_route, color: iconColor,),
                    alignment: PlaceholderAlignment.middle),
                TextSpan(text: " ${remainingMoves.toString()}"),
              ]
          )
      );
    }
    else if (remainingDuration != null && remainingMoves == null){
      return RichText(
          text: TextSpan(
              style: timeStyle,
              children: [
                WidgetSpan(
                    child: Icon(Icons.timer, color: iconColor,),
                    alignment: PlaceholderAlignment.middle
                ),
                TextSpan(text: " $remainingTime")
              ]
          )
      );
    }
    else if (remainingDuration == null && remainingMoves != null){
      return RichText(
          text: TextSpan(
              style: timeStyle,
              children: [
                WidgetSpan(child: Icon(Icons.alt_route, color: iconColor,),
                    alignment: PlaceholderAlignment.middle),
                TextSpan(text: " ${remainingMoves.toString()}"),
              ]
          )
      );
    }
  }

}










String DurationToString(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}



//returns a Color based on the amount of time that has elapsed
Color calculateColor (int max, int current) {
  double remainingFraction = current / max;
  var rb = Rainbow(
      spectrum: [
        Color(0xff1fff00),
        Color(0xffd0ff00),
        Color(0xffffdd00),
        Color(0xffec0000)
      ],
      rangeStart: 1.0,
      rangeEnd: 0.0
  );
  return rb[remainingFraction];
}
