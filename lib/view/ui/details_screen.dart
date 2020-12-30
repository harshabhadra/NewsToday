import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'package:newsapp/model/top_headlines.dart';

class DetailsScreen extends StatefulWidget {
  final Articles articles;
  final String tagName;

  const DetailsScreen({
    Key key,
    @required this.articles,
    @required this.tagName,
  }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Articles articles;
  bool isSaved;
  Box box;
  int position;
  List<Articles> fList = new List();
  String date;

  @override
  void initState() {
    articles = widget.articles;
    box = Hive.box('save_box');
    if (box.isNotEmpty) {
      List<Articles> list = List<Articles>();
      box.values.forEach((element) {
        list.add(element);
      });
      print('list size: ' + list.length.toString());
      for (int i = 0; i < list.length; i++) {
        if (list[i].title == articles.title) {
          fList.add(list[i]);
          position = i;
        }
      }
      if (fList.isNotEmpty) {
        print('list contain article');
        isSaved = true;
      } else {
        print('list donot have article');
        isSaved = false;
        position = -1;
      }
    } else {
      isSaved = false;
      position = -1;
    }

    DateTime dateTime = DateTime.parse(articles.publishedAt);
    DateFormat formatter = DateFormat.yMMMd('en_US');
    date = formatter.format(dateTime);

    super.initState();
  }

  Future<void> _saveToCollection(Articles articles) {
    print('adding to collection');
    box.add(articles);

    setState(() {
      isSaved = true;
      position = box.length - 1;
    });
  }

  Future<void> _removeFromCollection(Articles articles) {
    print('removing from collection');
    box.deleteAt(position);
    setState(() {
      isSaved = false;
      position = box.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          isSaved
              ? _removeFromCollection(articles)
              : _saveToCollection(articles);
        },
        backgroundColor: Colors.black,
        child: isSaved
            ? Icon(Icons.bookmark)
            : Icon(Icons.bookmark_border_outlined),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(45),
                    bottomRight: Radius.circular(45)),
                child: Hero(
                  tag: widget.tagName,
                  child: Image(
                      fit: BoxFit.cover,
                      image: articles.urlToImage != null
                          ? NetworkImage(articles.urlToImage)
                          : FlutterLogo()),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      articles.title != null ? articles.title : '',
                      style: GoogleFonts.openSans(
                          textStyle: Theme.of(context).textTheme.headline6,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            articles.source.name != null
                                ? articles.source.name
                                : '',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Flexible(
                            flex: 2,
                            child: Text(
                              articles.publishedAt != null ? date : '',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          articles.content != null ? articles.content : '',
                          style: (GoogleFonts.openSans(
                              textStyle: Theme.of(context).textTheme.subtitle1,
                              fontWeight: FontWeight.w500,
                              fontSize: 18)),
                        ),
                      ),
                    )
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
