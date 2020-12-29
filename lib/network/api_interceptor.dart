import 'package:dio/dio.dart';

class ApiInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    options.headers["Authorization"] =
        "Bearer 80c6439c95fb4f8ea3e7506f7cb635da";
    return options;
  }

  @override
  Future onResponse(Response response) async {
    // Do something with response data
    // print("response data: " + response.data.toString());
    // print("response status message : " + response.statusMessage);
    // print("respon status code: " + response.statusCode.toString());

    return response;
  }

  @override
  Future onError(DioError error) async {
    print("Error : " + error.response.toString());
    print("Error type: " + error.type.toString());
    print("Error message: " + error.message);
    return error;
  }
}
