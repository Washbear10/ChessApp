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

  int buttonNumber;
  Game game = Game(Duration(seconds: 20), 20, "DefaultGame");
  TimeButton({Key key, this.buttonNumber}) : super(key: key);

// void setGame(Game game){
//   this.game = game;
// }
}

class _TimeButtonState extends State<TimeButton> {

  //properties regarding time
  String remainingTime;
  Timer timer;
  bool run;
  Duration remainingDuration;

  //properties regarding coloring
  Color currentColor;
  Timer colorTimer;

  void stopRun(){
    run = false;
  }
  void startRun(){
    run = true;
  }

  void resetTime(){
    setState(() {
      remainingDuration = widget.game.duration;
      remainingTime = DurationToString(remainingDuration);
      currentColor = calculateColor(widget.game.duration.inMilliseconds, remainingDuration.inMilliseconds).withOpacity(0.3);
    });
    // print("resetTime to $remainingDuration");
    // print("run: $run");
  }

  @override
  void initState() {
    super.initState();
    run = false;
    remainingDuration = widget.game.duration;
    remainingTime = DurationToString(remainingDuration);
    currentColor = calculateColor(widget.game.duration.inMilliseconds, remainingDuration.inMilliseconds);
    colorTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      //update time and color every 100ms IF its your turn
      if (run){
        setState(() {
          remainingDuration = remainingDuration - Duration(milliseconds: 100);
          remainingTime = DurationToString(remainingDuration);
          currentColor = calculateColor(widget.game.duration.inMilliseconds, remainingDuration.inMilliseconds);
        });
        if (remainingDuration == Duration.zero){
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
      if(myModelInfo.game != widget.game) {
        widget.game = myModelInfo.game;
      }
      if (!myModelInfo.hasStarted && remainingDuration != widget.game.duration){
        print("Not started and remaining != maxduration");
        resetTime();
      }
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: size.height * 0.4,
      width: size.width * 0.9,
      decoration: BoxDecoration(
          color: currentColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
      ),
      child: TextButton(
        child: Text(
          remainingTime,
          style: (timeStyle),
        ),
        onPressed: () {
          if(run) {
            run = false;
            //if you are player 1, set the playing button to button 2 => it's their turn;
            // if you are player 2, set it to 1
            myModelInfo.setPlayingNumber(widget.buttonNumber == 1 ? 2 : 1);
          }
          //first move:
          else if(!myModelInfo.hasStarted) {
            //same here
            myModelInfo.setPlayingNumber(widget.buttonNumber == 1 ? 2 : 1);
            //start the game
            myModelInfo.setStarted();
          }
          else if(myModelInfo.hasStarted) {
            //Do nothing, because this is two situations:
            // 1. The game has started and it's opponents turn ==> do nothing
            // 2. The game has started and it's paused ==> resume only with playbutton which remembers
            //    who's turn it was
          }
        },

      ),
    );
  }
}










String DurationToString(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}



//returns a Color based on the amount of time that has elapsed
Color calculateColor (int maxMs, int curMs) {
  double remainingFraction = curMs / maxMs;
  var rb = Rainbow(
      spectrum: [
        Color(0xff1fff00),
        Color(0xffd0ff00),
        Color(0xffffdd00),
        Color(0xffff5100),
        Color(0xffec0000)
      ],
      rangeStart: 1.0,
      rangeEnd: 0.0
  );
  return rb[remainingFraction];
}
