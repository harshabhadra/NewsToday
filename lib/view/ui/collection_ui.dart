import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';
import 'package:newsapp/model/top_headlines.dart';
import 'package:newsapp/view/ui/details_screen.dart';

class CollectionScreen extends StatefulWidget {
  CollectionScreen({Key key}) : super(key: key);

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  List<Articles> articleList = List<Articles>();
  @override
  void initState() {
    var box = Hive.box("save_box");
    if (box.isNotEmpty) {
      print('collection size: ' + box.length.toString());
      for (int i = 0; i < box.length; i++) {
        articleList.add(box.getAt(i));
      }
    } else {
      print('collection is empty');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: articleList.isEmpty
          ? Container(
              child: Center(
                child: Text('No Data to show'),
              ),
            )
          : _buildCollectionList(),
    );
  }

  Widget _buildCollectionList() {
    return AnimationLimiter(
      child: ListView.separated(
          itemBuilder: (context, index) {
            Articles article = articleList[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(seconds: 1),
              child: SlideAnimation(
                verticalOffset: 100.0,
                child: FadeInAnimation(
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
                    child: Expanded(
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
                                    fontSize: 18, fontWeight: FontWeight.w600),
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
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.black,
              height: 1.0,
            );
          },
          itemCount: articleList.length),
    );
  }
}
