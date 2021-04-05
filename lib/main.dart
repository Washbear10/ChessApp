import 'package:flutter/material.dart';
import 'package:flutter_app/model.dart';
import 'package:flutter_app/time_button.dart';
import 'package:provider/provider.dart';
import 'icon_button_widgets.dart';
import 'package:flutter/services.dart';
void main() {
  print(~1);
  print(~2);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitUp
      ]
    );
    return MaterialApp(
        title: 'Flutter Demo',
        home: HomeScreen()
    );
  }
}




class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            body: Container(
              height: size.height,
              width: size.width,
              color: Colors.black87,
              child: ChangeNotifierProvider(
                create: (context) => MyModel(),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RotatedBox(child: TimeButton(buttonNumber: 1,), quarterTurns: 2,),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyPauseButton(),
                            MyRestartButton(),
                            MySettingsButton()
                          ],
                        ),
                      ),
                      TimeButton(buttonNumber: 2,),
                    ]
                ),
              ),
            )
        )
    );
  }
}









