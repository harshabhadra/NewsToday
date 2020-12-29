import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/view/ui/collection_ui.dart';
import 'package:newsapp/view/ui/home_screen_ui.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'News Today',
              style: GoogleFonts.openSans(
                  textStyle: Theme.of(context).textTheme.headline5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            backgroundColor: Colors.white,
            leading: Icon(Icons.pages_outlined, color: Colors.black),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.account_circle_outlined,
                  color: Colors.black,
                ),
              ),
            ],
            bottom: TabBar(tabs: [
              Tab(
                child: Text(
                  'Home',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  'Saved',
                  style: TextStyle(color: Colors.black),
                ),
              )
            ]),
          ),
          body: TabBarView(
            children: [HomeScreen(), CollectionScreen()],
          )),
    );
  }
}
