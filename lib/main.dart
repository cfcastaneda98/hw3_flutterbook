import "dart:io";
import 'package:flutter/material.dart';
import "package:path_provider/path_provider.dart";
import "appointments/Appointments.dart";
import 'contacts/Contacts.dart';
import 'notes/Notes.dart';
import 'tasks/Tasks.dart';
import 'Recorder/Recorder.dart';
import 'utils.dart' as utils;

Future<void> main() async {
  startMeUp() async {
    WidgetsFlutterBinding.ensureInitialized();
    Directory docsDir =
        await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;

    runApp(FlutterBook());
  }

  startMeUp();
}

class FlutterBook extends StatelessWidget {
  Widget build(BuildContext inContext) {
    return MaterialApp(
      title: 'Flutter book',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.dark(),
        appBarTheme: AppBarTheme(backgroundColor: Colors.blueGrey),
        secondaryHeaderColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("HW3 - FlutterBook"),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.date_range),
                  text: "Appointments",
                ),
                Tab(
                  icon: Icon(Icons.contacts),
                  text: "Contacts",
                ),
                Tab(
                  icon: Icon(Icons.note),
                  text: "Notes",
                ),
                Tab(
                  icon: Icon(Icons.assignment_turned_in),
                  text: "Tasks",
                ),
                Tab(
                  icon: Icon(Icons.mic_outlined),
                  text: "Recorder",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Appointments(),
              Contacts(),
              Notes(),
              Tasks(),
              Recorder(),
            ],
          ),
        ),
      ),
    );
  }
}
