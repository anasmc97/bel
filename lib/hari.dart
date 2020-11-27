import 'package:bel/bloc/pages_bloc.dart';
import 'package:bel/dbhelper.dart';
import 'package:bel/entryform.dart';
import 'package:bel/jadwal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  String hari;
  Home(this.hari);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Jadwal> contactList;   
  String dropDownValue = "Bel Masuk";
  String hari;
  List waktufix;
  List<Map> listJadwal;
  Map jadwal;
  String time;

  @override
  void initState() {
    updateListView();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    if (contactList == null) {
      contactList = List<Jadwal>();
    }

    return WillPopScope(
      onWillPop: (){
        context.bloc<PagesBloc>().add(GoToMainPage());
        return;
      },
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[800],
          title: Text('Daftar Data-Data'),
        ),
        body: createListView(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey[800],
          child: Icon(Icons.add,),
          tooltip: 'Tambah Data',
          onPressed: () async {
            var contact = await navigateToEntryForm(context, null, widget.hari);
            if (contact.hari != "kosong") addContact(contact);
          },
        ),
      ),
    );
  }

  Future<Jadwal> navigateToEntryForm(BuildContext context, Jadwal contact, String hari) async {
    Jadwal result = await 
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return EntryForm(contact, widget.hari);
        }
      ) 
    );
    print(result.hari);
    return result;
    
  }

  ListView createListView() {

    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[350],
              child: Icon(Icons.access_alarm, color: Colors.black,),
            ),
            title: Text(this.contactList[index].jam.toString(), style: textStyle,),
            subtitle: Text(this.contactList[index].bunyi),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () {
                deleteContact(contactList[index]);
              },   
            ),
          ),
        );
      },
    );
  }
  //buat contact
  void addContact(Jadwal object) async {
    int result = await dbHelper.insert(object);
    if (result > 0) {
      updateListView();
    }
  }
    //delete contact
  void deleteContact(Jadwal object) async {
    int result = await dbHelper.delete(object.id);
    if (result > 0) {
      updateListView();
    }
  }
    //update contact
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Jadwal>> contactListFuture = dbHelper.getjadwalListbyHari(widget.hari);
      contactListFuture.then((contactList) {
        setState(() {
          this.contactList = contactList;
          this.count = contactList.length;
        });
      });
    });
  }
    

}


