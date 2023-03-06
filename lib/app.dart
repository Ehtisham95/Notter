import 'package:flutter/material.dart';
import 'package:notes_app/ui/notes_details/notes_details_screen.dart';
import 'package:notes_app/ui/notes_list/notes_list_screen.dart';
import 'package:notes_app/utils/localization/Constants.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MainAppState();
}

class _MainAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Notes App",
        debugShowCheckedModeBanner: false,
        theme:
            ThemeData(primarySwatch: Colors.green, canvasColor: Colors.white),
        home: getHome(context),
        routes: <String, WidgetBuilder>{
          Constants.ROUTE_ADD_NOTES: (context) => const NotesDetailsScreen(),
        });
  }

  StatefulWidget getHome(BuildContext context) {
    return const NotesListScreen();
  }
}
