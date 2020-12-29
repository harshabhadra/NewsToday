import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/bloc/bloc_provider.dart';
import 'package:newsapp/bloc/home_bloc.dart';
import 'package:newsapp/model/top_headlines.dart';
import 'package:newsapp/view/ui/category_details_ui.dart';
import 'package:newsapp/view/ui/details_screen.dart';
import 'package:newsapp/view/ui/headlines_ui.dart';
import 'package:random_color/random_color.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc bloc = HomeBloc();
  RandomColor _randomColor = RandomColor();
  List<String> categoryList = [
    'business',
    'entertainment',
    'general',
    'science',
    'sports',
    'technology'
  ];
  String today;

  ScrollController _scrollController;
  bool _showAppBar = true;
  bool _isScrollingDown = false;
  @override
  void initState() {
    final now = DateTime.now();
    today = new DateFormat.yMMMMd('en_US').format(now);

    bloc.getTopHeadlines();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!_isScrollingDown) {
          setState(() {
            _isScrollingDown = true;
            _showAppBar = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_isScrollingDown) {
          setState(() {
            _isScrollingDown = false;
            _showAppBar = true;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  //Go to details screen
  void _goToDetailsScreen(Articles articles, String tag) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return DetailsScreen(
        articles: articles,
        tagName: tag,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocProvider(
          bloc: bloc,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      today,
                      style: GoogleFonts.openSans(
                          textStyle: Theme.of(context).textTheme.headline5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  _buildNewsLists(bloc)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewsLists(HomeBloc bloc) {
    Map<String, dynamic> map = Map();
    return StreamBuilder(
        stream: bloc.headlinesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              map = snapshot.data;
              if (map.containsKey('top_headlines')) {
                TopHeadlines topHeadlines = map['top_headlines'];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text('Top Headlines',
                              style: GoogleFonts.openSans(
                                  textStyle:
                                      Theme.of(context).textTheme.headline5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return HeadlinesScreen(
                                    articleList: topHeadlines.articles);
                              }));
                            },
                            child: Text('See All',
                                style: GoogleFonts.openSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          )
                        ],
                      ),
                    ),
                    _buildHeadLinesList(topHeadlines),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: Text('Categories',
                          style: GoogleFonts.openSans(
                              textStyle: Theme.of(context).textTheme.headline5,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                    ),
                    _buildCategoryList(topHeadlines.articles),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: Text('Top Articles',
                          style: GoogleFonts.openSans(
                              textStyle: Theme.of(context).textTheme.headline5,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                    ),
                    _buildArticleList(topHeadlines.articles)
                  ],
                );
              } else {
                String error = map['error'];
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(error),
                  ),
                );
              }
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  Widget _buildHeadLinesList(TopHeadlines topHeadlines) {
    List<Articles> headlinesList = topHeadlines.articles;
    print("No. of headlines: " + headlinesList.length.toString());
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      height: 240.0,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: headlinesList.length < 50 ? headlinesList.length : 50,
          itemBuilder: (context, index) {
            Articles articles = headlinesList[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: GestureDetector(
                onTap: () {
                  _goToDetailsScreen(articles, 'image$index');
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  elevation: 6.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: articles.urlToImage != null
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Stack(fit: StackFit.expand, children: [
                              Hero(
                                tag: 'image$index',
                                child: Image(
                                  image: NetworkImage(articles.urlToImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    articles.title,
                                    style: TextStyle(
                                        color: Colors.white,
                                        backgroundColor: Colors.black),
                                  ),
                                ),
                              )
                            ]),
                          )
                        : Container(
                            color: _randomColor.randomColor(
                                colorBrightness: ColorBrightness.dark,
                                colorSaturation: ColorSaturation.lowSaturation),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  articles.title,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildCategoryList(List<Articles> articles) {
    return AnimationLimiter(
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        children: List.generate(categoryList.length, (index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(seconds: 1),
            columnCount: 3,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return CategoryScreen(
                          articleList: articles,
                          position: index,
                        );
                      }));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      child: Container(
                        color: _randomColor.randomColor(
                          colorBrightness: ColorBrightness.dark,
                          colorSaturation: ColorSaturation.mediumSaturation,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              categoryList[index].toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
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

  Widget _buildArticleList(List<Articles> articleList) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: articleList.length,
        itemBuilder: (context, index) {
          Articles articles = articleList[index];
          return GestureDetector(
            onTap: () {
              _goToDetailsScreen(articles, 'image$index');
            },
            child: Card(
              child: Container(
                margin: EdgeInsets.all(8),
                height: 200.0,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: articles.urlToImage != null
                                    ? NetworkImage(articles.urlToImage)
                                    : NetworkImage(articleList[0].urlToImage),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                articles.title,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  articles.source.name,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
