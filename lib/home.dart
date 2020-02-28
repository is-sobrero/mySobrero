import 'package:flutter/material.dart';
import 'package:mySobrero/impostazioni.dart';
import 'reapi2.dart';
import 'dart:ui';
import 'SobreroFeed.dart';
import 'mainview.dart';
import 'voti.dart';
import 'comunicazioni.dart';
import 'altro.dart';
import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'custom_icons_icons.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class HomeScreen extends StatefulWidget {
  reAPI2 response;
  SobreroFeed feed;
  String profileUrl;

  HomeScreen(reAPI2 response, SobreroFeed feed, String profileUrl) {
    this.response = response;
    this.feed = feed;
    this.profileUrl = profileUrl;
  }

  @override
  State<StatefulWidget> createState() {
    _firebaseMessaging.requestNotificationPermissions();
    return _HomeState(response, feed, profileUrl);
  }
}


class _HomeState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  int _currentIndex = 0;
  PageController pageController = PageController();
  reAPI2 response;
  SobreroFeed feed;
  String profileUrl;

  _HomeState(reAPI2 response, SobreroFeed feed, String profileUrl) {
    this.response = response;
    this.feed = feed;
    this.profileUrl = profileUrl;
  }

  BottomNavigationBarItem barIcon(String title, IconData icon) {
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
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.ease);
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex != 0){
      onTabTapped(0);
      return false;
    }
    return true;
  }

  int scrollThreshold = 100;
  double scroll = 0;

  bool elaboraScroll(ScrollNotification scrollNotification) {
    if (scrollNotification is ScrollUpdateNotification) {
      double oldScroll = scroll;
      scroll = scrollNotification.metrics.pixels;
      if (scroll < 0)
        scroll = 0;
      else if (scroll > scrollThreshold)
        scroll = 1;
      else
        scroll /= scrollThreshold;
      if (oldScroll - scroll != 0) setState(() {});
    }
    return true;
  }

  Mainview _mainViewInstance;
  VotiView _votiViewInstance;
  ComunicazioniView _comunicazioniViewInstance;
  AltroView _altroViewInstance;

  void initState(){
    super.initState();
    _mainViewInstance = Mainview(response, feed, (int page) {
        onTabTapped(page);
      }, profileUrl);
    _votiViewInstance = VotiView(response.voti1q, response.voti2q);
    _comunicazioniViewInstance = ComunicazioniView(response.comunicazioni);
    _altroViewInstance = AltroView(response);
  }

  void dispose() {
    super.dispose();
  }

  double map(double x, double in_min, double in_max, double out_min, double out_max)
  {
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 57),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).primaryColor.withAlpha((100 * scroll).toInt()),
                    spreadRadius: 7,
                    blurRadius: 12
                )
              ],
/*
                border: Border(
                    bottom: BorderSide(
                        color: Theme.of(context).primaryColor.withAlpha((255 * scroll).toInt()),
                        width: 4
                    )
                ),
*/
              color: Theme.of(context).scaffoldBackgroundColor
            ),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width:  35,
                          height:  35,
                          child: Image.asset('assets/images/logo_sobrero_grad.png',
                              scale: 1.1),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            "mySobrero",
                            style: TextStyle(
                                fontSize:  17,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0360e7)),
                          ),
                        ),
                        Spacer(), // use Spacer
                        IconButton(
                            icon: new Image.asset(
                              'assets/images/ic_settings_grad.png',
                            ),
                            tooltip: 'Apri le impostazioni dell\'App',
                            iconSize: 14,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ImpostazioniView(response, profileUrl, (url){
                                  profileUrl = url;
                                  print("Nuova url: $url");
                                })),
                              );
                            },
                          ),

                      ],
                    ),
                  ),
                  Container(
                    height: 4,
                    color: Theme.of(context).primaryColor.withAlpha((255 * scroll).toInt()),
                  )
                ],
              ),
            ),
          ),
        ),
        body: /*PageView(

              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  scroll = 0;
                  _currentIndex = index;
                });
              },
              children: <Widget>[
                NotificationListener<ScrollNotification>(
                  onNotification: elaboraScroll,
                  child: Mainview(response, feed, (int page) {
                    onTabTapped(page);
                  }, profileUrl),
                ),
                NotificationListener<ScrollNotification>(
                  onNotification: elaboraScroll,
                  child: VotiView(response.voti1q, response.voti2q),
                ),
                NotificationListener<ScrollNotification>(
                  onNotification: elaboraScroll,
                  child: ComunicazioniView(response.comunicazioni),
                ),
                NotificationListener<ScrollNotification>(
                  onNotification: elaboraScroll,
                  child: AltroView(response),
                ),
              ],
          ),*/
        PageView.builder(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              scroll = 0;
              _currentIndex = index;
            });
          },
            itemCount: 4,
          itemBuilder: (context, i){
            var schermata;
            if (i == 0) schermata =  _mainViewInstance;
            if (i == 1) schermata = _votiViewInstance;
            if (i == 2) schermata = _comunicazioniViewInstance;
            if (i == 3) schermata = _altroViewInstance;
            return NotificationListener<ScrollNotification>(
              onNotification: elaboraScroll,
              child: schermata,
            );
          }
        ),

        bottomNavigationBar: CubertoBottomBar(
          inactiveIconColor: Theme.of(context).textTheme.body1.color,
          tabStyle: CubertoTabStyle
              .STYLE_FADED_BACKGROUND,
          selectedTab:
              _currentIndex,
          tabs: [
            TabData(
              iconData: Icons.home,
              title: "Home",
              tabColor: Theme.of(context).primaryColor,
            ),
            TabData(
              iconData: CustomIcons.chart,
              title: "Valutazioni",
              tabColor: Colors.pink,
            ),
            TabData(
                iconData: Icons.list,
                title: "Comunicazioni",
                tabColor: Colors.amber),
            TabData(
                iconData: CustomIcons.dot,
                title: "Altro",
                tabColor: Colors.teal),
          ],
          onTabChangedListener: (position, title, color) {
            setState(() {
              pageController.animateToPage(position,
                  duration: Duration(milliseconds: 200), curve: Curves.ease);
              setState(() {
                _currentIndex = position;
              });
            });
          },
        ),
      ),
    );
  }
}