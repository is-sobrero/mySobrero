import 'package:flutter/material.dart';
import 'reapi.dart';
import 'reapi2.dart';
import 'dart:ui';
import 'SobreroFeed.dart';
import 'mainview.dart';
import 'voti.dart';
import 'comunicazioni.dart';
import 'altro.dart';
import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class HomeScreen extends StatefulWidget {
  reAPI2 response;
  SobreroFeed feed;

  HomeScreen(reAPI2 response, SobreroFeed feed) {
    this.response = response;
    this.feed = feed;
  }

  @override
  State<StatefulWidget> createState() {
    _firebaseMessaging.requestNotificationPermissions();
    return _HomeState(response, feed);
  }
}

class _HomeState extends State<HomeScreen> {
  int _currentIndex = 0;
  PageController pageController = PageController();
  reAPI2 response;
  SobreroFeed feed;

  _HomeState(reAPI2 response, SobreroFeed feed) {
    this.response = response;
    this.feed = feed;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Image.asset('assets/images/logo_sobrero_grad.png',
                          scale: 1.1),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        "mySobrero",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                floating: true,
                pinned: true,
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
              Mainview(response, feed, (int page){
                onTabTapped(page);
              }),
              VotiView(response.voti),
              ComunicazioniView(response.comunicazioni),
              AltroView(response),

            ],
          ),
        ),
        bottomNavigationBar: CubertoBottomBar(
          inactiveIconColor: Theme.of(context).textTheme.body1.color,
          tabStyle: CubertoTabStyle.STYLE_FADED_BACKGROUND, // By default its CubertoTabStyle.STYLE_NORMAL
          selectedTab: _currentIndex, // By default its 0, Current page which is fetched when a tab is clickd, should be set here so as the change the tabs, and the same can be done if willing to programmatically change the tab.
          tabs: [
            TabData(
              iconData: Icons.home,
              title: "Home",
              tabColor: Theme.of(context).primaryColor,
            ),
            TabData(
              iconData: Icons.trending_up,
              title: "Valutazioni",
              tabColor: Colors.pink,
            ),
            TabData(
              iconData: Icons.format_list_bulleted,
              title: "Comunicazioni",
              tabColor: Colors.amber),
            TabData(
              iconData: Icons.more_horiz,
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
        ),);
  }
}

class _TranslucentSliverAppBarDelegate extends SliverPersistentHeaderDelegate {

  /// This is required to calculate the height of the bar
  final EdgeInsets safeAreaPadding;

  _TranslucentSliverAppBarDelegate(this.safeAreaPadding);

  @override
  double get minExtent => safeAreaPadding.top;

  @override
  double get maxExtent => minExtent + kToolbarHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    print("reprint");
    return ClipRect(child: /*BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),*/
         Opacity(
            opacity: 0.85,
            child: Container(
              // Don't wrap this in any SafeArea widgets, use padding instead
                padding: EdgeInsets.only(top: safeAreaPadding.top),
                height: maxExtent,
                color: Theme.of(context).scaffoldBackgroundColor,
                // Use Stack and Positioned to create the toolbar slide up effect when scrolled up
                child: Stack(
                  overflow: Overflow.clip,
                  children: <Widget>[
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: AppBar(
                        brightness: Brightness.light,
                        primary: false,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        title: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Image.asset('assets/images/logo_sobrero_grad.png',
                                  scale: 1.1),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                "mySobrero",
                                style: TextStyle(

                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
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
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),

                      ),
                    )
                  ],
                )
            )
        //)
    ));
  }

  @override
  bool shouldRebuild(_TranslucentSliverAppBarDelegate old) {
    return maxExtent != old.maxExtent || minExtent != old.minExtent ||
        safeAreaPadding != old.safeAreaPadding;
  }
}