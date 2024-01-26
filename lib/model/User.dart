import 'package:shared_preferences/shared_preferences.dart';

class User {
  int? id;
  String? title;
  String? personName;
  String? businessName;
  String? address;
  String? city;
  String? state;
  String? zipcode;
  String? mapLocation;
  String? latitude;
  String? longitude;
  int? radiusMiles;
  String? telephoneNo;
  String? secondaryTelephoneNo;
  String? website;
  String? managerName;
  String? email;
  dynamic emailVerifiedAt;
  String? profileUrl;
  String? aboutUs;
  String? metaTitle;
  String? metaDescription;
  String? acceptedAt;
  String? activatedAt;
  String? verifiedAt;
  String? paymentStatus;
  String? lockAccount;
  int? completeSetupMail;
  int? makePaymentMail;
  String? createdAt;
  String? updatedAt;

  User(
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

  User.fromJson(Map<String, dynamic> json) {
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

class Shop {
  String? id;
  String? shopName;
  String? shopAddress;
  String? shopStreet;
  String? shopWebsite;
  String? shopRadius;
  String? shopProfile;
  String? shopTelephone;
  String? shopEmail;
  String? shopContactPerson;
  String? shopCity;
  String? country;
  String? shopPostcode;
  String? secondaryTel;
  String? manager;
  String? status;
  bool? connection;

  Shop(
      {this.id,
      this.shopName,
      this.shopAddress,
      this.shopStreet,
      this.shopWebsite,
      this.shopRadius,
      this.shopProfile,
      this.shopTelephone,
      this.shopEmail,
      this.shopContactPerson,
      this.shopCity,
      this.shopPostcode,
      this.secondaryTel,
      this.manager,
      this.connection,
      this.country,
      this.status});

  factory Shop.fromMap(Map<String, dynamic> json) {
    return Shop(
        status: json["status"],
        id: json["shop_id"],
        manager: json["manager"],
        secondaryTel: json["secondarytel"],
        shopAddress: json["shop_address"],
        shopCity: json["shop_city"],
        shopContactPerson: json["shop_contact_person"],
        shopEmail: json["shop_email"],
        shopName: json["shop_business_name"],
        shopPostcode: json["shop_postcode"],
        shopProfile: json["shop_profile"],
        shopRadius: json["shop_radius"],
        shopStreet: json["shop_street"],
        shopTelephone: json["shop_telephone"],
        shopWebsite: json["shop_website"],
        country: json["shop_country"]);
  }

  Map<String, dynamic> toMap(Shop shop) {
    var map = <String, dynamic>{
      "shop_website": shop.shopWebsite,
      "shop_telephone": shop.shopTelephone,
      "shop_street": shop.shopStreet,
      "status": shop.status,
      "shop_id": shop.id,
      "manager": shop.manager,
      "secondarytel": shop.secondaryTel,
      "shop_address": shop.shopAddress,
      "shop_city": shop.shopCity,
      "shop_contact_person": shop.shopContactPerson,
      "shop_email": shop.shopEmail,
      "shop_business_name": shop.shopName,
      "shop_postcode": shop.shopPostcode,
      "shop_profile": shop.shopProfile,
      "shop_radius": shop.shopRadius,
      "shop_country": shop.country
    };

    return map;
  }

  Future<Shop> fromSharedPreference() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Shop shop = Shop(
        shopWebsite: sp.getString("shopWebsite"),
        shopTelephone: sp.getString("shopTelephone"),
        shopStreet: sp.getString("shopStreet"),
        shopRadius: sp.getString("shopRadius"),
        shopProfile: sp.getString("shopProfile"),
        shopPostcode: sp.getString("shopPostcode"),
        shopName: sp.getString("shopName"),
        shopEmail: sp.getString("shopEmail"),
        shopContactPerson: sp.getString("shopContactPerson"),
        shopCity: sp.getString("shopCity"),
        shopAddress: sp.getString("shopAddress"),
        secondaryTel: sp.getString("secondaryTel"),
        manager: sp.getString("manager"),
        id: sp.getString("id"),
        status: sp.getString("status"),
        connection: sp.getBool("internet"),
        country: sp.getString("country"));
    return shop;
  }

  toSharedPreference(Shop shop) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setString("id", shop.id!);
    sp.setString("shopEmail", shop.shopEmail!);
    sp.setString("shopName", shop.shopName!);
    sp.setString("shopPostcode", shop.shopPostcode!);
    sp.setString("shopProfile", shop.shopProfile!);
    sp.setString("shopRadius", shop.shopRadius!);
    sp.setString("shopContactPerson", shop.shopContactPerson!);
    sp.setString("shopAddress", shop.shopAddress!);
    sp.setString("shopCity", shop.shopCity!);
    sp.setString("secondaryTel", shop.secondaryTel!);
    sp.setString("manager", shop.manager!);
    sp.setString("status", shop.status!);
    sp.setString("country", shop.country!);
    sp.setString("shopStreet", shop.shopStreet!);
    sp.setString("shopTelephone", shop.shopTelephone!);
    sp.setString("shopWebsite", shop.shopWebsite!);
    sp.setBool("internet", true);
    sp.setInt("count", 0);
  }
}
