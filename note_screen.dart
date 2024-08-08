// lib/note_screen1 .dart
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'note.dart';

class NoteScreen extends StatefulWidget {
  final Note? note;

  NoteScreen({this.note});

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;

  @override
  void initState() {
    super.initState();
    _title = widget.note?.title ?? '';
    _description = widget.note?.description ?? '';
  }

  _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Note note = Note(
        id: widget.note?.id,
        title: _title,
        description: _description,
      );
      if (widget.note == null) {
        await DatabaseHelper.addNote(note);
      } else {
        await DatabaseHelper.updateNote(widget.note!.id!, note);
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        backgroundColor: Colors.black45,
        foregroundColor: Colors.white,
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
        actions: [
          Icon(Icons.note),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              Divider(height: 20),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              ElevatedButton(
                onPressed: _save,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
