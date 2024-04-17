import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_recipe/recipe_info.dart';
import 'package:flutter/material.dart';

class hero extends StatefulWidget {
  @override
  _heroState createState() => _heroState();
}

class _heroState extends State<hero> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "imageHero",
      child: Scaffold(
        appBar: AppBar(
          title: Text('Main Screen'),
        ),
        body: Card(
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return recipe_info(
                    url:
                        "https://www.webrooper.com/androiddb/uploads/pizza.jpg");
              }));
            },
            child: Container(
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //mostviewed
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      child: Container(
                        height: 100,
                        width: 150,
                        child: CachedNetworkImage(
                          imageUrl: 'https://picsum.photos/250?image=9',
                          fit: BoxFit.fill,
                        ),
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Flexible(
                    child: Text(
                      "sadasd",
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "By ",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  Text(
                    "Cooking Time: min",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(
                    height: 5,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
