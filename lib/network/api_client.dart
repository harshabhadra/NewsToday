import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'api_interceptor.dart';
part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio) {
    dio.options = BaseOptions(receiveTimeout: 50000, connectTimeout: 50000);
    dio.interceptors.add(ApiInterceptor());
    return _ApiClient(dio, baseUrl: "https://newsapi.org/v2");
  }

  @GET("/top-headlines")
  Future<HttpResponse<String>> getTopHeadLines(
    @Query('country') String country,
    @Query('pageSize') int pageSize,
    @Query('page') int page
    
    );
}
