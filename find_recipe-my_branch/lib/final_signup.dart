import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:find_recipe/main_page.dart';
import 'package:find_recipe/responses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:find_recipe/suggestion_data.dart';

class final_signup extends StatefulWidget {
  String id;
  final_signup({Key key, @required this.id}) : super(key: key);
  @override
  _final_signupState createState() => _final_signupState(id);
}

class _final_signupState extends State<final_signup> {
  String id;
  _final_signupState(this.id);

  final _tagState = GlobalKey<TagsState>();
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  bool isLoading = false;
  final _controller = TextEditingController();
  List _items = new List();
  SimpleAutoCompleteTextField textField;
  bool showWhichErrorText = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // Future<void> _issignup() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   if (pref.getBool("issignup") == true) {
  //     setState(() {
  //       Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (context) => my_page()),
  //           (route) => false);
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    print(id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
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
                    AutoCompleteTextField(
                      clearOnSubmit: true,
                      controller: _controller,
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.add_box_rounded),
                          border: new OutlineInputBorder(),
                          labelText: "Add your preferences..."),
                      suggestions: suggestions,
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                          trailing: Icon(Icons.add_location),
                        );
                      },
                      itemSorter: (a, b) {
                        return a.compareTo(b);
                      },
                      itemFilter: (suggestion, query) {
                        return suggestion
                            .toLowerCase()
                            .startsWith(query.toLowerCase());
                      },
                      itemSubmitted: (data) {
                        _items.add(Item(title: data));
                      },
                      key: key,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Tags(
                          key: _tagState,
                          itemCount: _items.length,
                          itemBuilder: (int index) {
                            final item = _items[index];
                            return ItemTags(
                              activeColor: Colors.white,
                              index: index,
                              title: item.title,
                              textActiveColor: Colors.black,
                              textStyle: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              combine: ItemTagsCombine.withTextBefore,
                              onPressed: (item) => print(item),
                              onLongPressed: (item) => print(item),
                              removeButton: ItemTagsRemoveButton(
                                onRemoved: () {
                                  setState(() {
                                    _items.removeAt(index);
                                  });
                                  return true;
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: isLoading == false
                          ? new RaisedButton(
                              color: Colors.greenAccent,
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });

                                if (_items.isEmpty) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    backgroundColor: Colors.red,
                                    action: SnackBarAction(
                                      label: "ok",
                                      textColor: Colors.white,
                                      onPressed: () {
                                        _scaffoldKey.currentState
                                            .hideCurrentSnackBar();
                                      },
                                    ),
                                    content: Text(
                                        "You can't procced with empty preferences"),
                                    duration: Duration(seconds: 2),
                                  ));
                                } else {
                                  List mylist = [];
                                  for (int i = 0; i < _items.length; i++) {
                                    mylist.add(_items[i].title);
                                  }
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  var response = await signup3(id, mylist);
                                  if (response["response"] == true) {
                                    print("sucess");
                                    setState(() {
                                      isLoading = false;
                                      pref.setBool("islogin", true);
                                      pref.setString("id", id);
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => my_page()),
                                          (route) => false);
                                    });
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "Some thing wents wrong pleas try again"),
                                      action: SnackBarAction(
                                        label: "ok",
                                        onPressed: () {
                                          _scaffoldKey.currentState
                                              .hideCurrentSnackBar();
                                        },
                                      ),
                                    ));
                                  }
                                  print(mylist);
                                }
                              },
                              child: new Text(
                                "Lets go!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
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
            ],
          ),
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
