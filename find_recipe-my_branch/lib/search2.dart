import 'package:connectivity/connectivity.dart';
import 'package:find_recipe/responses.dart';
import 'package:flutter/material.dart';

class search2 extends StatefulWidget {
  @override
  _search2State createState() => _search2State();
}

class _search2State extends State<search2> {
  List<filter> _list = [];
  List<filter> to_display = [];

  bool isoffline;
  TextEditingController _controller = TextEditingController();
  int i = 1;
  Future<void> connectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
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
      print(
          "dissconneteddsfffffffffffffffffffffffffffffffffffffffffffffffffffffffdsfsd");
    }
  }

  Future _future;
  @override
  void initState() {
    super.initState();
    getmoredata().then((value) {
      setState(() {
        _list = to_display = value;
      });
    });
    connectivity();
    _future = data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
              padding: EdgeInsets.fromLTRB(20, 65, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      shadowColor: Colors.grey[350],
                      elevation: 2,
                      child: TextField(
                        controller: _controller,
                        onChanged: (text) {
                          text = text.toLowerCase();
                          setState(() {
                            to_display = _list.where((element) {
                              var title = element.title.toLowerCase();
                              return title.contains(text);
                            }).toList();
                          });
                        },
                        cursorWidth: 1.0,
                        decoration: InputDecoration(
                            hintText: "Search by ingredients",
                            contentPadding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                            suffixIcon: _controller.text.isNotEmpty
                                ? IconButton(
                                    splashRadius: 20,
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        _controller.clear();
                                      });
                                    })
                                : null,
                            // prefixIcon: IconButton(
                            //     splashRadius: 20,
                            //     padding: EdgeInsets.only(left: 10),
                            //     icon: Icon(Icons.arrow_back_ios),
                            //     onPressed: () => Navigator.pop(context)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              borderSide: BorderSide(
                                color: Colors.grey[300],
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                borderSide:
                                    BorderSide(color: Colors.grey[350]))),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.tune),
                      splashRadius: 20,
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              )),

          // Padding(
          //   padding: EdgeInsets.fromLTRB(20, 65, 20, 20),
          //   child: Material(
          //     borderRadius: BorderRadius.all(Radius.circular(50)),
          //     shadowColor: Colors.grey[350],
          //     elevation: 2,
          //     child: TextField(
          //       controller: _controller,
          //       onChanged: (text) {
          //         text = text.toLowerCase();
          //         setState(() {
          //           to_display = _list.where((element) {
          //             var title = element.title.toLowerCase();
          //             return title.contains(text);
          //           }).toList();
          //         });
          //       },
          //       cursorWidth: 1.0,
          //       decoration: InputDecoration(
          //           hintText: "Search recipes",
          //           contentPadding: EdgeInsets.all(10),
          //           suffixIcon: _controller.text.isNotEmpty
          //               ? IconButton(
          //                   splashRadius: 20,
          //                   icon: Icon(Icons.close),
          //                   onPressed: () {
          //                     setState(() {
          //                       _controller.clear();
          //                     });
          //                   })
          //               : null,
          //           prefixIcon: IconButton(
          //               splashRadius: 20,
          //               padding: EdgeInsets.only(left: 10),
          //               icon: Icon(Icons.arrow_back_ios),
          //               onPressed: () => Navigator.pop(context)),
          //           enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.all(Radius.circular(50)),
          //             borderSide: BorderSide(
          //               color: Colors.grey[300],
          //             ),
          //           ),
          //           focusedBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.all(Radius.circular(50)),
          //               borderSide: BorderSide(color: Colors.grey[350]))),
          //     ),
          //   ),
          // ),

          // Expanded(
          //     child: FutureBuilder(
          //   future: _future,
          //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //     return GridView.builder(
          //         itemCount: to_display.length,
          //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //             crossAxisCount: 2),
          //         itemBuilder: (context, index) {
          //           if (snapshot.connectionState == ConnectionState.waiting) {
          //             return Center(
          //               child: CircularProgressIndicator(),
          //             );
          //           } else if (snapshot.hasData) {
          //             return Card(
          //               elevation: 5,
          //               shadowColor: Colors.grey[350],
          //               shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.all(Radius.circular(8))),
          //               child: Column(
          //                 children: [
          //                   ClipRRect(
          //                     borderRadius: BorderRadius.only(
          //                         topRight: Radius.circular(8),
          //                         topLeft: Radius.circular(8)),
          //                     child: Container(
          //                         height: 90,
          //                         width: MediaQuery.of(context).size.width,
          //                         child: Image.network(
          //                           snapshot.data[index].imgurl,
          //                           fit: BoxFit.fill,
          //                         )),
          //                   )
          //                 ],
          //               ),
          //             );
          //           }
          //         });
          //   },
          // )
          Expanded(
              child: isoffline != false
                  ? _controller.text.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                            Text("Search by Ingerdients")
                          ],
                        )
                      : to_display.length != 0
                          ? CustomScrollView(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              slivers: [
                                  SliverGrid(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        return FutureBuilder(
                                          future: _future,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }

                                            if (snapshot.hasError) {
                                              return Center(
                                                  child: Text(
                                                      "Something went wrong"));
                                            } else if (snapshot.hasData &&
                                                snapshot.data.isNotEmpty) {
                                              return Card(
                                                elevation: 5,
                                                shadowColor: Colors.grey[350],
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                                child: Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(8),
                                                              topLeft: Radius
                                                                  .circular(8)),
                                                      child: Container(
                                                          height: 90,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Image.network(
                                                            snapshot.data[index]
                                                                .imgurl,
                                                            fit: BoxFit.fill,
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return Center(
                                                child: Text("Empty"),
                                              );
                                            }
                                          },
                                        );
                                      },
                                      childCount: to_display.length,
                                    ),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                    ),
                                  ),
                                ])
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Text(
                                    "Oops!",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Center(
                                    child: Text(
                                      "We could not understand what you mean, try repharasing the query.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                ])
                  : Center(child: Text("No internet")))
        ]),
      ),
    );
  }
}
