import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:find_recipe/hero_sample.dart';

import 'package:find_recipe/json_data.dart';
import 'package:find_recipe/main.dart';
import 'package:find_recipe/my_jsons/recipe_json_data.dart';
import 'package:find_recipe/recipe_info.dart';

import 'package:find_recipe/responses.dart';
import 'package:find_recipe/sample.dart';

import 'package:find_recipe/search.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class my_page extends StatefulWidget {
  @override
  _my_pageState createState() => _my_pageState();
}

class _my_pageState extends State<my_page> {
  String id;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> images = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80'
  ];

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();

  ScrollController _scrollController;

  Future _future;

  var index1 = 0;

  Future<void> islogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      id = pref.getString("id");
      print("iid $id");
      _future = get_init_recipies(id);
    });

    if (pref.getBool("islogin") == false) {
      setState(() {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Loginpage()),
            (route) => false);
      });
    }
  }

  bool isoffline;

  Future<void> connectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isoffline = true;
      });

      print("connected");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isoffline = true;
      });
      // I am connected to a wifi network.
      print("connected");
    } else {
      setState(() {
        isoffline = false;
      });
      print("dissconneted");
    }
  }

  static const offsetVisibleThreshold = 200;
  static int page = 0;
  ScrollController _sc;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    islogin();
    connectivity();
    // _future = ;
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _current = 0;
  static const Color one = Color(0xff808000);
  static const Color two = Color(0xff608000);
  static const Color three = Color(0xff208080);
  List<Color> colors = [one, two, three];
  static final random = new Random();

  Color colorrandom() {
    return colors[random.nextInt(3)];
  }

  String query = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: new Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text("Header"),
              decoration: BoxDecoration(color: Colors.amber),
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setBool("islogin", false);
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return Loginpage();
                }), (route) => false);
              },
            )
          ],
        ),
      ),
      appBar: new AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: new Text("FindTheRecipe"),
        actions: [
          new IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(seconds: 1),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          search(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var beign = Offset(0.0, 1.0);
                        var end = Offset.zero;
                        var curve = Curves.ease;
                        var tween = Tween(begin: beign, end: end)
                            .chain(CurveTween(curve: curve));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ));
              })
        ],
      ),
      body: isoffline != false
          ? Hero(
              tag: "imageHero",
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CarouselSlider.builder(
                      itemCount: images.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              "images/dohkla.png",
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            print(index);
                            setState(() {
                              _current = index;
                            });
                          },
                          height: MediaQuery.of(context).size.width * 0.3,
                          aspectRatio: 16 / 9,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 4))),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: images.map((url) {
                      int index = images.indexOf(url);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Color.fromRGBO(0, 0, 0, 0.9)
                              : Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      );
                    }).toList(),
                  ),

                  ////////////////////////////////////////////////////////////////////////
                  ///
                  ///

                  Expanded(
                      child: CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(children: [
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Based on your Search History",
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "See all",
                                      style: new TextStyle(color: Colors.blue),
                                    ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Container(
                                height: 190,
                                child: FutureBuilder(
                                    future: _future,
                                    builder: (BuildContext context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text("error"),
                                        );
                                      } else if (snapshot.hasData &&
                                          snapshot.data.isNotEmpty) {
                                        return ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Card(
                                                elevation: 5,
                                                shadowColor: Colors.grey[400],
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    recipe_info(
                                                                      url: snapshot
                                                                          .data[
                                                                              index]
                                                                          .imageLink,
                                                                      descrip: snapshot
                                                                          .data[
                                                                              index]
                                                                          .description,
                                                                      title: snapshot
                                                                          .data[
                                                                              index]
                                                                          .recipies,
                                                                      by: snapshot
                                                                          .data[
                                                                              index]
                                                                          .by,
                                                                      ingredients: snapshot
                                                                          .data[
                                                                              index]
                                                                          .ingredients,
                                                                      time: snapshot
                                                                          .data[
                                                                              index]
                                                                          .requiredTime
                                                                          .toString(),
                                                                      serve: snapshot
                                                                          .data[
                                                                              index]
                                                                          .servings
                                                                          .toString(),
                                                                    )));
                                                  },
                                                  child: Container(
                                                    width: 150,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        //mostviewed
                                                        ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        8),
                                                                topRight: Radius
                                                                    .circular(
                                                                        8)),
                                                            child: Container(
                                                              height: 100,
                                                              width: 150,
                                                              color:
                                                                  colorrandom(),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: snapshot
                                                                    .data[index]
                                                                    .imageLink,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            )),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            snapshot.data[index]
                                                                .recipies,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .grey[700]),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          "By ${snapshot.data[index].by}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[700]),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),

                                                        Text(
                                                          "Cooking Time: ${snapshot.data[index].requiredTime} min",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[700]),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      } else {
                                        return Center(
                                          child: Text("Empty.."),
                                        );
                                      }
                                    })

                                // scrollDirection: Axis.horizontal,
                                // itemCount: images.length,
                                // itemBuilder: (BuildContext ctx, int index) {
                                //   return Card(
                                //     shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(8)),
                                //     child: Column(
                                //       children: [
                                //         //mostviewed
                                //         ClipRRect(
                                //           borderRadius: BorderRadius.only(
                                //               topLeft: Radius.circular(8),
                                //               topRight: Radius.circular(8)),
                                //           child: Container(
                                //               height: 100,
                                //               width: 130,
                                //               child: Image.asset(
                                //                 "images/poha.png",
                                //                 fit: BoxFit.fitHeight,
                                //               )),
                                //         ),

                                ),
                          ),
                        ]),
                      ), ////////

                      ////
                      ///

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Based on your profile",
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              TextButton(
                                  onPressed: () {
                                    final snackbar = SnackBar(
                                      content: Text("you clicked"),
                                      action: SnackBarAction(
                                        label: "ok",
                                        onPressed: () {},
                                      ),
                                    );
                                    _scaffoldKey.currentState
                                        .showSnackBar(snackbar);
                                  },
                                  child: Text(
                                    "See all",
                                    style: new TextStyle(color: Colors.blue),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      //

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Container(
                              height: 190,
                              child: FutureBuilder(
                                  future: _future,
                                  builder: (BuildContext context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text("error"),
                                      );
                                    } else if (snapshot.hasData &&
                                        snapshot.data.isNotEmpty) {
                                      return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Card(
                                              elevation: 5,
                                              shadowColor: Colors.grey[400],
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Container(
                                                width: 150,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    //mostviewed
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(8),
                                                              topRight: Radius
                                                                  .circular(8)),
                                                      child: Container(
                                                          height: 100,
                                                          width: 150,
                                                          color: colorrandom(),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: snapshot
                                                                .data[index]
                                                                .imageLink,
                                                            fit: BoxFit.fill,
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        snapshot.data[index]
                                                            .recipies,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[700]),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "By ${snapshot.data[index].by}",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[700]),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),

                                                    Text(
                                                      "Cooking Time: ${snapshot.data[index].requiredTime} min",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[700]),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    } else {
                                      return Center(
                                        child: Text("Empty.."),
                                      );
                                    }
                                  })),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            )
          : Center(
              child: Text("No Internet.."),
            ),
    );
  }
}
