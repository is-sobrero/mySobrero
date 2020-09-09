// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mySobrero/ui/layouts.dart';

void main(){
  MaterialApp app1 = MaterialApp(
    home: Scaffold(
        body: SobreroLayout.rPage(
            //title: "MainViewSimpleContainer test",
            children: [
              Text("Test child"),
              Text("Test child"),
              Text("Test child"),
              Text("Test child"),
              Text("Test child"),
            ],
        ),
    ),
  );

 /* MaterialApp app2 = MaterialApp(
    home: Scaffold(
      body: Flex(
        direction: Axis.horizontal,
        children: [
          CounterTile(
            onTap: () => null,
            padding: EdgeInsets.only(right: 5),
            highColor: Colors.purple,
            lowColor: Colors.purple,
            textColor: Colors.white,
            primaryText: "777",
            secondaryText: "CounterTile Test",
            showImage: false,
            image: "assets/icons/test",
          ),
        ],
      ),
    ),
  );*/


  testWidgets("MainViewSimpleContainer test", (tester) async {
    await tester.pumpWidget(app1);
    final titleFinder = find.text('MainViewSimpleContainer test');
    final childrenFinder = find.text("Test child");

    expect (titleFinder, findsOneWidget);
    expect (childrenFinder, findsNWidgets(5));
    expect (find.byType(SafeArea), findsOneWidget);
  });

 /* testWidgets("Homescreen CounterTile test", (tester) async {
    await tester.pumpWidget(app2);

    final primaryFinder = find.text('777');
    final secondaryFinder = find.text("CounterTile Test");

    expect (primaryFinder, findsOneWidget);
    expect (secondaryFinder, findsOneWidget);
    //expect (find.byType(CounterTile), findsOneWidget);
    expect (find.byType(AutoSizeText), findsOneWidget);
    expect (find.byType(GestureDetector), findsOneWidget);
    expect (find.byType(AspectRatio), findsOneWidget);
  });*/
}