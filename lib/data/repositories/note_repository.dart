import 'dart:async';

import 'package:notes_app/data/floor/database.dart';
import 'package:notes_app/data/floor/notes/note.dart';

class NoteRepository {
  final AppDatabase _appDatabase;
  static NoteRepository? _instance;

  NoteRepository._(this._appDatabase);

  static Future<NoteRepository> createInstance() async {
    _instance ??= NoteRepository._(
          await $FloorAppDatabase.databaseBuilder('app_database.db')
              .build());
    return _instance!;
  }

  Future<List<Note>> getNotes() {
    return _appDatabase.notesDao.findAllNotes();
  }

  Future<Note?> getNote(int id) async {
    return await _appDatabase.notesDao.findNoteById(id);
  }

  Future<void> insertNote(Note note) async {
    return await _appDatabase.notesDao.insertNote(note);
  }

}
