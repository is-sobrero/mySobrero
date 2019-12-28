import 'package:flutter/material.dart';
import 'reapi.dart';
import 'SobreroFeed.dart';
import 'mainview.dart';
import 'voti.dart';

class HomeScreen extends StatefulWidget {
  reAPI response;
  SobreroFeed feed;
  HomeScreen(reAPI response, SobreroFeed feed){
    this.response = response;
    this.feed = feed;
  }

  @override
  State<StatefulWidget> createState() {
    return _HomeState(response, feed);
  }
}

class _HomeState extends State<HomeScreen> {
  int _currentIndex = 0;
  PageController pageController = PageController();
  reAPI response;
  SobreroFeed feed;
  _HomeState(reAPI response, SobreroFeed feed){
    this.response = response;
    this.feed = feed;
  }

  BottomNavigationBarItem barIcon (String title, IconData icon){
    return BottomNavigationBarItem(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      icon: Icon(
        icon,
        color: Theme.of(context).textTheme.body1.color,
      ),
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      activeIcon: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
    );
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
                        fontWeight: FontWeight.bold,
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
            Mainview(response, feed),
            VotiView(response.voti),
            Container(
              color: Colors.deepPurple,
            ),
            Container(
              color: Colors.cyan,
            ),
            Container(
              color: Colors.deepPurple,
            ),
          ],
        ),
      ),
      /*onTap: onTabTapped,
          currentIndex: _currentIndex,
      */
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          barIcon("Home", Icons.home),
          barIcon("Voti", Icons.trending_up),
          barIcon("Argomenti", Icons.book),
          barIcon("Comunicazioni", Icons.format_list_bulleted),
          barIcon("Altro", Icons.more_horiz),
        ],
      )
    );
  }


}