import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as g;
import 'package:autolocksmith/Login/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  static final String _url = "https://www.ratedlocksmiths.co.uk/api/";

  Response response;
  var token;
  Dio dio = Dio();
  SharedPreferences sp;
  String header = "";
  var map = {};

  getHeader() async {
    sp = await SharedPreferences.getInstance();
    header = sp.getString("jwtToken");
    if (kDebugMode) print(header);
  }

  postData(apiUrl, body) async {
    await getHeader();
    debugPrint('$body');
    setHeaders();
    // if (kDebugMode) print(body);
    var fullUrl = _url + apiUrl;
    if (kDebugMode) print(fullUrl);

    response = await dio.post(fullUrl,
        data: body,
        options: Options(
          validateStatus: (status) => true,
          followRedirects: false,
        ));

    if (response.statusCode == 200) {
      return response.data;
    } else if (response.statusCode == 401) {
      sp.clear();
      return g.Get.off(() => Login());
    } else {
      if (kDebugMode) print(response);
      return response.data["message"];
    }
  }

  putData(apiUrl, body) async {
    await getHeader();
    setHeaders();
    if (kDebugMode) print(body);
    var fullUrl = _url + apiUrl;
    if (kDebugMode) print(fullUrl);

    response = await dio.put(fullUrl,
        data: body,
        options: Options(
          validateStatus: (status) => true,
          followRedirects: false,
        ));

    if (response.statusCode == 200) {
      return response.data;
    } else if (response.statusCode == 401) {
      sp.clear();
      return g.Get.off(() => Login());
    } else if (response.statusCode == 500) {
      return "Something went wrong. Try again after sometime";
    } else {
      if (kDebugMode) print(response);
      return response.data["message"];
    }
  }

  getData(apiUrl) async {
    await getHeader();
    setHeaders();
    var fullUrl = _url + apiUrl;
    if (kDebugMode) print(fullUrl);
    response = await dio.get(fullUrl,
        options: Options(
          validateStatus: (status) => true,
          followRedirects: false,
        ));

    if (response.statusCode == 200) {
      return response.data;
    } else if (response.statusCode == 401) {
      sp.clear();
      return g.Get.off(() => Login());
    } else {
      if (kDebugMode) print(response);
      return response.data["message"];
    }
  }

  deleteData(apiUrl) async {
    await getHeader();
    setHeaders();
    var fullUrl = _url + apiUrl;
    if (kDebugMode) print(fullUrl);
    response = await dio.delete(fullUrl,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          },
        ));

    if (response.statusCode == 200) {
      return response.data;
    } else if (response.statusCode == 401) {
      sp.clear();
      return g.Get.off(() => Login());
    } else {
      if (kDebugMode) print(response);
      return response.data["message"];
    }
  }

  setHeaders() {
    dio.options.headers = {
      'Accept': 'application/json',
      'x-api-key': '$header',
      'Content-type': 'application/json; charset=UTF-8'
    };
  }
}
