import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:mySobrero/common/ui.dart';

class ListingsHomePage extends StatefulWidget {
  ListingsHomePage({
    Key key
  }) : super(key: key);

  @override
  _ListingsHomeState createState() => _ListingsHomeState();
}

class _ListingsHomeState extends State<ListingsHomePage> {
  @override
  Widget build(BuildContext context){
    return DetailView(
      tag: "listings_home",
      title: "Resell@Sobrero",
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SobreroTextField(
            hintText: "Cerca qualcosa",
            margin: EdgeInsets.only(top: 10, bottom: 10),
            suffixIcon: IconButton(
              icon: Icon(LineIcons.search),
              color: Theme.of(context).primaryColor,
              onPressed: () => print("ok"),
            ),
          ),
          Text(
            "Ultimi annunci",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            "Libri",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            "Ripetizioni",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            "Vario",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}