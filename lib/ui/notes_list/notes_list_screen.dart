import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes_app/data/repositories/note_repository.dart';
import 'package:notes_app/utils/localization/Constants.dart';

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
            Navigator.of(context)
                .pushNamed(Constants.ROUTE_ADD_NOTES)
                .then((value) {
              _refreshList();
            });
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
            return const Center(child: Text("No Notes available"));
          }
        });
  }

  void _refreshList() {
    setState(() {});
  }

  Future<List<Widget>> getList() async {
    final notesRepo = await NoteRepository.createInstance();
    final list = await notesRepo.getNotes();
    if (list.isNotEmpty) {
      for (final note in list) {
        if (!listIds.contains(note.id)) {
          listIds.add(note.id!);
          widgets.add(
              NoteListItem(title: note.title, description: note.description));
        }
      }
    }
    return widgets;
  }
}

class NoteListItem extends StatelessWidget {
  final String title;
  final String description;

  const NoteListItem(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(description, style: Theme.of(context).textTheme.bodyLarge),
          const Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
