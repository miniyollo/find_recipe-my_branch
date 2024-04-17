import 'dart:convert';

List<JsonData> jsonDataFromJson(String str) =>
    List<JsonData>.from(json.decode(str).map((x) => JsonData.fromJson(x)));

String jsonDataToJson(List<JsonData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JsonData {
  JsonData({
    this.productId,
    this.imgurl,
    this.title,
    this.price,
    this.isLiked,
  });

  String productId;
  String imgurl;
  String title;
  String price;
  bool isLiked;

  factory JsonData.fromJson(Map<String, dynamic> json) => JsonData(
        productId: json["product_id"],
        imgurl: json["imgurl"],
        title: json["title"],
        price: json["price"],
        isLiked: json["is_liked"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "imgurl": imgurl,
        "title": title,
        "price": price,
        "is_liked": isLiked,
      };
}
