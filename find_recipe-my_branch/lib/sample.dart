import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:find_recipe/api.dart';
import 'package:find_recipe/sample_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class sample extends StatefulWidget {
  @override
  _sampleState createState() => _sampleState();
}

class _sampleState extends State<sample> {
  Future _future;
  List list;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(list);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagination"),
      ),
      body: Container(),
      // body: FutureBuilder(
      //   future: _future,
      //   builder: (context, snapshot) {
      //     return ListView.builder(
      //       itemCount: snapshot.data.length,
      //       itemBuilder: (context, index) {
      //         return Text(snapshot.data[index].title);
      //       },
      //     );
      //   },
      // )
      // body: Container(),
      // body: ListView.builder(
      //   itemCount: list.length,
      //   itemBuilder: (context, index) {
      //     if (list.isEmpty) {
      //       return CircularProgressIndicator();
      //     } else {
      //       return Column(
      //         children: [Text(list[index][0].title)],
      //       );
      //     }
      //   },
      // ),

      // body: FutureBuilder<List<Model>>(
      //   future: _future,
      //   builder: (context, snapshot) {
      //     final data = snapshot.data;
      //     if (snapshot.hasData) {
      //       return ListView.builder(
      //         itemExtent: 100,
      //         itemCount: data.length,
      //         itemBuilder: (context, index) {
      //           final mydata = data[index];
      //           return ListTile(
      //             title: Text(mydata.description),
      //             leading: Text(mydata.title),
      //             contentPadding: EdgeInsets.all(10),
      //             onTap: () {
      //               Navigator.of(context).push(MaterialPageRoute(
      //                   builder: (context) => IngredientDetails(
      //                         title: mydata.title,
      //                         description: mydata.description,
      //                         index: index,
      //                         list: mydata.ingredients,
      //                       )));
      //             },
      //           );
      //         },
      //       );
      //     } else {
      //       return Center(child: CircularProgressIndicator());
      //     }
      //   },
    );

    // body: FutureBuilder(
    //   future: _future,
    //   builder: (context, snapshot) {
    //     final List<Ingredient> data = snapshot.data.ingredients;
    //     return ListView.builder(
    //       itemCount: data.length,
    //       itemBuilder: (BuildContext context, int index) {
    //         final mydata = data[index];

    //         return Column(
    //           children: [Text(mydata.title)],
    //         );
    //       },
    //     );
    //   },
    // )
  }
}

class IngredientDetails extends StatefulWidget {
  final String description, title;
  final int index;
  List list;
  IngredientDetails(
      {Key key,
      @required this.title,
      @required this.description,
      @required this.index,
      @required this.list})
      : super(key: key);
  @override
  _IngredientDetailsState createState() =>
      _IngredientDetailsState(title, description, index, list);
}

class _IngredientDetailsState extends State<IngredientDetails> {
  String title, description;
  int index;
  List list;
  _IngredientDetailsState(this.title, this.description, this.index, this.list);
  @override
  void initState() {
    super.initState();
    print(list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Quantity",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Ingredients",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Expanded(
                child: ListView.builder(
                  itemExtent: 100,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [Text(list[index].title)],
                    );
                  },
                ),
              ),
            )
          ],
        )
        // child: Column(children: [
        //   Align(
        //       alignment: Alignment.topLeft,
        //       child: Column(
        //         children: [
        //           Text(
        //             "NUTRITION INFO",
        //             style: TextStyle(
        //               fontSize: 20,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //           SizedBox(height: 10),
        //           Text(
        //             "Serving Size: 1 (145) g",
        //             style: TextStyle(
        //               fontSize: 15,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //           SizedBox(height: 10),
        //           Text(
        //             "Servings Per Recipe: 4",
        //             style: TextStyle(
        //               fontSize: 15,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //         ],
        //       )),
        //   SizedBox(
        //     height: 20,
        //   ),
        //   Divider(
        //     color: Colors.black,
        //     thickness: 3,
        //   ),
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       Text(
        //         "AMT. PER SERVING",
        //         style: TextStyle(
        //           fontSize: 15,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       Text(
        //         "% DAILY VALUE",
        //         style: TextStyle(
        //           fontSize: 15,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ],
        //   ),
        //   Divider(
        //     color: Colors.black,
        //     thickness: 3,
        //   ),
        //   Align(
        //     alignment: Alignment.topLeft,
        //     child: Text(
        //       "Calories: 153.3",
        //       style: TextStyle(
        //         fontSize: 17,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ]),
        );
  }

  datatable() {
    return DataTable(
      headingRowColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        return Colors.amber;
        // Use the default value.
      }),

      showBottomBorder: true,

      // dataRowColor:
      //     MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      //   return Colors.redAccent;
      // }),
      columns: [
        DataColumn(
          label: Text("Quantity"),
          tooltip: "Quantity",
          numeric: false,
        ),
        DataColumn(
          label: Text("Ingredients"),
          tooltip: "Quantity",
          numeric: false,
        ),
      ],
      rows: list
          .map((e) => DataRow(cells: [
                DataCell(
                  Text(e.quantity),
                ),
                DataCell(
                  Text(e.title),
                ),
              ]))
          .toList(),
    );
  }
}
