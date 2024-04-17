// To parse this JSON data, do
//
//     final recipies = recipiesFromJson(jsonString);

import 'dart:convert';

List<Recipies> recipiesFromJson(String str) =>
    List<Recipies>.from(json.decode(str).map((x) => Recipies.fromJson(x)));

String recipiesToJson(List<Recipies> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Recipies {
  Recipies({
    this.recipies,
    this.imageLink,
    this.description,
    this.tags,
    this.nutritions,
    this.by,
    this.requiredTime,
    this.servings,
    this.ingredients,
    this.directions,
  });

  String recipies;
  String imageLink;
  String description;
  String tags;
  Nutritions nutritions;
  String by;
  int requiredTime;
  int servings;
  String ingredients;
  String directions;

  factory Recipies.fromJson(Map<String, dynamic> json) => Recipies(
        recipies: json["recipies"],
        imageLink: json["ImageLink"],
        description: json["Description"],
        tags: json["Tags"],
        nutritions: Nutritions.fromJson(json["Nutritions"]),
        by: json["By"],
        requiredTime: json["RequiredTime"],
        servings: json["Servings"],
        ingredients: json["Ingredients"],
        directions: json["Directions"],
      );

  Map<String, dynamic> toJson() => {
        "recipies": recipies,
        "ImageLink": imageLink,
        "Description": description,
        "Tags": tags,
        "Nutritions": nutritions.toJson(),
        "By": by,
        "RequiredTime": requiredTime,
        "Servings": servings,
        "Ingredients": ingredients,
        "Directions": directions,
      };
}

class Nutritions {
  Nutritions({
    this.energy,
    this.protein,
    this.carbs,
    this.fiber,
    this.fat,
    this.cholestrol,
    this.sodium,
  });

  String energy;
  String protein;
  String carbs;
  String fiber;
  String fat;
  String cholestrol;
  String sodium;

  factory Nutritions.fromJson(Map<String, dynamic> json) => Nutritions(
        energy: json["energy"],
        protein: json["protein"],
        carbs: json["carbs"],
        fiber: json["fiber"],
        fat: json["fat"],
        cholestrol: json["cholestrol"],
        sodium: json["sodium"],
      );

  Map<String, dynamic> toJson() => {
        "energy": energy,
        "protein": protein,
        "carbs": carbs,
        "fiber": fiber,
        "fat": fat,
        "cholestrol": cholestrol,
        "sodium": sodium,
      };
}
