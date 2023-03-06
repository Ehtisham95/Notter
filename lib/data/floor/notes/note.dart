import 'package:floor/floor.dart';

@entity
class Note {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final String description;

  Note({this.id,required this.title,required this.description});

}
