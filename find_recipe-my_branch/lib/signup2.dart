import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:find_recipe/final_signup.dart';
import 'package:find_recipe/main.dart';
import 'package:find_recipe/responses.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class userinfo extends StatefulWidget {
  int id;
  userinfo({Key key, @required this.id}) : super(key: key);
  @override
  _userinfoState createState() => _userinfoState(id);
}

class _userinfoState extends State<userinfo> {
  int id;
  _userinfoState(this.id);
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController name = new TextEditingController();
  TextEditingController age = new TextEditingController();

  String gender;
  String disease;
  String vegiterian;

  List<DropdownMenuItem<String>> _gender = [
    DropdownMenuItem(
      child: Text("Male"),
      value: "Male",
    ),
    DropdownMenuItem(
      child: Text("Female"),
      value: "Female",
    )
  ];

  List<DropdownMenuItem<String>> _disease = [
    DropdownMenuItem(
      child: Text("No"),
      value: "No",
    ),
    DropdownMenuItem(
      child: Text("Diabetes"),
      value: "Diabetes",
    ),
    DropdownMenuItem(
      child: Text("High/Low blood pressure"),
      value: "High blood pressure",
    ),
    DropdownMenuItem(
      child: Text("Common cold"),
      value: "Comman cold",
    ),
    DropdownMenuItem(
      child: Text("Acne vulgaris"),
      value: "Acne vulgaris",
    ),
    DropdownMenuItem(
      child: Text("Gastroesophageal Reflux Disease (GERD)"),
      value: "Gastroesophageal Reflux Disease (GERD)",
    ),
    DropdownMenuItem(
      child: Text("Allergic rhinitis"),
      value: "Allergic rhinitis",
    ),
  ];
  List<DropdownMenuItem<String>> _vegiterian = [
    DropdownMenuItem(
      child: Text("Vegetarian"),
      value: "Vegetarian",
    ),
    DropdownMenuItem(
      child: Text("Non vegetarian"),
      value: "Non vegetarian",
    ),
  ];

  final _scafold_key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    print("user_id = $id");
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    age.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafold_key,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            RotationTransition(
              turns: new AlwaysStoppedAnimation(15 / 360),
              child: Text(
                "FindTheRecipe",
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.clip,
                style: new TextStyle(
                    fontFamily: "free",
                    fontSize: MediaQuery.of(context).size.width * 0.4,
                    color: Colors.grey[400]),
              ),
            ),
            ClipPath(
              clipper: Myclipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                decoration:
                    BoxDecoration(color: Color.fromRGBO(255, 210, 210, 150)),
              ),
            ),
            Positioned.fill(
              child: Align(
                  alignment: Alignment.topLeft,
                  child: new Image.asset("images/foods.png")),
            ),
            Positioned.fill(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: new Image.asset("images/ingridents.png")),
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.28,
                    ),
                    SizedBox(
                      child: new Text(
                        "FindTheRecipe",
                        style: new TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.2,
                            color: Colors.grey[500],
                            fontFamily: "free"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(),
                            labelText: "Name"),
                        controller: name,
                        validator: (value) =>
                            value.isEmpty ? "Field required" : null),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 40),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(),
                                  labelText: "Age"),
                              controller: age,
                              validator: (input) {
                                if (input.isEmpty) {
                                  return "Field required";
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(),
                                  labelText: "Gender"),
                              validator: (value) {
                                if (value == null) {
                                  return "Field required";
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  gender = value;
                                });
                              },
                              items: _gender),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField(
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(),
                            labelText: "Do you have any disease?"),
                        isDense: true,
                        validator: (value) {
                          if (value == null) {
                            return "Field required";
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            disease = value;
                          });
                        },
                        items: _disease),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.white,
                      child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(),
                              labelText: "Select you are Vegetarian or not"),
                          validator: (value) {
                            if (value == null) {
                              return "Field required";
                            }
                          },
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              vegiterian = value;
                            });
                          },
                          items: _vegiterian),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: isLoading == false
                          ? new RaisedButton(
                              color: Colors.greenAccent,
                              onPressed: () async {
                                if (formkey.currentState.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  String username = name.text.trim();
                                  String userage = age.text.trim();
                                  String gen = gender;
                                  String dis = disease;
                                  String veg = vegiterian;
                                  String iid = id.toString();

                                  var res = await signup2(
                                      username, userage, gen, dis, veg, iid);
                                  if (res['response'] == true) {
                                    setState(() {
                                      isLoading = false;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  final_signup(
                                                    id: iid,
                                                  )));
                                      print(iid);
                                    });
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                      _scafold_key.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Some thing wents wrong pleas try again"),
                                        action: SnackBarAction(
                                          label: "ok",
                                          onPressed: () {
                                            _scafold_key.currentState
                                                .hideCurrentSnackBar();
                                          },
                                        ),
                                      ));
                                    });
                                  }
                                }
                              },
                              child: new Text(
                                "Next",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Myclipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(100, size.height - 400);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
