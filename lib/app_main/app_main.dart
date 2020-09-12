// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animations/animations.dart';

import 'package:mySobrero/app_main/app_home.dart';

import 'package:mySobrero/app_main/more.dart';
import 'package:mySobrero/app_main/votes.dart';
import 'package:mySobrero/app_main/communications.dart';
import 'package:mySobrero/feed/sobrero_feed.dart';
import 'package:mySobrero/impostazioni.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/sso/sso.dart';
import 'package:mySobrero/ui/button.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:mySobrero/ui/layouts.dart';
import 'package:mySobrero/ui/sobrero_appbar.dart';
import 'package:mySobrero/ui/drawer.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class AppMain extends StatefulWidget {
  UnifiedLoginStructure unifiedLoginStructure;
  reAPI3 apiInstance;
  SobreroFeed feed;
  String profileUrl;
  bool isBeta = false;

  AppMain({
    Key key,
    @required this.unifiedLoginStructure,
    @required this.feed,
    @required this.profileUrl,
    @required this.isBeta,
    @required this.apiInstance}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> with SingleTickerProviderStateMixin {
  int _currentPageIndex = 0;
  String _profileUrl;
  double _globalScroll = 0;

  int _scrollThreshold = 100;

  VotesPage _votesPageInstance;
  CommunicationsPageView _communicationsPageView;
  MorePageView _morePageInstance;
  Homepage _homepageNewInstance;

  PageController pageController = PageController();

  List<TargetFocus> _targets = List();

  GlobalKey _menuGK = GlobalKey();
  GlobalKey _marksGK = GlobalKey();
  GlobalKey _settingsGK = GlobalKey();

  void _initTutorialTargets(){
    _targets.add(
      TargetFocus(
        keyTarget: _menuGK,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate("actionsMenu"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: Text(
                        AppLocalizations.of(context).translate("actionsMenuDesc"),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context).translate("clickToContinue"),
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
    _targets.add(
      TargetFocus(
        keyTarget: _marksGK,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).translate("summaryButtons"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                      child: Text(
                        AppLocalizations.of(context).translate("summaryButtonsDesc"),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context).translate("clickToContinue"),
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ))
        ],
        shape: ShapeLightFocus.Circle,
      ),
    );
    _targets.add(
      TargetFocus(
        keyTarget: _settingsGK,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).translate("settingsButton"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                      child: Text(
                        AppLocalizations.of(context).translate("settingsButtonDesc"),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context).translate("clickToEnd"),
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  void _afterLayout(_) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _hasTutorialShown = prefs.getBool('tutorialShown') ?? false;
    if (!_hasTutorialShown) {
      Future.delayed(
        Duration(milliseconds: 700),
            (){
              _initTutorialTargets();
              TutorialCoachMark(
                context,
                targets: _targets,
                colorShadow: Colors.black,
                textSkip: AppLocalizations.of(context).translate("skip"),
                paddingFocus: 7,
                opacityShadow: 0.8,
                onFinish: () => prefs.setBool('tutorialShown', true),
                onClickSkip: () => prefs.setBool('tutorialShown', true),
              )..show();
          },
      );

    }
  }

  void switchPage(bool needToSwitch, int page){
    if (needToSwitch){
      pageController.animateToPage(
          page,
          duration: Duration(milliseconds: 200), curve: Curves.ease
      );
    }
    setState(() {
      _globalScroll = 0;
      _currentPageIndex = page;
    });
  }

  Future<bool> _handleBackButton() async {
    if (_currentPageIndex != 0) {
      switchPage(true, 0);
      return false;
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return true;
  }

  void _updateProfilePicture(String url) {
    setState(() {
      _profileUrl = url;
    });
  }

  @override
  void initState(){
    super.initState();
    _profileUrl = widget.profileUrl;
    print(_profileUrl);
    _votesPageInstance = VotesPage(
      unifiedLoginStructure: widget.unifiedLoginStructure,
      apiInstance: widget.apiInstance,
    );
    _homepageNewInstance = Homepage(
      unifiedLoginStructure: widget.unifiedLoginStructure,
      apiInstance: widget.apiInstance,
      feed: widget.feed,
      switchPageCallback: (page) => switchPage(true, page),
      marksGlobalKey: _marksGK
    );
    _communicationsPageView = CommunicationsPageView(
      unifiedLoginStructure: widget.unifiedLoginStructure,
      apiInstance: widget.apiInstance,
    );
    _morePageInstance = MorePageView(
      unifiedLoginStructure: widget.unifiedLoginStructure,
      apiInstance: widget.apiInstance,
    );
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  bool elaboraScroll(ScrollNotification scrollNotification) {
    if (scrollNotification is ScrollUpdateNotification) {
      double oldScroll = _globalScroll;
      _globalScroll = scrollNotification.metrics.pixels;
      if (_globalScroll < 0)
        _globalScroll = 0;
      else if (_globalScroll > _scrollThreshold)
        _globalScroll = 1;
      else
        _globalScroll /= _scrollThreshold;
      if (oldScroll - _globalScroll != 0) setState(() {});
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackButton,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Theme.of(context).brightness
        ),
        child: SobreroLayout.rScaffold(
          isWide: UIHelper.isPad(context),
          appBar: SobreroAppBar(
            elevation: _globalScroll,
            topCorrection: window.padding.top > 0 ? 3 : 0,
            profilePicUrl: _profileUrl,
            loginStructure: widget.unifiedLoginStructure,
            session: widget.apiInstance.getSession(),
            setProfileCallback: (url) => setState((){
              _profileUrl = url;
            }),
            settingsGlobalKey: _settingsGK,
            menuGlobalKey: _menuGK
          ),
          drawer: SobreroDrawer(
            isPad: false,
            children: [
              SobreroDrawerButton(
                margin: EdgeInsets.only(top: 15),
                suffixIcon: TablerIcons.home,
                text: AppLocalizations.of(context).translate('home'),
                color: Theme.of(context).primaryColor,
                isSelected: _currentPageIndex == 0,
                onPressed: () => switchPage(true, 0),
              ),
              SobreroDrawerButton(
                suffixIcon: TablerIcons.trending_up,
                text: AppLocalizations.of(context).translate('marks'),
                color: Theme.of(context).primaryColor,
                isSelected: _currentPageIndex == 1,
                onPressed: () => switchPage(true, 1),
              ),
              SobreroDrawerButton(
                suffixIcon: TablerIcons.mail,
                text: AppLocalizations.of(context).translate('memos'),
                color: Theme.of(context).primaryColor,
                isSelected: _currentPageIndex == 2,
                onPressed: () => switchPage(true, 2),
              ),
              SobreroDrawerButton(
                margin: EdgeInsets.only(bottom: 10),
                suffixIcon: TablerIcons.dots,
                text: AppLocalizations.of(context).translate('more'),
                color: Theme.of(context).primaryColor,
                isSelected: _currentPageIndex == 3,
                onPressed: () => switchPage(true, 3),
              ),
              SobreroDrawerButton(
                margin: EdgeInsets.only(top: 15),
                suffixIcon: TablerIcons.lock_open,
                text: AppLocalizations.of(context).translate("authorizeApp"),
                color: Theme.of(context).primaryColor,
                onPressed: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (a, b, c) => SSOProvider(
                      session: widget.apiInstance.getSession(),
                    ),
                    transitionDuration: Duration(
                      milliseconds: UIHelper.pageAnimDuration,
                    ),
                    transitionsBuilder: (_, p, s, c) => SharedAxisTransition(
                      animation: p,
                      secondaryAnimation: s,
                      transitionType: SharedAxisTransitionType.scaled,
                      child: c,
                    ),
                  ),
                ),
              ),
              SobreroDrawerButton(
                margin: EdgeInsets.only(bottom: 10),
                suffixIcon: TablerIcons.settings,
                text: AppLocalizations.of(context).translate("settings"),
                color: Theme.of(context).primaryColor,
                onPressed: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (a, b, c) => ImpostazioniView(
                      unifiedLoginStructure: widget.unifiedLoginStructure,
                      profileURL: _profileUrl,
                      profileCallback: (url) => setState((){
                        _profileUrl = url;
                      }),
                      session: widget.apiInstance.getSession(),
                    ),
                    transitionDuration: Duration(
                      milliseconds: UIHelper.pageAnimDuration,
                    ),
                    transitionsBuilder: (_, p, s, c) => SharedAxisTransition(
                      animation: p,
                      secondaryAnimation: s,
                      transitionType: SharedAxisTransitionType.scaled,
                      child: c,
                    ),
                  ),
                ),
              ),
              SobreroDrawerButton(
                margin: EdgeInsets.only(top: 15),
                suffixIcon: TablerIcons.logout,
                text: "Disconnettiti",
                color: Colors.red,
              ),
            ],
          ),
          body: PageView.builder(
              controller: pageController,
              onPageChanged: (index) => switchPage(false, index),
              itemCount: 4,
              itemBuilder: (context, i) {
                var schermata;
                if (i == 0) schermata = _homepageNewInstance;
                if (i == 1) schermata = _votesPageInstance;
                if (i == 2) schermata = _communicationsPageView;
                if (i == 3) schermata = _morePageInstance;
                return NotificationListener<ScrollNotification>(
                    onNotification: elaboraScroll,
                    child: schermata
                );
              },
            ),
        ),
      ),
    );
  }
}
