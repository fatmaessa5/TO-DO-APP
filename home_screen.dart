// lib/home_screen.dart
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'note.dart';
import 'note_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Note>?> _notes;

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  _refreshNotes() {
    setState(() {
      _notes = DatabaseHelper.getNotes();
    });
  }

  _delete(int id) async {
    await DatabaseHelper.deleteNote(id);
    _refreshNotes();
  }

  _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Note'),
          content: Text('Are you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _delete(id);
                Navigator.pop(context);
                setState(() {});
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        title: Text('To Do List'),
        actions: [
          Icon(Icons.note_alt_rounded,size: 30,)
        ],
        backgroundColor: Colors.blueAccent[50],
        foregroundColor: Colors.teal[900],
      ),
      body: FutureBuilder<List<Note>?>(
        future: _notes,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text("NO AVAILABLE NOTE"));
          }
          // if (snapshot.data == null || snapshot.data!.isEmpty) {
          //   return Center(child: Text('No notes available.'));
          // }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Note note = snapshot.data![index];
              return ListTile(
                title: Text(note.title ?? ''),
                subtitle: Text(note.description ?? ''),
                onTap: () async {
                  bool? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteScreen(note: note),
                    ),
                  );
                  if (result == true) {
                    _refreshNotes();
                  }
                },
                onLongPress: () => _showDeleteDialog(note.id!),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteScreen(),
            ),
          );
          if (result == true) {
            _refreshNotes();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
