import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:mySobrero/common/utilities.dart';
import 'package:mySobrero/impostazioni.dart';
import 'package:mySobrero/reapi3.dart';

PreferredSize SobreroAppBar({
  BuildContext context,
  bool isBeta,
  String profilePicUrl,
  double scroll,
  UnifiedLoginStructure loginStructure,
  Function(String url) setProfileCallback}){
  return PreferredSize(
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
                          width: 33,
                          height: 33,
                          child: Image.asset('assets/images/logo_sobrero_grad.png'),
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
                            isBeta || isInternalBuild ? Text(
                              isInternalBuild ? " internal" : " beta",
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
                                        unifiedLoginStructure: loginStructure,
                                        profileURL: profilePicUrl,
                                        profileCallback: setProfileCallback),
                                    transitionDuration: Duration(milliseconds: 700),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
            color: Theme.of(context).primaryColor.withAlpha((255 * scroll).toInt()),
          )
        ],
        alignment: Alignment.bottomCenter,
      ),
    ),
  );
}