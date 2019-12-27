import 'package:flutter/material.dart';
import 'reapi.dart';
import 'package:mysobrero/mainview.dart';

class HomeScreen extends StatefulWidget {
  reAPI response;
  HomeScreen({Key key, @required this.response}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState(response);
  }
}

class _HomeState extends State<HomeScreen> {
  int _currentIndex = 0;
  PageController pageController = PageController();
  reAPI response;
  _HomeState(reAPI response){
    this.response = response;
  }

  void onTabTapped(int index) {
    pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.ease);
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              backgroundColor: Colors.transparent,
              title: Row(
                children: <Widget>[
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset('assets/images/logo_sobrero_grad.png', scale: 1.1),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                        "mySobrero",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF0360e7)
                      ),
                    ),
                  ),
                  Spacer(), // use Spacer
                  IconButton(
                    icon: new Image.asset('assets/images/ic_settings_grad.png'),
                    tooltip: 'Apri le impostazioni dell\'App',
                    onPressed: () {
                    },
                  ),
                ],
              ),
              floating: true,
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body: PageView(

          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: <Widget>[
            Mainview(response: response),
            Container(
              color: Colors.cyan,
            ),
            Container(
              color: Colors.deepPurple,
            ),
            Container(
              color: Colors.cyan,
            ),
            Container(
              color: Colors.deepPurple,
            ),
            Container(
              color: Colors.cyan,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // n
        // ew
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.trending_up),
            title: new Text('Voti'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: Text('Argomenti')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted),
              title: Text('Comunicazioni')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              title: Text('Altro')
          )

        ],
      ),
    );
  }
}