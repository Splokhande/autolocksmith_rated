import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LeadsDetail with ChangeNotifier {
  String? vehicleType;
  String? vehicleLocation;
  String? vehicleReg;
  String? makeOfVehicle;
  String? modelVehicle;
  String? damageWindow;
  String? additionInfo;
  String? whoPay;
  String? windowHeated;
  String? yearVehicle;
  String? carDamagePhoto;
  String? preferDate;
  String? customerName;
  String? phone;
  String? email;
  String? quoteDetails;
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? needed;

  LeadsDetail({
    this.vehicleType,
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
    this.email,
    this.quoteDetails,
    this.image1,
    this.image2,
    this.image3,
    this.image4,
  });

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
        windowHeated: json["windowheated"],
        yearVehicle: json["year_vehicle"],
        carDamagePhoto: json["car_damage_photo"],
        preferDate: json["preffer_date"],
        customerName: json["customer_name"],
        phone: json["phone"],
        email: json["email"],
        image1: json["image1"],
        image2: json["image2"],
        image3: json["image3"],
        image4: json["image4"],
        needed: json["needed"],
        quoteDetails: json["quote_details"]);
  }
}
