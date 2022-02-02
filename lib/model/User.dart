import 'package:shared_preferences/shared_preferences.dart';

class Shop {
  String id;
  String shopName;
  String shopAddress;
  String shopStreet;
  String shopWebsite;
  String shopRadius;
  String shopProfile;
  String shopTelephone;
  String shopEmail;
  String shopContactPerson;
  String shopCity;
  String country;
  String shopPostcode;
  String secondaryTel;
  String manager;
  String status;
  bool connection;
  String jwtToken;

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
      this.jwtToken,
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
        jwtToken: json["jwt_token"],
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
        jwtToken: sp.getString("jwtToken"),
        country: sp.get("country"));
    return shop;
  }

  toSharedPreference(Shop shop) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setString("id", shop.id);
    sp.setString("shopEmail", shop.shopEmail);
    sp.setString("shopName", shop.shopName);
    sp.setString("shopPostcode", shop.shopPostcode);
    sp.setString("shopProfile", shop.shopProfile);
    sp.setString("shopRadius", shop.shopRadius);
    sp.setString("shopContactPerson", shop.shopContactPerson);
    sp.setString("shopAddress", shop.shopAddress);
    sp.setString("shopCity", shop.shopCity);
    sp.setString("secondaryTel", shop.secondaryTel);
    sp.setString("manager", shop.manager);
    sp.setString("status", shop.status);
    sp.setString("country", shop.country);
    sp.setString("shopStreet", shop.shopStreet);
    sp.setString("shopTelephone", shop.shopTelephone);
    sp.setString("shopWebsite", shop.shopWebsite);
    sp.setBool("internet", true);
    sp.setString("jwtToken", shop.jwtToken);
    sp.setBool("internet", true);
    sp.setInt("count", 0);
  }
}
