import 'package:autolocksmith/Login/Login.dart';
import 'package:dio/dio.dart' as d;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  static final String _url = "https://www.autolocksmiths.com/appwebservices/";

  d.Response response;
  var token;
  d.Dio dio = d.Dio();
  SharedPreferences sp;
  String header = "";
  var map = {};

  getHeader() async {
    sp = await SharedPreferences.getInstance();
    header = sp.getString("jwtToken");
    print(header);
  }

  postData(apiUrl) async {
    await getHeader();
    setHeaders();
    print(map);
    var fullUrl = _url + apiUrl;
    print(fullUrl);

    response = await dio.post(fullUrl);

    if (response.data["responce"] != null) {
      sp.clear();
      return Get.off(() => Login());
    } else
      return response.data;
  }

  getData(apiUrl) async {
    await getHeader();
    setHeaders();
    var fullUrl = _url + apiUrl;
    print(fullUrl);
    response = await dio.get(
      fullUrl,
    );

    if (response.data["responce"] != null) {
      sp.clear();
      return Get.off(() => Login());
    } else
      return response.data;
  }

  setHeaders() {
    dio.options.headers = {'Authorizationtoken': 'Basic:$header'};
  }
}
