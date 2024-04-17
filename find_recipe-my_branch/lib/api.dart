import 'dart:convert';

import 'package:find_recipe/sample_model.dart';
import 'package:http/http.dart' as http;

Future sample_api() async {
  List list = [];
  try {
    final response =
        await http.get("https://webrooper.com/androiddb/sample.php");
    // final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

    var data = json.decode(response.body);
    for (var u in data) {
      for (var i in u["ingredients"]) {
        ingredients inlist = ingredients(i["title"], i["quantity"]);
        list.add(inlist);
      }
    }

    return list;
  } catch (e) {
    return e;
  }
}

class ingredients {
  String title;
  String quantity;

  ingredients(this.title, this.quantity);
}

Future<List<Model>> maindata() async {
  final response = await http.get("https://webrooper.com/androiddb/sample.php");
  return modelFromJson(response.body);
}
