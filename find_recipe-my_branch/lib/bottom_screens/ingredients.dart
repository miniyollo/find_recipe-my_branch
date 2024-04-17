import 'package:flutter/material.dart';
import 'dart:convert';

class ingredients extends StatefulWidget {
  String ingredient;
  String time;
  String serve;
  ingredients(
      {Key key,
      @required this.ingredient,
      @required this.time,
      @required this.serve})
      : super(key: key);
  @override
  _ingredientsState createState() =>
      _ingredientsState(this.ingredient, this.time, this.serve);
}

class _ingredientsState extends State<ingredients> {
  String ingredient;
  String time;
  String serve;
  _ingredientsState(this.ingredient, this.time, this.serve);
  // List<String> s;
  @override
  void initState() {
    // s = ingredient.split(RegExp(r'/,\s/'));
    // var ab = json.encode(s);
    // print(s);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Ingredients",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Text("Ready In: ${time}min",
                style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                )),
            Text("Serves: ${serve}",
                style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                ))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            ingredient,
            style: TextStyle(fontSize: 18, letterSpacing: 1),
          ),
        )
      ],
    );
  }
}
