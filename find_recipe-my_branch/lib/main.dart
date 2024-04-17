import 'dart:convert';

import 'package:find_recipe/main_page.dart';

import 'package:find_recipe/search.dart';
import 'package:find_recipe/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'responses.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.grey,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Loginpage(),
    );
  }
}

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final formkey = GlobalKey<FormState>();
  String email, password;

  bool isLoading = false;

  Future<void> islogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getBool("islogin") == true) {
      setState(() {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => my_page()),
            (route) => false);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    islogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: new Image.asset(
                    "images/ingridents.png",
                  )),
            ),
            // Positioned.fill(
            //     child: Align(
            //   child: Align(
            //       alignment: Alignment.topRight,
            //       child: new Image.asset("images/semi.png")),
            // ))

            Padding(
              padding: EdgeInsets.all(30.0),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
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
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(),
                          labelText: "Enter email"),
                      validator: (input) =>
                          !input.contains('@') ? 'Not a valid email' : null,
                      onSaved: (input) => email = input,
                    ),
                    SizedBox(
                      height: 35,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {}, child: new Text("forgot?")),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(),
                          labelText: "Enter password"),
                      validator: (input) => input.length < 6
                          ? 'You need at least 6 characteres'
                          : null,
                      onSaved: (input) => password = input,
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 55,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: isLoading == false
                          ? RaisedButton(
                              color: Colors.grey[200],
                              onPressed: () async {
                                if (formkey.currentState.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  formkey.currentState.save();
                                  var mail = email.trim();
                                  var pass = password.trim();
                                  var res = await login_response(mail, pass);
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();

                                  if (res.containsKey('response')) {
                                    if (res['response'] == true) {
                                      int id = res['id'];
                                      setState(() {
                                        print("success..");
                                        isLoading = false;
                                        pref.setBool("islogin", true);
                                        pref.setString("id", id.toString());

                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        my_page()),
                                                (route) => false);
                                      });
                                    } else {
                                      setState(() {
                                        print("failed..");
                                        isLoading = false;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      print("failed..");
                                      isLoading = false;
                                    });
                                  }
                                }
                              },
                              child: new Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey[600]),
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    // TextButton(
                    //     onPressed: () {},
                    //     child: Text(
                    //       "don't have an account?",
                    //     )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: RaisedButton(
                        color: Colors.greenAccent,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return signup();
                            }),
                          );
                        },
                        child: new Text(
                          "Signup",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
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
