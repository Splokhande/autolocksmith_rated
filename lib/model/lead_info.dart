import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:autolocksmith/API/api.dart';
import 'package:autolocksmith/widgets/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

DateFormat format = DateFormat("MM-dd-yyyy");

class Lead extends ChangeNotifier {
  int quoteRequestId;
  int id;
  String quote;
  String quoteSendAt;
  String name;
  String email;
  String telephoneNo;
  String createdDate;
  String mapLocation;
  String zipcode;
  List<Lead> leadList = [];
  Lead(
      {this.quoteRequestId,
      this.id,
      this.quote,
      this.email,
      this.telephoneNo,
      this.name,
      this.createdDate,
      this.quoteSendAt});

  Lead.fromJson(Map<String, dynamic> json) {
    quoteRequestId = json['quote_request_id'];
    id = json["lead_id"] == null ? json['id'] : json['lead_id'];
    quote = json['quote'] ?? "";
    email = json["email"] ?? "";
    name = json["name"] ?? "";
    createdDate = json["created_at"] != null
        ? DateFormat("MM-dd-yyyy")
            .format(DateTime.parse(json["created_at"].toString().split('T')[0]))
        : "";
    quoteSendAt = json["quote_send_at"] ?? "";
    telephoneNo = json["telephone_no"] ?? "";
    mapLocation = json["map_location"] ?? "";
    zipcode = json["zipcode"] ?? "";
  }

  Future<List<Lead>> getLeadsCount(context) async {
    // shop = await shop.fromSharedPreference();
    SharedPreferences sp = await SharedPreferences.getInstance();
    API api = API();
    Connection connection = Connection();
    await connection.check();
    leadList.clear();
    var body = await api.getData("leads/");
    if (body != null && body != "{}")
      for (int i = 0; i < body.length; i++) {
        Lead lead = Lead.fromJson(body[i]);
        if (lead.quoteSendAt == "") {
          leadList.add(lead);
          notifyListeners();
        }
      }
    sp.setInt("count", leadList.length);

    return leadList;
  }
}

class LeadInfo {
  Quote quote;
  Hauler hauler;
  Lead lead;

  LeadInfo({this.quote, this.hauler, this.lead});

  LeadInfo.fromJson(Map<String, dynamic> json) {
    quote = json['quote'] != null ? new Quote.fromJson(json['quote']) : null;
    hauler =
        json['hauler'] != null ? new Hauler.fromJson(json['hauler']) : null;
    lead = json['lead'] != null ? new Lead.fromJson(json['lead']) : null;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.quote != null) {
  //     data['quote'] = this.quote.toJson();
  //   }
  //   if (this.hauler != null) {
  //     data['hauler'] = this.hauler.toJson();
  //   }
  //   if (this.lead != null) {
  //     data['lead'] = this.lead.toJson();
  //   }
  //   return data;
  // }
}

class Quote {
  int id;
  String name;
  String telephoneNo;
  String email;
  String schedule;
  String moreInfo;
  List<String> listItems;
  String imageIds;
  String zipcode;
  String mapLocation;
  String latitude;
  String longitude;
  String token;
  String ipaddress;
  String browser;
  String reviewMailSentAt;
  String isDeleted;
  String createdAt;
  String updatedAt;
  List<Images> imageList;

  Quote(
      {this.id,
      this.name,
      this.telephoneNo,
      this.email,
      this.schedule,
      this.moreInfo,
      this.listItems,
      this.imageIds,
      this.zipcode,
      this.mapLocation,
      this.latitude,
      this.longitude,
      this.token,
      this.ipaddress,
      this.browser,
      this.reviewMailSentAt,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.imageList});

  Quote.fromJson(Map<String, dynamic> json) {
    List<Images> list = [];
    for (int i = 0; i < json["images"].length; i++) {
      list.add(Images.fromJson(json["images"][i]));
    }

    id = json['id'];
    name = json['name'];
    telephoneNo = json['telephone_no'];
    email = json['email'];
    schedule = json['schedule'];
    moreInfo = json['more_info'];
    listItems = json['list_items'];
    imageIds = json['image_ids'];
    zipcode = json['zipcode'];
    mapLocation = json['map_location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    token = json['token'];
    ipaddress = json['ipaddress'];
    browser = json['browser'];
    reviewMailSentAt = json['review_mail_sent_at'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageList = list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['telephone_no'] = this.telephoneNo;
    data['email'] = this.email;
    data['schedule'] = this.schedule;
    data['more_info'] = this.moreInfo;
    data['list_items'] = this.listItems;
    data['image_ids'] = this.imageIds;
    data['zipcode'] = this.zipcode;
    data['map_location'] = this.mapLocation;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['token'] = this.token;
    data['ipaddress'] = this.ipaddress;
    data['browser'] = this.browser;
    data['review_mail_sent_at'] = this.reviewMailSentAt;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Hauler {
  int id;
  String title;
  String personName;
  String businessName;
  String address;
  String city;
  String state;
  String zipcode;
  String mapLocation;
  String latitude;
  String longitude;
  int radiusMiles;
  String telephoneNo;
  String secondaryTelephoneNo;
  String website;
  String managerName;
  String email;
  Null emailVerifiedAt;
  String profileUrl;
  String aboutUs;
  String metaTitle;
  String metaDescription;
  String acceptedAt;
  String activatedAt;
  String verifiedAt;
  String paymentStatus;
  String lockAccount;
  int completeSetupMail;
  int makePaymentMail;
  String createdAt;
  String updatedAt;

  Hauler(
      {this.id,
      this.title,
      this.personName,
      this.businessName,
      this.address,
      this.city,
      this.state,
      this.zipcode,
      this.mapLocation,
      this.latitude,
      this.longitude,
      this.radiusMiles,
      this.telephoneNo,
      this.secondaryTelephoneNo,
      this.website,
      this.managerName,
      this.email,
      this.emailVerifiedAt,
      this.profileUrl,
      this.aboutUs,
      this.metaTitle,
      this.metaDescription,
      this.acceptedAt,
      this.activatedAt,
      this.verifiedAt,
      this.paymentStatus,
      this.lockAccount,
      this.completeSetupMail,
      this.makePaymentMail,
      this.createdAt,
      this.updatedAt});

  Hauler.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    personName = json['person_name'];
    businessName = json['business_name'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    mapLocation = json['map_location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    radiusMiles = json['radius_miles'];
    telephoneNo = json['telephone_no'];
    secondaryTelephoneNo = json['secondary_telephone_no'];
    website = json['website'];
    managerName = json['manager_name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    profileUrl = json['profile_url'];
    aboutUs = json['about_us'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    acceptedAt = json['accepted_at'];
    activatedAt = json['activated_at'];
    verifiedAt = json['verified_at'];
    paymentStatus = json['payment_status'];
    lockAccount = json['lock_account'];
    completeSetupMail = json['complete_setup_mail'];
    makePaymentMail = json['make_payment_mail'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['person_name'] = this.personName;
    data['business_name'] = this.businessName;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zipcode'] = this.zipcode;
    data['map_location'] = this.mapLocation;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['radius_miles'] = this.radiusMiles;
    data['telephone_no'] = this.telephoneNo;
    data['secondary_telephone_no'] = this.secondaryTelephoneNo;
    data['website'] = this.website;
    data['manager_name'] = this.managerName;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['profile_url'] = this.profileUrl;
    data['about_us'] = this.aboutUs;
    data['meta_title'] = this.metaTitle;
    data['meta_description'] = this.metaDescription;
    data['accepted_at'] = this.acceptedAt;
    data['activated_at'] = this.activatedAt;
    data['verified_at'] = this.verifiedAt;
    data['payment_status'] = this.paymentStatus;
    data['lock_account'] = this.lockAccount;
    data['complete_setup_mail'] = this.completeSetupMail;
    data['make_payment_mail'] = this.makePaymentMail;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Images {
  int id;
  String url;

  Images({this.id, this.url});

  factory Images.fromJson(json) {
    return Images(id: json["id"], url: json["url"]);
  }
}
