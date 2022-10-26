class User {
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
