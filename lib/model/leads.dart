import 'package:autolocksmith/API/api.dart';
import 'package:autolocksmith/model/User.dart';
import 'package:autolocksmith/widgets/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Lead with ChangeNotifier {
  String leadStatus;
  String acquid;
  String added_date;
  String uniquecode;
  String username;
  String address;
  String vehicle_type;
  String repliedbyagent;
  String repliedbyagent_date;
  List<Lead> leadList = [];

  Lead(
      {this.leadStatus,
      this.acquid,
      this.address,
      this.added_date,
      this.uniquecode,
      this.username,
      this.vehicle_type,
      this.repliedbyagent,
      this.repliedbyagent_date});

  factory Lead.fromMap(Map<String, dynamic> json) {
    return Lead(
      acquid: json["acquid"],
      added_date: json["added_date"],
      leadStatus: json["leadstatus"],
      repliedbyagent: json["repliedbyagent"],
      repliedbyagent_date: json["repliedbyagent_date"],
      uniquecode: json["uniquecode"],
      username: json["username"],
      address: json["address"],
      vehicle_type: json["vehicle_type"],
    );
  }

  Future<List<Lead>> getLeadsCount() async {
    Shop shop = Shop();
    shop = await shop.fromSharedPreference();
    SharedPreferences sp = await SharedPreferences.getInstance();
    API api = API();
    Connection connection = Connection();
    connection.check();
    leadList.clear();
    var body = await api.postData("getleads.php?shop_id=${shop.id}");

    for (int i = 0; i < body["leads"].length; i++) {
      Lead lead = Lead.fromMap(body["leads"][i]);
      if (lead.leadStatus != null) {
        if (lead.leadStatus == "new-lead") {
          leadList.add(lead);
          notifyListeners();
        }
      }
    }
    sp.setInt("count", leadList.length);

    return leadList;
  }
}

class LeadsDetail with ChangeNotifier {
  String vehicleType = "";
  String vehicleLocation = "";
  String vehicleReg = "";
  String makeOfVehicle = "";
  String modelVehicle = "";
  String damageWindow = "";
  String additionInfo = "";
  String whoPay = "";
  String insuranceName = "";
  String needed = "";
  String windowHeated = "";
  String yearVehicle = "";
  String carDamagePhoto = "";
  String preferDate = "";
  String customerName = "";
  String phone = "";
  String email = "";
  String quoteDetails = "";

  LeadsDetail(
      {this.vehicleType,
      this.vehicleLocation,
      this.vehicleReg,
      this.makeOfVehicle,
      this.modelVehicle,
      this.damageWindow,
      this.additionInfo,
      this.whoPay,
      this.windowHeated,
      this.yearVehicle,
      this.carDamagePhoto,
      this.preferDate,
      this.customerName,
      this.phone,
      this.needed,
      this.insuranceName,
      this.email,
      this.quoteDetails});

  factory LeadsDetail.fromMap(Map<String, dynamic> json) {
    return LeadsDetail(
        vehicleType: json["Vehicle_type"],
        vehicleLocation: json["Vehicle_location"],
        vehicleReg: json["Vehicle_reg"],
        makeOfVehicle: json["make_of_vehicle"],
        modelVehicle: json["model_vehicle"],
        damageWindow: json["damage_windows"],
        additionInfo: json["additonal_info"],
        whoPay: json["who_pay"],
        insuranceName: json["insurance_name"],
        windowHeated: json["windowheated"],
        yearVehicle: json["year_vehicle"],
        carDamagePhoto: json["car_damage_photo"],
        preferDate: json["preffer_date"],
        customerName: json["customer_name"],
        phone: json["phone"],
        email: json["email"],
        needed: json["needed"],
        quoteDetails: json["quote_details"]);
  }
}
