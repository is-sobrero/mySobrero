import 'package:flutter/material.dart';

Widget CircularProfile ({String sender, double radius}){
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius * 10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 10,
              spreadRadius: 4,
              offset: Offset(0, 2)
          )
        ]
    ),
    child: sender.toUpperCase() == "DIRIGENTE" ?
    CircleAvatar(
      backgroundImage: AssetImage("assets/images/rota.png"),
      radius: radius,
    ) :
    CircleAvatar(
      child: Text("GR", style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.white,
      radius: radius,
    ),
  );
}