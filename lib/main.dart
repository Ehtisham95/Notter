import 'package:flutter/material.dart';
import 'package:notes_app/app.dart';
import 'package:notes_app/ui/NotesListScreen.dart';
import 'package:notes_app/utils/localization/Constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Notes App",
        theme: ThemeData(primarySwatch: Colors.green, canvasColor: Colors.white),
        home: getHome(context),
        routes: <String, WidgetBuilder>{
          Constants.ROUTE_ADD_NOTES: (context) => getHome(context),
        });
  }

  StatefulWidget getHome(BuildContext context) {
    return const NotesListScreen();
  }
}
