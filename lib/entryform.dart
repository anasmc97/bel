import 'package:bel/bloc/pages_bloc.dart';
import 'package:bel/dbhelper.dart';
import 'package:bel/jadwal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EntryForm extends StatefulWidget {
  final Jadwal jadwal;
  final String hari;

  EntryForm(this.jadwal, this.hari);

  @override
  EntryFormState createState() => EntryFormState(this.jadwal);
}
//class controller
class EntryFormState extends State<EntryForm> {
  Jadwal jadwal;

  EntryFormState(this.jadwal);

  TextEditingController hariController = TextEditingController();
  TextEditingController jamController = TextEditingController();  
  TextEditingController bunyiController = TextEditingController();  
  String dropDownValue = "Bel Masuk";
  String hari;
  String time;
  Jadwal jdwal = Jadwal("kosong", "kosong","kosong");
  DbHelper dbHelper = DbHelper();



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: (){
          Navigator.pop(context, jdwal);
          return;
        },
          child: Scaffold(
        appBar: AppBar(
          title: Text('Tambah'),
          leading: Icon(Icons.keyboard_arrow_left),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left:10.0, right:10.0),
          child: ListView(
            children: <Widget> [
              // nama
              Container(
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
                                Navigator.pop(context, jdwal);;
                              }),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Pilih Waktu"),
                          FlatButton(
                            onPressed: () {
                              DatePicker.showTimePicker(context,
                              showSecondsColumn: false,
                                  showTitleActions: true, onChanged: (date) {
                                print('change $date in time zone ' +
                                    date.timeZoneOffset.inHours.toString());
                                var waktu = date.toString();
                                var waktu1 = waktu.split(" ");
                                 var waktufix = waktu1[1].split(".");
                                 var wkt = waktufix[0].split(",");
                                 var tme = wkt[0].split(":");
                                 time = tme[0]+":"+tme[1];
                                 if(date == null){
                                   time == null;
                                 }
                                 print(time);
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
                              if(time == null){
                                print(time);
                              }else{
                                Jadwal jdwl = Jadwal(widget.hari, time,dropDownValue);
                              var ss = await dbHelper.getJadwal(widget.hari, time);
                              if(ss.length >= 1){
                                showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Tidak dapat diinput karena memiliki waktu yang sama",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  );
                                },
                              );
                              }else{
                              Navigator.pop(context, jdwl);
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
                              }
                              }
                            },
                            child: Text("Set"),
                            color: Colors.grey,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}