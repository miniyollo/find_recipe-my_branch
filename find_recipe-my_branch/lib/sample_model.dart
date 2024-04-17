import 'dart:convert';

List<Model> modelFromJson(String str) =>
    List<Model>.from(json.decode(str).map((x) => Model.fromJson(x)));

String modelToJson(List<Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Model {
  Model({
    this.title,
    this.description,
    this.ingredients,
  });

  String title;
  String description;
  List<Ingredient> ingredients;

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        title: json["title"],
        description: json["description"],
        ingredients: List<Ingredient>.from(
            json["ingredients"].map((x) => Ingredient.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "ingredients": List<dynamic>.from(ingredients.map((x) => x.toJson())),
      };
  // static parsed(json) {
  //   final data = json["ingredients"] as List;
  // }
}

class Ingredient {
  Ingredient({
    this.title,
    this.quantity,
  });

  String title;
  String quantity;

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        title: json["title"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "quantity": quantity,
      };
}
