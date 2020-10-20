import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:bel/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TabBarDemo extends StatefulWidget {
  //List<Map> listJadwal;
  String hari;
  TabBarDemo({this.hari});
  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> {
  String waktu;
  List waktu1;
  List waktufix;
  String dropDownValue = "Bel Masuk";
  get date => DateTime.now();
  String hari;

  Map jadwal = {'jam': "", 'bel': ""};
  List<Map> listJadwal = [];
  List<Map> listmapjadwal = [];
  List<Map<Map, dynamic>> listmap;
  Map harijadwal = {"Monday" : {'jam': "", 'bel': ""}};

_save() async {
  var listjadwalString = json.encode(listJadwal);
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/my_file.txt');
  final text = listjadwalString;
  await file.writeAsString(text);
  print('saved');
}
_read() async {
  //try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_file.txt');
    String text = await file.readAsString();
    if(text.contains("Data Masih Kosong")){
      return;
    }else{
      List listtext = jsonDecode(text);
      for(var i in listtext){
        Map z = i;
        listJadwal.add(z);
      }
    }
      
}
    //print(listJadwal);
  //} 
  // catch (e) {
  //   print("Couldn't read file");
  // }


  //List<Map> listmapjadwal = [];
  

//   _simpan() async {
//   // List<Map> daftarJadwal = [listJadwal.last];
//   // daftarJadwal.add(listJadwal.last);
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //List<Map> _text = listJadwal;
  
//   var listjadwalString = json.encode(listmapjadwal);
//   await prefs.setString('text_tersimpan', listjadwalString);
// }

// _panggil() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var _ambiltext = await prefs.getString('text_tersimpan') ?? "";
//   List listtext = jsonDecode(_ambiltext);
//   for(var i in listtext){
//     Map z = i;
//     listmapjadwal.add(z);
//   }

//   print(listmapjadwal);
// }

// _panggillast() async {

//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var _ambiltext = prefs.getString('text_tersimpan');
//    List listtext = jsonDecode(_ambiltext);
//    Map z = listtext.last;
//    listmapjadwal.add(z);
//   // for(var i in listtext){
//   //   Map z = i;
//   //   listmapjadwal.add(z);
//   // }


// }

  void _editButtonSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 30,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Center(
                        child: Text("Add"),
                      ),
                      Spacer(),
                      IconButton(
                          padding: EdgeInsets.only(left: 30),
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Pilih Waktu"),
                      FlatButton(
                        onPressed: () {
                          DatePicker.showTimePicker(context,
                          //showSecondsColumn: false,
                              showTitleActions: true, onChanged: (date) {
                            print('change $date in time zone ' +
                                date.timeZoneOffset.inHours.toString());
                            waktu = date.toString();
                            waktu1 = waktu.split(" ");
                            waktufix = waktu1[1].split(".");
                            print(waktufix);
                          }, onConfirm: (date) {
                            print('confirm $date');
                          }, currentTime: DateTime.now());
                        },
                        child: ListTile(
                          leading: Icon(Icons.timer),
                          title: Text("waktu disini"),
                          trailing: Icon(Icons.add),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.list),
                        title: Text("pilih muncul disini"),
                        trailing: DropdownButton<String>(
                          value: dropDownValue,
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
                              dropDownValue = newValue;
                            });
                          },
                          items: <String>[
                            'Bel Masuk',
                            'Bel Istirahat',
                            'Bel Pulang'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          setState(() {
                            jadwal = {hari : {"jam": waktufix[0], "bel": dropDownValue}};      
                          });
                          
                          //print(listJadwal);
                          listJadwal.add(jadwal);
                          //_read();
                          //print(listJadwal);
                          
                          // print(listJadwal);
                           //_simpan();
                           //_panggil();
                          // _panggillast();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  "Berhasil",
                                  style: TextStyle(fontSize: 12),
                                ),
                              );
                            },
                          );
                        },
                        child: Text("Set"),
                        color: Colors.grey,
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

@override
  void initState() {
    // TODO: implement initState
    //print(widget.listJadwal);
    //listJadwal = listJadwal;
    hari = widget.hari;
    _read();
    //print(listJadwal);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.grey[800],
              title: Center(
                child: Text('Set Time'),
              )),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.grey,
              onPressed: () {
                // print(listJadwal.length);
                // print(listJadwal.first.isEmpty);
                _editButtonSheet(context);
              }),
          body: Container(
            child: Column(
              children: [
                (listJadwal == null) ? 
                Container()
                : 
                ListView.builder(
                        shrinkWrap: true,
                        itemCount: listJadwal.length,
                        itemBuilder: (_, index) {
                          return (listJadwal[index][hari] == null) ? Container() 
                          : Card(
                            child: Dismissible(
                              background: Container(color: Colors.red),
                              key: Key(listJadwal[index][hari].toString()),
                              onDismissed: (direction) {
                                listJadwal.removeAt(index);
                                //_simpan();
                              },
                              child: ListTile(
                                  leading: Text(listJadwal[index][hari]['jam']),
                                  trailing:
                                      Text(listJadwal[index][hari]['bel'])),
                            ),
                          );
                        }),
                        Center(
                          child: RaisedButton(
                            child: Text("Simpan"),
                            onPressed: () async {
                              //await _simpan();
                              await _save();
                              print("Sukses");
                              //_panggil();
                              //harijadwal = {jadwal };
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp(
                                //listJadwal: listJadwal,
                                )));
                          }),
                        ),
                        // Center(
                        //   child: RaisedButton(
                        //     child: Text("Get"),
                        //     onPressed: ()async{
                        //       await _read();
                        //       //_simpan();
                        //       //await _panggil();
                        //       //harijadwal = {jadwal };
                        //       // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp(
                        //       //   //listJadwal: listJadwal,
                        //       //   )));
                        //   }),
                        // )
              ],
            ),
          ),
                  
        ),
      ),
    );
  }
}
