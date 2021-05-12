import 'package:flutter/material.dart';
import 'package:flutter_app/model.dart';
import 'package:flutter_app/time_button.dart';
import 'package:provider/provider.dart';
import 'configuration_model.dart';
import 'icon_button_widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/configuration_model.dart';
import 'globals.dart' as global;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  global.setGameListFromFile();
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
    return ChangeNotifierProvider(
      create: (context) => ConfigurationModel(),
      child: MaterialApp(
          title: 'Flutter Demo',
          home: HomeScreen()
      ),
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
                    children: [
                      RotatedBox(child: TimeButton(buttonNumber: 1,), quarterTurns: 2,),
                      Expanded( // This is the middle Space with the iconButtons
                        child: Stack(
                          children: [
                            Container(
                              child: MyPauseButton(),
                              alignment: Alignment.center,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  MyRestartButton(),
                                  MySettingsButton()
                                ],
                              ),
                            )
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









