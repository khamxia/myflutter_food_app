class UserModel {
  String? id;
  String? name;
  String? email;
  String? user;
  String? password;
  String? typeuser;
  String? nameshop;
  String? addressshop;
  String? phoneshop;
  String? urlpicture;
  String? lat;
  String? lng;
  String? token;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.user,
      this.password,
      this.typeuser,
      this.nameshop,
      this.addressshop,
      this.phoneshop,
      this.urlpicture,
      this.lat,
      this.lng,
      this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    user = json['user'];
    password = json['password'];
    typeuser = json['typeuser'];
    nameshop = json['nameshop'];
    addressshop = json['addressshop'];
    phoneshop = json['phoneshop'];
    urlpicture = json['urlpicture'];
    lat = json['lat'];
    lng = json['lng'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['user'] = this.user;
    data['password'] = this.password;
    data['typeuser'] = this.typeuser;
    data['nameshop'] = this.nameshop;
    data['addressshop'] = this.addressshop;
    data['phoneshop'] = this.phoneshop;
    data['urlpicture'] = this.urlpicture;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['token'] = this.token;
    return data;
  }
}
