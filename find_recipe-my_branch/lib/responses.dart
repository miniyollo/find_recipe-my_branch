import 'dart:async';
import 'dart:convert';

import 'package:find_recipe/json_data.dart';
import 'package:find_recipe/my_jsons/recipe_json_data.dart';

import 'package:http/http.dart' as http;

Future login_response(email, password) async {
  var url = "http://10.0.2.2:5000/login2";
  var response = await http.post(url,
      headers: {"Accept": "application/json"},
      body: {"mail": email, "pass": password});

  var json_res = jsonDecode(response.body);

  return json_res;
}

Future signup_response(email, password) async {
  var url = "http://10.0.2.2:5000/";

  var response = await http.post(url,
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password});

  var json_res = jsonDecode(response.body);

  return json_res;
}

Future signup2(user_name, age, gender, disease, vegetarian, id) async {
  final response = await http.post("http://10.0.2.2:5000/signup2", headers: {
    "Accept": "application/json"
  }, body: {
    "id": id,
    "username": user_name,
    "age": age,
    "gender": gender,
    "disease": disease,
    "vegetarian": vegetarian
  });

  var json_res = json.decode(response.body);
  return json_res;
}

Future signup3(String id, prefernce) async {
  var response;
  String list = json.encoder.convert(prefernce);

  response = await http.post("http://10.0.2.2:5000/signup3",
      headers: {"Accept": "application/json"},
      body: {"id": id, "preference": list});

  var json_res = jsonDecode(response.body);
  return json_res;
}

Future<List<JsonData>> data() async {
  try {
    var response_data =
        await http.get("https://webrooper.com/androiddb/foodlist.php");

    if (response_data.statusCode == 200) {
      return jsonDataFromJson(response_data.body);
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}

// initialization
Future<List<Recipies>> get_init_recipies(id) async {
  try {
    var response =
        await http.post("http://10.0.2.2:5000/get_reccoom", body: {"id": id});
    print(response.body.length);
    return recipiesFromJson(response.body);
  } catch (e) {
    throw Exception(e);
  }
}

Future<List<filter>> getmoredata() async {
  List<filter> mylist = [];
  try {
    var response =
        await http.get("https://webrooper.com/androiddb/foodlist.php");
    var json_ob = jsonDecode(response.body);

    for (var u in json_ob) {
      filter data = filter(u["productId"], u["title"], u["imgurl"], u["price"]);
      mylist.add(data);
    }
    return mylist;
  } catch (e) {
    throw e.toString();
  }
}

class filter {
  String productId;
  String imgurl;
  String title;
  String price;

  filter(this.productId, this.title, this.imgurl, this.price);
}
