import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/model/top_headlines.dart';
import 'package:newsapp/view/ui/details_screen.dart';

class CategoryScreen extends StatefulWidget {
  final List<Articles> articleList;
  final int position;
  const CategoryScreen({Key key, this.articleList, this.position})
      : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<String> categoryList = [
    'business',
    'entertainment',
    'general',
    'science',
    'sports',
    'technology'
  ];

  List<Widget> _widgetList = List<Widget>();
  int index;

  @override
  void initState() {
    _widgetList = _getWidgets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categoryList.length,
      initialIndex: widget.position,
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
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          bottom: TabBar(
            isScrollable: true,
            tabs: List.generate(categoryList.length, (index) {
              return Tab(
                child: Text(
                  categoryList[index].toUpperCase(),
                  style: TextStyle(color: Colors.black),
                ),
              );
            }),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(children: _widgetList),
        ),
      ),
    );
  }

  List<Widget> _getWidgets() {
    _widgetList.clear();
    for (int i = 0; i < categoryList.length; i++) {
      _widgetList.add(_buildContent());
    }
    return _widgetList;
  }

  Widget _buildContent() {
    List<Articles> articles = widget.articleList;
    print('no. of articles: ${articles.length}');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimationLimiter(
        child: ListView.separated(
            itemCount: widget.articleList.length,
            separatorBuilder: (context, index) {
              return Divider(height: 1.0, color: Colors.grey);
            },
            itemBuilder: (context, index) {
              Articles article = widget.articleList[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(seconds: 1),
                child: SlideAnimation(
                  verticalOffset: 100.0,
                  child: FadeInAnimation(
                    child: Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return DetailsScreen(
                              articles: article,
                              tagName: 'image$index',
                            );
                          }));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Hero(
                                tag: 'image$index',
                                child: Image(
                                  fit: BoxFit.cover,
                                  image: article.urlToImage != null
                                      ? NetworkImage(article.urlToImage)
                                      : FlutterLogo(),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  article.title != null ? article.title : '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
