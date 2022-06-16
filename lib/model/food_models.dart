class FoodModels {
  String? id;
  String? idshop;
  String? namefood;
  String? pathimage;
  String? price;
  String? detail;

  FoodModels(
      {this.id,
      this.idshop,
      this.namefood,
      this.pathimage,
      this.price,
      this.detail});

  FoodModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idshop = json['idshop'];
    namefood = json['namefood'];
    pathimage = json['pathimage'];
    price = json['price'];
    detail = json['detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idshop'] = this.idshop;
    data['namefood'] = this.namefood;
    data['pathimage'] = this.pathimage;
    data['price'] = this.price;
    data['detail'] = this.detail;
    return data;
  }
}
