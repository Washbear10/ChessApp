import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/deletion_model.dart';
import 'package:provider/provider.dart';
import 'game_setting.dart';
import 'package:flutter_app/time_button.dart' show DurationToString;
import 'configuration_model.dart';
import 'package:toast/toast.dart';



class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}
class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DeletionModel(),
        child: MySafeAreaWidget()
    );
  }
}



class MySafeAreaWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var deletionModelInfo = context.watch<DeletionModel>();
    // var configurationModelInfo = context.watch<ConfigurationModel>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: Text("Game Configuration"),
          backgroundColor: Colors.white24,
          elevation: 0,
        ),
        body: Container(
          color: Colors.white24,
          padding: EdgeInsets.all(10),
          child: GameCardBuilder(),
        ),
      ),
    );
  }
}






class GameCardBuilder extends StatefulWidget {
  GameCardBuilder({Key key,}) : super(key: key);
  @override
  _GameCardBuilderState createState() => _GameCardBuilderState();
}

class _GameCardBuilderState extends State<GameCardBuilder> {
  @override
  Widget build(BuildContext context) {
    var configurationModelInfo = context.watch<ConfigurationModel>();
    // ok this is a little ponderous: It builds a ListView from the model, but always with the AddGame Item at the beginning. I could add the AddGame Item into
    // the List of the model at the beginning, but that is pretty high coupling. So I need to add it here in the builder:
    bool addGameCardAdded = false;
    return ListView.builder(
        itemCount: configurationModelInfo.gameList.length + 1, //+1 because I add the ADdGame button
        itemBuilder: (context, index) {
          if (!addGameCardAdded) { // start building the list. At index 0 always insert the ADdGameCard Widget.
            addGameCardAdded = true;
            return AddGameCard();
          }  //when it's added, proceed to build all the game ListTiles from the Model
          index--;   //must be declared here, and not in the (more obvious) conditional block above, because the builder function seems to be immune to
          //changes to index. So decrement index before every Card gets build, so you start with 0, and not 1
          Game containedGame = configurationModelInfo.gameList[index];
          return GameCard(configurationModelInfo, index, containedGame);
        }
    );
  }
}









class AddGameCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var configurationModelInfo = context.watch<ConfigurationModel>();
    var deletionModelInfo = context.watch<DeletionModel>();
    if (!deletionModelInfo.deleteMode) // We are not deleting, just showing Games, then show an "Add new game" Card
      return Card(
        color: Colors.amber.withOpacity(0.8),
        child: ListTile(
          subtitle: Icon(Icons.add_box),
          title: Center(child: Text("Add Game"),),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          // trailing: IconButton(icon: Icon(Icons.edit),),
          onTap: () {
            showDialog(
                context: context,
                builder:  (context) {
                  return SimpleDialog(
                    title: Text("New Game"),
                    children: [
                      AddGameForm()
                    ],
                  );
                }
            );
          },
        ),
      );
    else          // If in deletion mode, then act as Delete Button for selected Games
      return Card(
        color: Color.fromRGBO(215, 209, 209, 1.0),
        child: ListTile(
          subtitle: Icon(Icons.delete_forever),
          title: Center(child: Text("Delete selected games", style: deleteCardStyle,),),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          // trailing: IconButton(icon: Icon(Icons.edit),),
          onTap: () {
            configurationModelInfo.removeGamesWithDeletionList(deletionModelInfo.deletionList);
            deletionModelInfo.deActivateDeleteMode();
            Toast.show(
                "Games deleted.",
                context,
                duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,
                backgroundColor: Colors.amber.withOpacity(0.6),
                textColor: Colors.black,
                border: Border.all(
                    color: Colors.amber
                )
            );
          },
        ),
      );
  }
}










class GameCard extends StatefulWidget {
  GameCard(this.configurationModelInfo, this.index, this.containedGame);
  ConfigurationModel configurationModelInfo;  //
  int index; //from builder Function in GameCardBuilder, needed to access specific Game in List from Provider
  Game containedGame;
  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  @override
  Widget build(BuildContext context) {
    var deletionModelInfo = context.watch<DeletionModel>();
    return Card(
      color: Color(0xFF504E4E),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.white.withOpacity(0.2)
          )
      ),
      child: AnimatedContainer(
        // color: deletionModelInfo.deletionList.contains(widget.containedGame)  ? Color(0x9ED71818) : Color(0x504E4E),
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
            color: deletionModelInfo.deletionList.contains(widget.containedGame)  ? Color(
                0x52B61818) : Color(0x504E4E),
            border: Border.all(
              color: deletionModelInfo.deletionList.contains(widget.containedGame)  ? Color(
                  0xFFBD0000) : Color(0x504E4E),
            )
        ),
        child: ListTile(
          subtitle: Row(
              children: [
                Expanded(child: Text(widget.configurationModelInfo.gameList[widget.index].name, softWrap: true, style: cardTitleStyle,), flex: 3,),
                Expanded(child: getRichTextColumn(widget.configurationModelInfo.gameList[widget.index]), flex: 3),
              ]
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          // trailing: IconButton(icon: Icon(Icons.edit),),
          onTap: () {
            if (deletionModelInfo.deleteMode == false) { //if I am not in deletionmode, I just want to play the selected Game.
              Navigator.pop(
                  context,
                  widget.configurationModelInfo.gameList[widget.index]
              );
            } else{ // I long tapped a Game, so I entered deletion Mode
              if (deletionModelInfo.deletionList.contains(widget.containedGame)){
                deletionModelInfo.removeGameFromDeletionList(widget.containedGame);
                if (deletionModelInfo.deletionList.isEmpty) deletionModelInfo.deActivateDeleteMode(); // Maybe It was the last red Card, then i should leave deletion mode
              } else {
                deletionModelInfo.addGameToDeletionList(widget.containedGame);
              }
            }
          },
          onLongPress: () { // handle Deletion Mode with LongTapping
            if (deletionModelInfo.deleteMode == false) { //first Game to be selected for Deletion
              deletionModelInfo.activateDeleteMode();
              deletionModelInfo.addGameToDeletionList(widget.containedGame);
            }
          },
        ),
      ),
    );
  }


  Widget getRichTextColumn(Game game){
    List<Widget> columnList = [];
    columnList.add(
        RichText(
            text: TextSpan(
                children: [
                  WidgetSpan(child: Icon(Icons.timer, color: Colors.amber, size: 30,)),
                  TextSpan(text: game.duration != null ? "  ${DurationToString(game.duration)}" : " - ", style: cardValuesStyle)
                ]
            )
        )
    );
    columnList.add(
        RichText(
            text: TextSpan(
                children: [
                  WidgetSpan(child: Icon(Icons.alt_route, color: Colors.amber, size: 30,)),
                  TextSpan(text: game.maxMoves != null ?"  ${game.maxMoves}" : " - ", style: cardValuesStyle)
                ]
            )
        )
    );
    return Column(children: columnList, crossAxisAlignment: CrossAxisAlignment.start,);
  }
}
















class AddGameForm extends StatefulWidget {
  @override
  _AddGameFormState createState() => _AddGameFormState();
}

class _AddGameFormState extends State<AddGameForm> {
  final _formKey = GlobalKey<FormState>();
  final _hoursFormFieldKey = GlobalKey<FormFieldState>();
  final _minutesFormFieldKey = GlobalKey<FormFieldState>();
  final _secondsFormFieldKey = GlobalKey<FormFieldState>();
  final _movesFormFieldKey = GlobalKey<FormFieldState>();
  final tcHours = TextEditingController();
  final tcMinutes = TextEditingController();
  final tcSeconds = TextEditingController();
  final tcTitle = TextEditingController();
  final tcMoves = TextEditingController();
  final nodeHours = FocusNode();
  final nodeMinutes = FocusNode();
  final nodeSeconds = FocusNode();
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    tcHours.dispose();
    tcMinutes.dispose();
    tcSeconds.dispose();
    super.dispose();
  }

  void initState() {
    nodeHours.addListener(() {
      if (!nodeHours.hasFocus && tcHours.text == "")  tcHours.text = "0";
    });
    nodeMinutes.addListener(() {
      if (!nodeMinutes.hasFocus && tcMinutes.text == "") tcMinutes.text = "0";
    });
    nodeSeconds.addListener(() {
      if (!nodeSeconds.hasFocus && tcSeconds.text == "") tcSeconds.text = "0";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var myModelInfo = context.watch<ConfigurationModel>();
    return Form(
      onChanged: customValidate,
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.textsms_sharp),
                ),
                Expanded(
                  child: TextFormField(
                    controller: tcTitle,
                    decoration: InputDecoration(
                        hintText: "Title"
                    ),
                    style: gameInputStyle,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[^#;]')),
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.timer),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          key: _hoursFormFieldKey,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "";
                            }
                          },
                          controller: tcHours,
                          focusNode: nodeHours,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          style: gameInputStyle,
                          decoration: InputDecoration(
                              hintText: "H"
                          ),
                        ),
                      ),
                      Text(":", style: TextStyle(fontSize: 30),),
                      Expanded(
                        child: TextFormField(
                          key: _minutesFormFieldKey,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "";
                            }
                          },
                          textAlign: TextAlign.center,
                          controller: tcMinutes,
                          focusNode: nodeMinutes,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          style: gameInputStyle,

                          decoration: InputDecoration(
                              hintText: "M"
                          ),
                        ),
                      ),
                      Text(":", style: TextStyle(fontSize: 30),),
                      Expanded(
                        child: TextFormField(
                          key: _secondsFormFieldKey,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "";
                            }
                          },
                          controller: tcSeconds,
                          focusNode: nodeSeconds,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          style: gameInputStyle,

                          decoration: InputDecoration(
                              hintText: "S"
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.alt_route),
                ),                Expanded(
                  flex: 1,
                  child: TextFormField(
                    key: _movesFormFieldKey,
                    controller: tcMoves,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "";
                      }
                    },
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                    ],
                    style: gameInputStyle,
                    decoration: InputDecoration(
                        hintText: "-"
                    ),
                  ),
                ),
                Spacer(flex: 3,)
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                if (customValidate()){
                  String name = tcTitle.text ?? "";
                  int hours = int.tryParse(tcHours.text);
                  int minutes = int.tryParse(tcMinutes.text);
                  int seconds = int.tryParse(tcSeconds.text);
                  int maxMoves = int.tryParse(tcMoves.text);
                  Duration duration;
                  if (hours != null && minutes != null && seconds != null) { //Time was supplied
                    duration = Duration(hours: hours, minutes: minutes, seconds: seconds);
                    if (duration.inSeconds == 0 && maxMoves == null) { // If input was 0:0:0 in Time, and also no maxMoves -> show error
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: Text("Invalid Settings"),
                                content: Text("Time must be greater than 0:0:0 if supplied")
                            );
                          }
                      );
                      return;
                    } else if (duration.inSeconds == 0 && maxMoves != null) duration = null;
                    // (maxMoves was supplied, and time was supplied as 0:0:0, then User probably meant to only configure moves)
                  }
                  if (tcMoves == 0) maxMoves = null;
                  Game newGame = Game(duration, maxMoves, name);
                  await myModelInfo.addGameToList(newGame);
                  Navigator.pop(context);
                  Toast.show(
                      "Game added.",
                      context,
                      duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,
                      backgroundColor: Colors.amber.withOpacity(0.6),
                      textColor: Colors.black,
                      border: Border.all(
                          color: Colors.amber
                      )
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }



  //My own validation Function for this Form
  bool customValidate () {
    // Very Nasty workaround again, but Flutter doesn't support otherwise: I cannot validate the Form as a whole, because the form should be valid if at least
    // one of both of the Time (actually multiple forms, but behave synchronously) and the Moves FormField is valid (supplied). So I need to check each combination
    // of possible input supplies by the user on the forms. This function returns true or false, depending
    // on the validity of the forms. I check the validity in the if clauses already, so the validate methods seem to be unneccessary, but it' actually needed to show (or let
    // disappear) the error messages from the validating to the user.

    // All Times supplied, but not Moves
    if (_hoursFormFieldKey.currentState.isValid && _minutesFormFieldKey.currentState.isValid && _secondsFormFieldKey.currentState.isValid && !_movesFormFieldKey.currentState.isValid){
      _hoursFormFieldKey.currentState.validate();
      _minutesFormFieldKey.currentState.validate();
      _secondsFormFieldKey.currentState.validate();

      // to prevent the error message from showing, because it's accepted to only supply time
      _movesFormFieldKey.currentState.setValue("0");
      _movesFormFieldKey.currentState.validate();
      return true;
    }
    // moves  supplied, but not all times
    else if (!(_hoursFormFieldKey.currentState.isValid && _minutesFormFieldKey.currentState.isValid && _secondsFormFieldKey.currentState.isValid) && _movesFormFieldKey.currentState.isValid){
      _movesFormFieldKey.currentState.validate();

      // to prevent the error message from showing, because it's accepted to only supply moves
      _hoursFormFieldKey.currentState.setValue("0");
      _minutesFormFieldKey.currentState.setValue("0");
      _secondsFormFieldKey.currentState.setValue("0");
      _hoursFormFieldKey.currentState.validate();
      _minutesFormFieldKey.currentState.validate();
      _secondsFormFieldKey.currentState.validate();
      return true;
    }
    // both supplied
    else if (_hoursFormFieldKey.currentState.isValid && _minutesFormFieldKey.currentState.isValid && _secondsFormFieldKey.currentState.isValid && _movesFormFieldKey.currentState.isValid){
      _formKey.currentState.validate();
      return true;
    }
    // none supplied
    else {
      _formKey.currentState.validate();
      return false;
    }
  }
}








