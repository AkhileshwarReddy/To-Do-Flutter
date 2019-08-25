import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todo/db_helper.dart';
import '../note.dart';
import 'note_details.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DBHelper dbHelper = DBHelper();
  int count = 0;
  List<Note> noteList = List<Note>();

  @override
  Widget build(BuildContext context) {
    if(noteList == null){
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("To - Do"),
        backgroundColor: Colors.purple,
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
        onPressed: (){
          navigatoToDetail(Note('','',2), "Add  Note");
        },
      ),
    );
  }

  void navigatoToDetail(Note note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(
      builder: (context){
        return NoteDetail(note, title);
      }
    ));

    if(result == true){
      updateListView();
    }
  }

  void updateListView(){
    final Future<Database> dbFuture = dbHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Note>> noteListFuture = dbHelper.getNoteList();
      noteListFuture.then((noteList){
        setState((){
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  ListView getNoteListView(){
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, position){
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.deepPurple,
          elevation: 4.0,
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(this.noteList[position].title,
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),),
            subtitle: Text(this.noteList[position].date,
            style: TextStyle(
              color: Colors.white
            ),),
            trailing: GestureDetector(
              child: Icon(Icons.open_in_new,
              color: Colors.white),
              onTap: (){navigatoToDetail(this.noteList[position], 'Edit To-Do');},
            ),
          ),
        );
      },
    );
  }
}