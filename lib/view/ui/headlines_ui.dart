import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import 'package:newsapp/model/top_headlines.dart';
import 'package:random_color/random_color.dart';

class HeadlinesScreen extends StatefulWidget {
  final List<Articles> articleList;
  const HeadlinesScreen({
    Key key,
    @required this.articleList,
  }) : super(key: key);

  @override
  _HeadlinesScreenState createState() => _HeadlinesScreenState();
}

class _HeadlinesScreenState extends State<HeadlinesScreen> {
  int page = 0;
  LiquidController _liquidController;
  RandomColor _randomColor = RandomColor();
  var color;

  @override
  void initState() {
    _liquidController = LiquidController();
    color = _randomColor.randomColor();
    super.initState();
  }

  List<Widget> _getPages(List<Articles> articlesList) {
    List<Widget> widgetList = List();
    for (int i = 0; i < articlesList.length; i++) {
      widgetList.add(_buildBody(articlesList[i]));
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LiquidSwipe(
            pages: _getPages(widget.articleList),
            waveType: WaveType.liquidReveal,
            enableLoop: false,
            onPageChangeCallback: pageChangeCallBack(),
          )
        ],
      ),
    );
  }

  pageChangeCallBack() {
    setState(() {
      getColor();
    });
  }

  Color getColor() {
    setState(() {
      color = _randomColor.randomColor();
    });
    return color;
  }

  Widget _buildBody(Articles articles) {
    DateTime dateTime = DateTime.parse(articles.publishedAt);
    DateFormat formatter = DateFormat.yMMMd('en_US');
    String date = formatter.format(dateTime);

    return Container(
      color: getColor(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32)),
                        child: articles.urlToImage != null
                            ? Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(articles.urlToImage),
                              )
                            : FlutterLogo(),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Column(
                            children: [
                              Text(
                                articles.title != null ? articles.title : '',
                                style: GoogleFonts.openSans(
                                    textStyle:
                                        Theme.of(context).textTheme.headline6,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
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
                                        articles.publishedAt != null
                                            ? date
                                            : '',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  articles.content != null
                                      ? articles.content
                                      : '',
                                  style: (GoogleFonts.openSans(
                                      textStyle:
                                          Theme.of(context).textTheme.subtitle1,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18)),
                                ),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
