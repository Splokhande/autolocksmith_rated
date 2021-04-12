
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Connection{
  Future<bool> check() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool internet = sp.getBool("internet") ?? false;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if(!internet){
        sp.setBool("internet", true);
          // ShowToast.show("We are back", context);
      }
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if(!internet){
        sp.setBool("internet", true);
        // ShowToast.show("We are back", context);
      }
      return true;
    }
    sp.setBool("internet", false);
    // ShowToast.show("No Internet connection", context);
    return false;
  }
}