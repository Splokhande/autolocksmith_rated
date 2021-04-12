import 'package:http/http.dart' as http;

class API{

  static final String _url = "https://www.autolocksmiths.com/appwebservices/";

  var token;
  postData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(
      Uri.parse(fullUrl)
    );
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(
      Uri.parse(fullUrl),
      // headers: _setHeaders(),
    );
  }


  // _setHeaders() => {
  //   'Content-type': 'application/json',
  //   'Accept': 'application/json',
  // };


}
