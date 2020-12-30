import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/model/top_headlines.dart';
import 'package:newsapp/view/ui/main_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

List<Box> boxList = [];
Future<List<Box>> _openBox() async {
  var dir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(TopHeadlinesAdapter());
  Hive.registerAdapter(ArticlesAdapter());
  Hive.registerAdapter(SourceAdapter());
  var cacheBox = await Hive.openBox("cache_box");
  var saveBox = await Hive.openBox("save_box");
  boxList.add(cacheBox);
  boxList.add(saveBox);
  return boxList;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final license =
        await rootBundle.loadString('assets/google_fonts/LICENSE.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  await _openBox();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme:
              GoogleFonts.openSansTextTheme(Theme.of(context).textTheme)),
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
