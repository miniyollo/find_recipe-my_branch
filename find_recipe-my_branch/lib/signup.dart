import 'package:async/async.dart';
import 'package:find_recipe/main.dart';
import 'package:find_recipe/responses.dart';
import 'package:find_recipe/signup2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class signup extends StatefulWidget {
  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  final formkey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password1 = TextEditingController();
  final password2 = TextEditingController();

  // String email, password1, password2;

  bool isLoading = false;

  @override
  void dispose() {
    email.dispose();
    password1.dispose();
    password2.dispose();
    super.dispose();
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
                  child: new Image.asset("images/ingridents.png")),
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
                          labelText: "Enter email"),
                      controller: email,
                      validator: (input) =>
                          !input.contains('@') ? 'Not a valid email' : null,
                    ),
                    SizedBox(
                      height: 30,
                      // child: Align(
                      //   alignment: Alignment.centerRight,
                      //   child: TextButton(
                      //       onPressed: () {}, child: new Text("forgot?")),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(),
                          labelText: "Create password"),
                      controller: password1,
                      validator: (input1) => input1.length < 6
                          ? 'You need at least 6 characteres'
                          : null,
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 30,
                      // child: Align(
                      //   alignment: Alignment.centerRight,
                      //   child: TextButton(
                      //       onPressed: () {}, child: new Text("forgot?")),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(),
                          labelText: "Conform password"),
                      controller: password2,
                      validator: (input2) {
                        if (input2.length < 6) {
                          return "You need at least 6 characteres";
                        } else if (input2 != password1.text) {
                          return "does not match";
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: isLoading == false
                          ? new RaisedButton(
                              color: Colors.grey[200],
                              onPressed: () async {
                                if (formkey.currentState.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  var mail = email.text.trim();
                                  var pass = password2.text.trim();

                                  var res = await signup_response(mail, pass);

                                  if (res.containsKey('response')) {
                                    if (res['response'] == true) {
                                      setState(() {
                                        print("success..");

                                        isLoading = false;
                                        int id = res['id'];
                                        print(id);
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return userinfo(
                                            id: id,
                                          );
                                        }));
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
                                "Next",
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: RaisedButton(
                        color: Colors.greenAccent,
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return Loginpage();
                          }), (route) => false);
                        },
                        child: new Text(
                          "Login",
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
