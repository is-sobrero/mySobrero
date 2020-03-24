import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mySobrero/impostazioni.dart';
import 'package:mySobrero/reapi3.dart';
import 'dart:ui';
import 'SobreroFeed.dart';
import 'mainview.dart';
import 'voti.dart';
import 'comunicazioni.dart';
import 'altro.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'custom_icons_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class HomeScreen extends StatefulWidget {
  //reAPI2 response;
  UnifiedLoginStructure unifiedLoginStructure;
  reAPI3 apiInstance;
  SobreroFeed feed;
  String profileUrl;
  bool isBeta = false;

  HomeScreen(
      {Key key,
      @required this.unifiedLoginStructure,
      @required this.feed,
      @required this.profileUrl,
      @required this.isBeta,
      @required this.apiInstance})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  PageController pageController = PageController();
  SobreroFeed feed;
  String profileUrl;

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
    if (_currentIndex != 0) {
      onTabTapped(0);
      return false;
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
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

  void initState() {
    super.initState();
    //response = widget.response;
    feed = widget.feed;
    profileUrl = widget.profileUrl;
    _mainViewInstance = Mainview(
        unifiedLoginStructure: widget.unifiedLoginStructure,
        apiInstance: widget.apiInstance,
        feed: widget.feed,
        callback: (page) => onTabTapped(page),
        profileUrl: widget.profileUrl);
    _votiViewInstance = VotiView(
      unifiedLoginStructure: widget.unifiedLoginStructure,
      apiInstance: widget.apiInstance,
    );
    _comunicazioniViewInstance = ComunicazioniView(
      unifiedLoginStructure: widget.unifiedLoginStructure,
      apiInstance: widget.apiInstance,
    );
    _altroViewInstance = AltroView(
      unifiedLoginStructure: widget.unifiedLoginStructure,
      apiInstance: widget.apiInstance,
    );
  }

  void dispose() {
    super.dispose();
  }

  double map(
      double x, double in_min, double in_max, double out_min, double out_max) {
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
  }

  bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
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
                      blurRadius: 12)
                ],
                color: Theme.of(context).scaffoldBackgroundColor
            ),
            child: Stack(
              children: <Widget>[
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          children: <Widget>[
                            Hero(
                              tag: "main_logosobre",
                              child: SizedBox(
                                width: 35,
                                height: 35,
                                child: Image.asset('assets/images/logo_sobrero_grad.png', scale: 1.1),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "mySobrero",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  widget.isBeta || isInDebugMode ? Text(
                                    isInDebugMode ? " internal" : " beta",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).primaryColor),
                                  ) : Container(),
                                ],
                              ),
                            ),
                            Spacer(), // use Spacer
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Material(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: IconButton(
                                  icon: new Image.asset(
                                    'assets/images/ic_settings_grad.png',
                                  ),
                                  tooltip: 'Apri le impostazioni dell\'App',
                                  iconSize: 14,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (_, __, ___)  => ImpostazioniView(
                                              unifiedLoginStructure: widget.unifiedLoginStructure,
                                              profileURL: profileUrl,
                                              profileCallback: (url) => profileUrl = url),
                                          transitionDuration: Duration(milliseconds: 1000),
                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                            var begin = Offset(0.0, 1.0);
                                            var end = Offset.zero;
                                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOutExpo));
                                            var offsetAnimation = animation.drive(tween);
                                            return SharedAxisTransition(
                                              child: child,
                                              animation: animation,
                                              secondaryAnimation: secondaryAnimation,
                                              transitionType: SharedAxisTransitionType.vertical,
                                            );
                                          },

                                        )
                                    );

                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 4,
                  color: Theme.of(context)
                      .primaryColor
                      .withAlpha((255 * scroll).toInt()),
                )
              ],
              alignment: Alignment.bottomCenter,
            ),
          ),
        ),
        body: PageView.builder(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                scroll = 0;
                _currentIndex = index;
              });
            },
            itemCount: 4,
            itemBuilder: (context, i) {
              var schermata;
              if (i == 0) schermata = _mainViewInstance;
              if (i == 1) schermata = _votiViewInstance;
              if (i == 2) schermata = _comunicazioniViewInstance;
              if (i == 3) schermata = _altroViewInstance;
              return NotificationListener<ScrollNotification>(
                onNotification: elaboraScroll,
                child: schermata,
              );
            }),
        bottomNavigationBar: Container(
          decoration:
              BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 10,
              spreadRadius: 10,
            )
          ]),
          child: SafeArea(
            bottom: true,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: GNav(
                  gap: 8,
                  color: Theme.of(context).disabledColor,
                  activeColor: Theme.of(context).primaryColor,
                  iconSize: 24,
                  tabBackgroundColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  duration: Duration(milliseconds: 300),
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      text: 'Home',
                    ),
                    GButton(
                      icon: CustomIcons.chart,
                      text: 'Voti',
                    ),
                    GButton(
                      icon: Icons.list,
                      text: 'Comunicazioni',
                    ),
                    GButton(
                      icon: CustomIcons.dot,
                      text: 'Altro',
                    )
                  ],
                  selectedIndex: _currentIndex,
                  onTabChange: (index) {
                    print(index);
                    setState(() {
                      _currentIndex = index;
                      pageController.animateToPage(index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    });
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
