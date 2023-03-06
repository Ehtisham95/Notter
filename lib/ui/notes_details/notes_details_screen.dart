import 'package:flutter/material.dart';
import 'package:notes_app/data/floor/notes/note.dart';
import 'package:notes_app/data/repositories/note_repository.dart';

class NotesDetailsScreen extends StatefulWidget {
  const NotesDetailsScreen({super.key});

  @override
  State<NotesDetailsScreen> createState() => _NotesDetailsState();
}

class _NotesDetailsState extends State<NotesDetailsScreen> {
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    final id = ModalRoute.of(context)?.settings.arguments as int?;
    final Note? note = getNote(id);
    String title = "";
    String description = "";

    return Scaffold(
        appBar: AppBar(
          title: Text((id == null) ? "Add Note" : "New Note"),
          actions: [
            MaterialButton(
              onPressed: () async {
                if (title.isNotEmpty && description.isNotEmpty) {
                  await saveNote(title, description);
                  createSnackBar("Note added successfully!");
                  if (context.mounted) Navigator.pop(context);
                }
              },
              textColor: Colors.white,
              child: Text((id == null) ? "Save" : "Done"),
            )
          ],
        ),
        body: (note != null)
            ? Column(children: [Text(note.title), Text(note.description)])
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      onChanged: (newTitle) {
                        title = newTitle;
                      },
                      decoration: const InputDecoration(hintText: "Add Title"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
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
  }

  Note? getNote(int? id) {
    if (id != null) {
      return Note(id: 1, title: "Title", description: "Description");
    }
    return null;
  }

  Future<void> saveNote(String title, String description) async {
    final noteRepo = await NoteRepository.createInstance();
    await noteRepo.insertNote(Note(title: title, description: description));
  }

  void createSnackBar(String message) {
    if (context.mounted) {
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
