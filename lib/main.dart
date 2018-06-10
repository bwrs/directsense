import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import "dart:async";

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Component Testing',
      theme: new ThemeData(
        brightness: Brightness.dark,
      ),
      home: new TestSelectionStateful(),
    );
  }
}

class TestSelectionStateful extends StatefulWidget {
  @override
  createState() => new TestSelection();
}

class TestSelection extends State<TestSelectionStateful> {
  //TestSelection({Key key, this.title}) : super(key: key);

  // This widget is the test selection page.
  // It is stateless.

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text("Test Selection")
        ),
        body: new ListView(
            children: ListTile.divideTiles(
                context: context,
                tiles: <Widget>[
                  ListTile(
                      leading: new Icon(Icons.vibration),
                      title: new Text("Haptic Feedback"),
                      onTap: () {
                        pushHaptic(context);
                      }
                  )
                ]
            ).toList()
        )
    );
  }

  void pushHaptic(context) {
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (context) {
              return new Scaffold(
                  appBar: new AppBar(
                      title: new Text("Haptic Feedback Tests")
                  ),
                  body: new ListView(
                      children: ListTile.divideTiles(
                          context: context,
                          tiles: <Widget>[
                            ListTile(
                                title: new Text("Custom 100ms"),
                                onTap: () {
                                  GoodVibrations.vibrate(100);
                                }
                            ),
                            ListTile(
                                title: new Text("Custom 300ms"),
                                onTap: () {
                                  GoodVibrations.vibrate(250);
                                }
                            ),
                            ListTile(
                                title: new Text("Custom 500ms"),
                                onTap: () {
                                  GoodVibrations.vibrate(500);
                                }
                            ),
                            ListTile(
                                title: new Text("SOS"),
                                onTap: () {
                                  GoodVibrations.vibrateWithPauses([
                                    100, 100, 100, 100, 100, 300,
                                    300, 100, 300, 100, 300, 300,
                                    100, 100, 100, 100, 100
                                  ]);
                                }
                            ),
                            ListTile(
                                title: new Text("Alert 12345 67890"),
                                onTap: () {
                                  GoodVibrations.alert("12345 67890");
                                }
                            )
                          ]
                      ).toList()
                  )
              );
            }
        )
    );
  }
}

class GoodVibrations {
  static const MethodChannel _channel = const MethodChannel(
      'github.com/clovisnicolas/flutter_vibrate');

  static Future vibrate(ms) =>
      _channel.invokeMethod("vibrate", {"duration": ms});

  ///Take in an Iterable<int> of the form
  ///[l_1, p_1, l_2, p_2, ..., l_n]
  ///then vibrate for l_1 ms,
  ///pause for p_1 ms,
  ///vibrate for l_2 ms,
  ///...
  ///and vibrate for l_n ms.
  static Future vibrateWithPauses(Iterable<int> periods) async {
    bool isVibration = true;
    for (int d in periods) {
      if (isVibration && d > 0) {
        vibrate(d);
      }
      await new Future.delayed(Duration(milliseconds: d));
      isVibration = !isVibration;
    }
  }

  static const BinaryMap = {
    " ": [0, 1200],
    "0": [75, 1125],
    "1": [225, 975],
    "2": [225, 75, 75, 825],
    "3": [225, 75, 225, 675],
    "4": [225, 75, 75, 75, 75, 675],
    "5": [225, 75, 75, 75, 225, 525],
    "6": [225, 75, 225, 75, 75, 525],
    "7": [225, 75, 225, 75, 225, 375],
    "8": [225, 75, 75, 75, 75, 75, 75, 525],
    "9": [225, 75, 75, 75, 75, 75, 225, 375]
  };

  static const BinaryMap50_150 = {
    " ": [0, 1000],
    "0": [50, 950],
    "1": [150, 850],
    "2": [150, 50, 50, 750],
    "3": [150, 50, 150, 650],
    "4": [150, 50, 50, 50, 50, 650],
    "5": [150, 50, 50, 50, 150, 550],
    "6": [150, 50, 150, 50, 50, 550],
    "7": [150, 50, 150, 50, 150, 450],
    "8": [150, 50, 50, 50, 50, 50, 50, 550],
    "9": [150, 50, 50, 50, 50, 50, 150, 450]
  };

  static void alert(String data) {
    List<int> periods = [];
    for (int i = 0; i < data.length; i++) {
      periods.addAll(BinaryMap[data[i]]);
    }
    vibrateWithPauses(periods);
  }
}
