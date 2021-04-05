import 'package:quiver/core.dart';



class Game {

  Duration duration;
  int maxMoves;
  String name;
  //might think of other properties, but keep those for now

  // static final defaultGame = Game(Duration(seconds: 20), 20, "DefaultGame");

  Game(this.duration, this.maxMoves, this.name);


  bool operator ==(o) => o is Game && name == o.name && duration == o.duration && maxMoves == o.maxMoves;
  int get hashCode => hash3(name.hashCode, maxMoves.hashCode, duration.hashCode);

}