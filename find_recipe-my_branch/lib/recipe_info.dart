import 'dart:ui';
import 'package:find_recipe/extension.dart';
import 'package:find_recipe/bottom_screens/directions.dart';
import 'package:find_recipe/bottom_screens/ingredients.dart';
import 'package:find_recipe/bottom_screens/nutrations.dart';
import 'package:flutter/material.dart';

class recipe_info extends StatefulWidget {
  String url;
  String tag;
  String descrip;
  String title;
  String by;
  String ingredients;
  String time;
  String serve;
  recipe_info(
      {Key key,
      @required this.url,
      @required this.descrip,
      @required this.title,
      @required this.by,
      @required this.ingredients,
      @required this.time,
      @required this.serve})
      : super(key: key);
  @override
  _recipe_infoState createState() => _recipe_infoState(this.url, this.descrip,
      this.title, this.by, this.ingredients, this.time, this.serve);
}

class _recipe_infoState extends State<recipe_info> {
  String url;
  String tag;
  String descript;
  String title;
  String by;
  String ingredient;
  String time;
  String serve;
  _recipe_infoState(this.url, this.descript, this.title, this.by,
      this.ingredient, this.time, this.serve);
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var get_title;
  List<Widget> _widgetOptions = List<Widget>();
  @override
  void initState() {
    _widgetOptions.add(ingredients(
      ingredient: ingredient,
      time: time,
      serve: serve,
    ));
    print(serve);
    _widgetOptions.add(directions());
    _widgetOptions.add(nutration());
    get_title = title.capitalize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
                tag: "imageHero",
                child: Stack(
                  children: [
                    Container(
                      height: height * 0.4,
                      width: width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(url), fit: BoxFit.fill)),
                      // child: BackdropFilter(
                      //   filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      // child: Container(
                      //   height: 0,
                      //   decoration: new BoxDecoration(
                      //       color: Colors.black.withOpacity(0.0)),
                      // ),
                    ),
                    // Positioned.fill(
                    //     child: Align(
                    //         alignment: Alignment.bottomLeft,
                    //         child: frosted(Text("asda")))),
                    Positioned.fill(
                      child: Align(
                          alignment: Alignment.bottomLeft,
                          child: frosted(Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  get_title,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  by,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ))),
                    )
                  ],
                )),
            IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions,
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.integration_instructions),
            label: 'Ingredients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Directions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pages),
            label: 'Nutration',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget frosted(Widget child) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      ClipRect(
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration:
                  new BoxDecoration(color: Colors.black.withOpacity(0.5)),
              child: child,
            )),
      ),
    ]);
  }
}
