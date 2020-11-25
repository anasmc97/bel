import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'bloc/pages_bloc.dart';
import 'clock_body.dart';
import 'package:bel/dbhelper.dart';
import 'package:bel/jadwal.dart';
import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';


class MainPage extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MainPageState createState() => _MainPageState();
}
const CHANNEL = "backgroundServices.channel";
const KEY_NATIVE = "BackGroundService";
class _MainPageState extends State<MainPage> {
  
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
  List<RadioModel> sampleData = new List<RadioModel>();
  var tanggal = "";
  var jam = '';
  var hari = '';
  String dropdownValue = 'Bel Masuk';
  
 List<Map> listJadwal = [];
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Jadwal> contactList; 


  @override
  void initState() {
    super.initState();
    sampleData.add(new RadioModel(false, "Jam Masuk"));
    sampleData.add(new RadioModel(false, "Jam Keluar"));
    sampleData.add(new RadioModel(false, "Jam Pulang"));
    _audioCache = AudioCache(
        fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.LOOP));
    _bunyi = AudioCache(
        fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
        startJam();
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
   startJam() async {
    await updateListView();
    
        
    Timer.periodic(new Duration(minutes: 1), (_) async {
      var tgl = new DateTime.now();
      var formatedjam = new DateFormat.Hm().format(tgl);
      var formatedTanggal = new DateFormat.yMMMEd().format(tgl);
      var day = new DateFormat.E().format(tgl);

        jam = formatedjam;
        tanggal = formatedTanggal;
        hari = day;
        var ss = await dbHelper.getJadwal(hari, jam);
        if(ss.isEmpty){
          print("tidak ada action");
        }else{
          if(ss[0].bunyi == "Bel Masuk"){
            player = await _bunyi.play('audio/3.mp3');
          } else if (ss[0].bunyi == "Bel Istirahat") {
            player = await _bunyi.play('audio/2.mp3');
          } else if (ss[0].bunyi == "Bel Pulang") {
            player = await _bunyi.play('audio/1.mp3');
          }
          
        }
    });
  }
   updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Jadwal>> contactListFuture = dbHelper.getjadwalList();
      contactListFuture.then((contactList) {
        setState(() {
          this.contactList = contactList;
          //this.count = contactList.length;
        });
      });
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
                        
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  context.bloc<PagesBloc>().add(GoToHariPage(hari: "Mon"));
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
                                  context.bloc<PagesBloc>().add(GoToHariPage(hari: "Tue",));
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
                                  context.bloc<PagesBloc>().add(GoToHariPage(hari: "Wed"));
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
                                  context.bloc<PagesBloc>().add(GoToHariPage(hari: "Thu"));
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
                                  context.bloc<PagesBloc>().add(GoToHariPage(hari: "Fri"));
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
                                  context.bloc<PagesBloc>().add(GoToHariPage(hari: "Sat"));
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
                      ],
                    ),
                  );
                },
              ),
            )),
        debugShowCheckedModeBanner: false,
      );
      //}
    //);
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