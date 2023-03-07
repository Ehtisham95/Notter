import 'package:flutter/material.dart';
import 'package:notes_app/data/floor/notes/note.dart';
import 'package:notes_app/data/repositories/note_repository.dart';

class NotesDetailsScreen extends StatefulWidget {
  const NotesDetailsScreen({super.key});

  @override
  State<NotesDetailsScreen> createState() => _NotesDetailsState();
}

class _NotesDetailsState extends State<NotesDetailsScreen> {
  String title = "";
  String description = "";
  int? id;
  Note? note;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: evaluateNote(),
        builder: (BuildContext context, AsyncSnapshot<Note?> returnedNote) {
          return Scaffold(
              appBar: AppBar(
                title: Text((id == null) ? "Add Note" : "Update Note"),
                actions: [
                  MaterialButton(
                    onPressed: () async {
                      if (id == null &&
                          title.isNotEmpty &&
                          description.isNotEmpty) {
                        await saveNote(title, description);
                        createSnackBar("Note added successfully!");
                        if (context.mounted) Navigator.pop(context);
                      } else if (id != null &&
                          title.isNotEmpty &&
                          description.isNotEmpty) {
                        await updateNote(title, description);
                        createSnackBar("Note updated successfully!");
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                    textColor: Colors.white,
                    child: Text((id == null) ? "Save" : "Done"),
                  )
                ],
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: TextEditingController()..text = title,
                      onChanged: (newTitle) {
                        title = newTitle;
                      },
                      decoration: const InputDecoration(hintText: "Add Title"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: TextEditingController()..text = description,
                      onChanged: (newDesc) {
                        description = newDesc;
                      },
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "Add Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                ],
              ));
        });
  }

  Future<Note?> evaluateNote() async {
    id = ModalRoute.of(context)?.settings.arguments as int?;
    note = await getNote(id);
    title = (note != null) ? note!.title : "";
    description = (note != null) ? note!.description : "";
    return note;
  }

  Future<Note?> getNote(int? id) async {
    if (id != null) {
      final db = await NoteRepository.createInstance();
      final note = await db.getNote(id);
      return note;
    }
    return null;
  }

  Future<void> saveNote(String title, String description) async {
    final noteRepo = await NoteRepository.createInstance();
    await noteRepo.insertNote(Note(title: title, description: description));
  }

  Future<void> updateNote(String title, String description) async {
    final noteRepo = await NoteRepository.createInstance();
    await noteRepo
        .updateNote(Note(id: id, title: title, description: description));
  }

  void createSnackBar(String message) {
    if (context.mounted) {
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
