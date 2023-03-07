import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes_app/data/repositories/note_repository.dart';
import 'package:notes_app/utils/localization/Constants.dart';

import '../../data/floor/notes/note.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesList();
}

class _NotesList extends State<NotesListScreen> {
  List<int> listIds = [];
  List<Widget> widgets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: _notesListView(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            navigateToDetailsScreen(null);
          },
          label: const Text("Add"),
          icon: const Icon(Icons.add),
        ));
  }

  FutureBuilder<List<Widget>> _notesListView() {
    return FutureBuilder(
        future: getList(),
        builder: (BuildContext context, AsyncSnapshot<List<Widget>> widget) {
          if (widgets.isNotEmpty) {
            return ListView(children: widget.requireData);
          } else {
            return Center(
                child: Text("No Notes available",
                    style: Theme.of(context).textTheme.titleLarge));
          }
        });
  }

  void _refreshList() {
    setState(() {
      listIds.clear();
      widgets.clear();
    });
  }

  void navigateToDetailsScreen(Object? args) {
    Navigator.of(context)
        .pushNamed(Constants.ROUTE_ADD_NOTES, arguments: args)
        .then((value) {
      _refreshList();
    });
  }

  Future<List<Widget>> getList() async {
    final notesRepo = await NoteRepository.createInstance();
    final list = await notesRepo.getNotes();
    if (list.isNotEmpty) {
      for (final note in list) {
        if (!listIds.contains(note.id)) {
          listIds.add(note.id!);
          widgets.add(NoteListItem(
            title: note.title,
            description: note.description,
            onLongPressed: () {
              deleteNote(note);
            },
            returnNote: () {
              navigateToDetailsScreen(note.id);
            },
          ));
        }
      }
    }
    return widgets;
  }

  Future<void> deleteNote(Note note) async {
    showDeleteDialog(context, () async {
      final notesRepo = await NoteRepository.createInstance();
      await notesRepo.deleteNote(note);
      _refreshList();
    });
  }

  showDeleteDialog(BuildContext context, void Function() onDelete) {
    // set up the button
    Widget okButton = TextButton(
      onPressed: () {
        onDelete();
        Navigator.of(context).pop();
      },
      child: const Text("Yes"),
    );

    Widget cancelButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("No"),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete"),
      content: const Text("Do you really want to delete this note?"),
      actions: [okButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class NoteListItem extends StatelessWidget {
  final String title;
  final String description;
  final Function() returnNote;
  final Function() onLongPressed;

  const NoteListItem(
      {super.key,
      required this.title,
      required this.description,
      required this.returnNote,
      required this.onLongPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: returnNote,
            onLongPress: onLongPressed,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          GestureDetector(
            onTap: returnNote,
            onLongPress: onLongPressed,
            child:
                Text(description, style: Theme.of(context).textTheme.bodyLarge),
          ),
          const Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
