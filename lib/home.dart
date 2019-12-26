import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen> {
  int _currentIndex = 0;
  PageController pageController = PageController();

  void onTabTapped(int index) {
    pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.ease);
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: <Widget>[
          Container(
            color: Colors.pink,
          ),
          Container(
            color: Colors.cyan,
          ),
          Container(
            color: Colors.deepPurple,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // n
        // ew
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.mail),
            title: new Text('Voti'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile')
          )
        ],
      ),
    );
  }
}