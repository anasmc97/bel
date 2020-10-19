import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bel/jadwal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:minimize_app/minimize_app.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'clock_body.dart';
import 'hari.dart';

void main() {
  runApp(MyApp());
  // const oneSec = const Duration(seconds:1);
  // new Timer.periodic(oneSec, (Timer t) => print('hi!'));
}

class MyApp extends StatefulWidget {
  
  final List<Map> listJadwal;
  final String hari;
  // This widget is the root of your application.
  MyApp({this.listJadwal, this.hari});
  @override
  _MyAppState createState() => _MyAppState();
}
const CHANNEL = "backgroundServices.channel";
const KEY_NATIVE = "BackGroundService";
class _MyAppState extends State<MyApp> {
  
  static const platform = const MethodChannel(CHANNEL);
  List<Map> listmapjadwal = [];
  Jadwal list;
  ThemeData _clockTheme = _buildClockTheme(false);
  Color mycolor = Colors.grey[350];
  List<bool> isSelected = [false];
  List<bool> selected = [true, true, true];
  AudioPlayer player;
  bool isPlaying = false;
  AudioCache _audioCache = AudioCache();
  AudioCache _bunyi = AudioCache();
  Color _myColor = Colors.grey[350];
  Color _kColor = Colors.grey[350];
  Color _pColor = Colors.grey[350];
  List<RadioModel> sampleData = new List<RadioModel>();
  static var now = DateTime.now();
  var tanggal = "";
  //var formatedJam = new DateFormat('hh:mm').format(now);
  var jam = '';
  var hari = '';
  String dropdownValue = 'Bel Masuk';
  
  List<Map> listJadwal = [];
  
  //List<Map<Map, dynamic>> listmap;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sampleData.add(new RadioModel(false, "Jam Masuk"));
    sampleData.add(new RadioModel(false, "Jam Keluar"));
    sampleData.add(new RadioModel(false, "Jam Pulang"));
    _audioCache = AudioCache(
        fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.LOOP));
    _bunyi = AudioCache(
        fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
        //_read();
        startJam();
        
        //print(listJadwal);
    
    
    //_panggil();
    
    //belbunyiotomatis();
    // if(widget.listJadwal == null){
    //   listJadwal = [];
    // }else{
    //   listJadwal = widget.listJadwal;
    // }
    //print(listJadwal);
  }
//   _panggil() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var _ambiltext = prefs.getString('text_tersimpan');
//   List listtext = jsonDecode(_ambiltext);
//   print(listtext);
//   for(var i in listtext){
//     Map z = i;
//     listmapjadwal.add(z);
//   }

//   print(listmapjadwal);
// }
_read() async {
  //try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_file.txt');
    String text = await file.readAsString();
    List listtext = jsonDecode(text);
    for(var i in listtext){
     Map z = i;
     listJadwal.add(z);
   }
      //    for (var i in listJadwal) {
      //   if (hari == "Mon") {
      //     if(jam == i['Mon']['jam']){
      //     if (i['Mon']['bel'] == "Bel Masuk"){
      //       player = await _bunyi.play('audio/3.mp3');
      //     }else if (i['Mon']['bel'] == "Bel Istirahat") {
      //       player = await _bunyi.play('audio/2.mp3');
      //     } else if (i['Mon']['bel'] == "Bel Pulang") {
      //       player = await _bunyi.play('audio/1.mp3');
      //     }
      //    }
      //   }else if (hari == "Tue"){
      //     if(jam == i['Tue']['jam']){
      //     if (i['Tue']['bel'] == "Bel Masuk"){
      //       player = await _bunyi.play('audio/3.mp3');
      //     }else if (i['Tue']['bel'] == "Bel Istirahat") {
      //       player = await _bunyi.play('audio/2.mp3');
      //     } else if (i['Tue']['bel'] == "Bel Pulang") {
      //       player = await _bunyi.play('audio/1.mp3');
      //     }
      //    }
      //   }else if (hari == "Wed"){
      //     if(jam == i['Wed']['jam']){
      //     if (i['Wed']['bel'] == "Bel Masuk"){
      //       player = await _bunyi.play('audio/3.mp3');
      //     }else if (i['Wed']['bel'] == "Bel Istirahat") {
      //       player = await _bunyi.play('audio/2.mp3');
      //     } else if (i['Wed']['bel'] == "Bel Pulang") {
      //       player = await _bunyi.play('audio/1.mp3');
      //     }
      //    }
      //   }else if (hari == "Thu"){
      //     if(jam == i['Thu']['jam']){
      //     if (i['Thu']['bel'] == "Bel Masuk"){
      //       player = await _bunyi.play('audio/3.mp3');
      //     }else if (i['Thu']['bel'] == "Bel Istirahat") {
      //       player = await _bunyi.play('audio/2.mp3');
      //     } else if (i['Thu']['bel'] == "Bel Pulang") {
      //       player = await _bunyi.play('audio/1.mp3');
      //     }
      //    }
      //   }else if (hari == "Fri"){
      //     if(jam == i['Fri']['jam']){
      //     if (i['Fri']['bel'] == "Bel Masuk"){
      //       player = await _bunyi.play('audio/3.mp3');
      //     }else if (i['Fri']['bel'] == "Bel Istirahat") {
      //       player = await _bunyi.play('audio/2.mp3');
      //     } else if (i['Fri']['bel'] == "Bel Pulang") {
      //       player = await _bunyi.play('audio/1.mp3');
      //     }
      //    }
      //   }else if (hari == "Sat"){
      //     if(jam == i['Sat']['jam']){
      //     if (i['Sat']['bel'] == "Bel Masuk"){
      //       player = await _bunyi.play('audio/3.mp3');
      //     }else if (i['Sat']['bel'] == "Bel Istirahat") {
      //       player = await _bunyi.play('audio/2.mp3');
      //     } else if (i['Sat']['bel'] == "Bel Pulang") {
      //       player = await _bunyi.play('audio/1.mp3');
      //     }
      //    }
      //   }
      // }
    //print(listJadwal);
  //} 
  //  catch (e) {
  // //   print("Couldn't read file");
  //  }
}
  Future<void> _backgroundServiceNative() async {
    try {
      String result = await platform.invokeMethod(KEY_NATIVE, {
      });
      print(result);
    } on PlatformException catch (e) {
      print(e);
    }
  }
  void startJam() {
    Timer.periodic(new Duration(seconds: 1), (_) {
      var tgl = new DateTime.now();
      var formatedjam = new DateFormat.Hms().format(tgl);
      var formatedTanggal = new DateFormat.yMMMEd().format(tgl);
      var day = new DateFormat.E().format(tgl);
      //print(day);
      setState(() {
        jam = formatedjam;
        tanggal = formatedTanggal;
        hari = day;
      });
      //_read();
      belbunyiotomatis();
    });
  }

  void belbunyi() async {
    if (isPlaying) {
      player.stop();
    } else {
      if (dropdownValue == "Bel Masuk") {
        player = await _audioCache.play('audio/3.mp3');
      } else if (dropdownValue == "Bel Istirahat") {
        player = await _audioCache.play('audio/2.mp3');
      } else if (dropdownValue == "Bel Pulang") {
        player = await _audioCache.play('audio/1.mp3');
      }
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void belbunyiotomatis() async {
      //_read();

      for (var i in listJadwal) {
        if (hari == "Mon") {
          if(jam == i['Mon']['jam']){
          if (i['Mon']['bel'] == "Bel Masuk"){
            player = await _bunyi.play('audio/3.mp3');
          }else if (i['Mon']['bel'] == "Bel Istirahat") {
            player = await _bunyi.play('audio/2.mp3');
          } else if (i['Mon']['bel'] == "Bel Pulang") {
            player = await _bunyi.play('audio/1.mp3');
          }
         }
        }else if (hari == "Tue"){
          if(jam == i['Tue']['jam']){
          if (i['Tue']['bel'] == "Bel Masuk"){
            player = await _bunyi.play('audio/3.mp3');
          }else if (i['Tue']['bel'] == "Bel Istirahat") {
            player = await _bunyi.play('audio/2.mp3');
          } else if (i['Tue']['bel'] == "Bel Pulang") {
            player = await _bunyi.play('audio/1.mp3');
          }
         }
        }else if (hari == "Wed"){
          if(jam == i['Wed']['jam']){
          if (i['Wed']['bel'] == "Bel Masuk"){
            player = await _bunyi.play('audio/3.mp3');
          }else if (i['Wed']['bel'] == "Bel Istirahat") {
            player = await _bunyi.play('audio/2.mp3');
          } else if (i['Wed']['bel'] == "Bel Pulang") {
            player = await _bunyi.play('audio/1.mp3');
          }
         }
        }else if (hari == "Thu"){
          if(jam == i['Thu']['jam']){
          if (i['Thu']['bel'] == "Bel Masuk"){
            player = await _bunyi.play('audio/3.mp3');
          }else if (i['Thu']['bel'] == "Bel Istirahat") {
            player = await _bunyi.play('audio/2.mp3');
          } else if (i['Thu']['bel'] == "Bel Pulang") {
            player = await _bunyi.play('audio/1.mp3');
          }
         }
        }else if (hari == "Fri"){
          if(jam == i['Fri']['jam']){
          if (i['Fri']['bel'] == "Bel Masuk"){
            player = await _bunyi.play('audio/3.mp3');
          }else if (i['Fri']['bel'] == "Bel Istirahat") {
            player = await _bunyi.play('audio/2.mp3');
          } else if (i['Fri']['bel'] == "Bel Pulang") {
            player = await _bunyi.play('audio/1.mp3');
          }
         }
        }else if (hari == "Sat"){
          if(jam == i['Sat']['jam']){
          if (i['Sat']['bel'] == "Bel Masuk"){
            player = await _bunyi.play('audio/3.mp3');
          }else if (i['Sat']['bel'] == "Bel Istirahat") {
            player = await _bunyi.play('audio/2.mp3');
          } else if (i['Sat']['bel'] == "Bel Pulang") {
            player = await _bunyi.play('audio/1.mp3');
          }
         }
        }
      }
   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _clockTheme,
      home: Scaffold(
          backgroundColor: isSelected[0] ? Colors.grey[800] : Colors.grey[300],
          body: Center(
            child: OrientationBuilder(
              builder: (context, orientation) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    //Flex is basically row and column combined into one
                    //Change axis based on orientation of screen
                    // direction: orientation == Orientation.portrait
                    // ? Axis.vertical : Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            DropdownButton<String>(
                              value: dropdownValue,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black),
                              underline: Container(
                                height: 2,
                                color: Colors.black,
                              ),
                              onChanged: (String newValue) async {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                                if (isPlaying) {
                                  if (dropdownValue == "Bel Masuk") {
                                    player =
                                        await _audioCache.play('audio/3.mp3');
                                  } else if (dropdownValue == "Bel Istirahat") {
                                    player =
                                        await _audioCache.play('audio/2.mp3');
                                  } else if (dropdownValue == "Bel Pulang") {
                                    player =
                                        await _audioCache.play('audio/1.mp3');
                                  }
                                }
                              },
                              items: <String>[
                                'Bel Masuk',
                                'Bel Istirahat',
                                'Bel Pulang'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            SizedBox(width: 10),
                            RaisedButton(
                                color: mycolor,
                                child: Text("Bel Bunyi"),
                                onPressed: () {
                                  belbunyi();
                                  setState(() {
                                    if (mycolor == Colors.grey[350]) {
                                      mycolor = Colors.grey[600];
                                    } else {
                                      mycolor = Colors.grey[350];
                                    }
                                  });
                                })
                          ],
                        ),
                      ),
                      Container(height: 200, width: 300, child: Clock()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              padding: EdgeInsets.all(20),
                              decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(10),
                                  color: Colors.black54),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      tanggal,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      jam,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //   Text(
                                    //     '00',
                                    //     style: TextStyle(
                                    //         color: Colors.white, fontSize: 54, fontWeight: FontWeight.bold),
                                    //   ),
                                    //   Text('Jam',
                                    //       style: TextStyle(
                                    //         color: Colors.white,
                                    //       ))
                                    // ])),
                                    // Container(
                                    // margin: EdgeInsets.symmetric(horizontal: 5),
                                    // padding: EdgeInsets.all(20),
                                    // decoration: new BoxDecoration(
                                    //     borderRadius: new BorderRadius.circular(10), color: Colors.black54),
                                    // child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                    //   Text(
                                    //     '00',
                                    //     style: TextStyle(
                                    //         color: Colors.white, fontSize: 54, fontWeight: FontWeight.bold),
                                    //   ),
                                    //   Text('Min',
                                    //       style: TextStyle(
                                    //         color: Colors.white,
                                    //       ))
                                    // ])),
                                    // Container(
                                    // margin: EdgeInsets.symmetric(horizontal: 5),
                                    // padding: EdgeInsets.all(20),
                                    // decoration: new BoxDecoration(
                                    //     borderRadius: new BorderRadius.circular(10), color: Colors.black54),
                                    // child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                    //   Text(
                                    //     '00',
                                    //     style: TextStyle(
                                    //         color: Colors.white, fontSize: 54, fontWeight: FontWeight.bold),
                                    //   ),
                                    //   Text('Sec',
                                    //       style: TextStyle(
                                    //         color: Colors.white,
                                    //       ))
                                  ])),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TabBarDemo(hari: "Mon",)));
                              },
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Text("Senin"),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TabBarDemo(hari: "Tue",)));
                              },
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Text("Selasa"),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TabBarDemo(hari: "Wed",)));
                              },
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Text("Rabu"),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TabBarDemo(hari: "Thu", )));
                              },
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Text("Kamis"),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TabBarDemo(hari: "Fri",)));
                              },
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Text("Jum'at"),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TabBarDemo(hari: "Sat",)));
                              },
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Text("Sabtu"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     Card(
                      //       child: Container(
                      //         padding: EdgeInsets.all(20),
                      //         child: Text("senin"),
                      //       ),
                      //     ),
                      //     Card(
                      //       child: Container(
                      //         padding: EdgeInsets.all(20),
                      //         child: Text("selasa"),
                      //       ),
                      //     ),
                      //     Card(
                      //       child: Container(
                      //         padding: EdgeInsets.all(20),
                      //         child: Text("rabu"),
                      //       ),
                      //     ),
                      //     Card(
                      //       child: Container(
                      //         padding: EdgeInsets.all(20),
                      //         child: Text("kamis"),
                      //       ),
                      //     ),
                      //     Card(
                      //       child: Container(
                      //         padding: EdgeInsets.all(20),
                      //         child: Text("jum'at"),
                      //       ),
                      //     ),
                      //     Card(
                      //       child: Container(
                      //         padding: EdgeInsets.all(20),
                      //         child: Text("sabtu"),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ButtonBar(
                            children: [
                              new Builder(builder: (BuildContext context) {
                                return RaisedButton(
                                  color: Colors.grey,
                                  elevation: 2,
                                  onPressed: () {
                                    _backgroundServiceNative();
                                    //MinimizeApp.minimizeApp();
                                  },
                                  child: new Text(
                                    "Minimize App",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              })
                            ],
                          ),
                        ],
                      )

                      // Material(
                      //   child: ToggleButtons(
                      //     color: Colors.grey[800],
                      //     selectedColor: Colors.grey[300],
                      //     fillColor: Colors.grey[800],
                      //     borderColor: Colors.black,
                      //     selectedBorderColor: Colors.white,
                      //     children: <Widget>[
                      //       Icon(Icons.brightness_3),
                      //     ],
                      //     onPressed: (int index) {
                      //       setState(() {
                      //         isSelected[index] = !isSelected[index];
                      //         _clockTheme = _buildClockTheme(isSelected[index]);
                      //       });
                      //     },5554555555
                      //     isSelected: isSelected,
                      //   ),
                      // ),
                    ],
                  ),
                );
              },
            ),
          )),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Clock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClockBody(),
    );
  }
}

ThemeData _buildClockTheme(bool darkMode) {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    primaryColor: darkMode ? Colors.grey[800] : Colors.white,
    colorScheme: darkMode
        ? base.colorScheme.copyWith(
            primary: Colors.grey[800],
            secondary: Colors.grey[900],
            secondaryVariant: Colors.grey[700],
            primaryVariant: Colors.white,
          )
        : base.colorScheme.copyWith(
            primary: Colors.grey[300],
            secondary: Colors.grey[500],
            secondaryVariant: Colors.white,
            primaryVariant: Colors.grey,
          ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(15.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            height: 50.0,
            width: 50.0,
            child: new Center(
              child: new Text(_item.buttonText,
                  style: new TextStyle(
                      color: _item.isSelected ? Colors.white : Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
            ),
            decoration: new BoxDecoration(
              color: _item.isSelected ? Colors.blueAccent : Colors.transparent,
              border: new Border.all(
                  width: 1.0,
                  color: _item.isSelected ? Colors.blueAccent : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
          // new Container(
          //   margin: new EdgeInsets.only(left: 10.0),
          //   // child: new Text(_item.buttonText),
          // )
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;

  RadioModel(
    this.isSelected,
    this.buttonText,
  );
}
