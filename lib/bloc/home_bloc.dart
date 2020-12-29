import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:newsapp/bloc/bloc.dart';
import 'package:newsapp/model/top_headlines.dart';
import 'package:newsapp/network/api_client.dart';

class HomeBloc extends Bloc {
  final StreamController<dynamic> _controller = StreamController.broadcast();
  Map<String, dynamic> responseMap = Map<String, dynamic>();
  Stream<dynamic> get headlinesStream => _controller.stream;

  void getTopHeadlines() async {
    Dio dio = Dio();
    ApiClient _apiClient = ApiClient(dio);
    TopHeadlines topHeadlines;
    var cacheBox = Hive.box('cache_box');

    if (cacheBox.isNotEmpty) {
      print('box length: ${cacheBox.length}');
      topHeadlines = cacheBox.get('top');
      print('box articles no. : ${topHeadlines.articles.length}');
      responseMap['top_headlines'] = topHeadlines;
      _controller.sink.add(responseMap);
    } else {
      print('box is empty');
    }

    try {
      var response = await _apiClient.getTopHeadLines('in', 100, 1);
      Map<String, dynamic> map = jsonDecode(response.data);
      if (map.containsKey('status')) {
        String status = map['status'];
        if (status == 'ok') {
          topHeadlines = TopHeadlines.fromJson(map);
          cacheBox.delete('top');
          cacheBox.put('top', topHeadlines);
          responseMap['top_headlines'] = topHeadlines;
        } else if (status == 'error') {
          String message = map['message'];
          responseMap['error'] = message;
        }
        _controller.sink.add(responseMap);
      }
    } on Exception catch (e) {
      print('Error fetching headlines: ' + e.toString());
      responseMap['error'] = e.toString();
      _controller.sink.add(responseMap);
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}
