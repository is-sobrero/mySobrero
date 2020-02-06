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
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
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


class _HomeState extends State<HomeScreen> {
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 35,
                      height: 35,
                      child: Image.asset('assets/images/logo_sobrero_grad.png',
                          scale: 1.1),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        "mySobrero",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0360e7)),
                      ),
                    ),
                    Spacer(), // use Spacer
                    Transform.scale(
                      scale: 0.8,
                      child: IconButton(
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
                    ),
                  ],
                ),
                pinned: true,
                forceElevated: innerBoxIsScrolled,
                elevation: 5,
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
              Mainview(response, feed, (int page) {
                onTabTapped(page);
              }, profileUrl),
              VotiView(response.voti),
              ComunicazioniView(response.comunicazioni),
              AltroView(response),
            ],
          ),
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