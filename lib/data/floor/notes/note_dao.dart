// notes/note_dao.dart

import 'dart:async';

import 'package:floor/floor.dart';

import 'note.dart';

@dao
abstract class NoteDao {
  @Query('SELECT * FROM Note')
  Future<List<Note>> findAllNotes();

  @Query('SELECT * FROM Note WHERE id = :id')
  Future<Note?> findNoteById(int id);

  @insert
  Future<void> insertNote(Note note);
}
