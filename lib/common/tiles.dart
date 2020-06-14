import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mySobrero/common/skeleton.dart';

Widget CounterTile ({@required double aspectRatio, EdgeInsets padding, int flex, @required Function onTap, Color highColor, Color lowColor, Color textColor, String primaryText, String secondaryText, bool showImage = false, String imagePath}) {
  return Expanded(
    flex: flex,
    child: GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            decoration: new BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: lowColor.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(11)),
                gradient: LinearGradient(
                  begin: FractionalOffset.topRight,
                  end: FractionalOffset.bottomRight,
                  colors: <Color>[
                    highColor, lowColor
                  ],
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  showImage ? Image.asset(imagePath) : Text(
                    primaryText,
                    style: new TextStyle(
                        fontSize: 65,
                        color: textColor
                    ),
                  ),
                  AutoSizeText(
                    secondaryText,
                    style: new TextStyle(
                        color: textColor,
                        fontSize: 14
                    ),
                    maxLines: 2,
                    minFontSize: 7,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget DetailTile ({@required double aspectRatio, EdgeInsets padding, int flex, @required Function onTap, Color highColor, Color lowColor, Widget body}) {
  return Expanded(
    flex: flex,
    child: GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            decoration: new BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: lowColor.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(11)),
                gradient: LinearGradient(
                  begin: FractionalOffset.topRight,
                  end: FractionalOffset.bottomRight,
                  colors: <Color>[
                    highColor, lowColor
                  ],
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: body,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget NewsTile({BuildContext context, bool safeLeft = false, bool safeRight = false, String leadingImageUrl, String title, StatefulWidget detailView}) {
  return SafeArea(
    bottom: false,
    left: safeLeft,
    right: safeRight,
    top: false,
    child: Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(30),
                  blurRadius: 10,
                  spreadRadius: 5
              )
            ]
        ),
        width: 300,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: OpenContainer(
                closedColor: Theme.of(context).scaffoldBackgroundColor,
                openColor: Theme.of(context).scaffoldBackgroundColor,
                closedBuilder: (c, action) => Stack(
                  alignment: Alignment.bottomLeft,
                  children: <Widget>[
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: leadingImageUrl,
                        placeholder: (context, url) => Skeleton(),
                        errorWidget: (context, url, error) => Container(
                            color: Theme.of(context).textTheme.bodyText1.color.withAlpha(40),
                            width: 300,
                            child: Center(child: Icon(Icons.broken_image, size: 70))
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.black87, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15,30,15,25),
                        child: Text(
                          title,
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                openBuilder: (c, action) => detailView,
                tappable: true
            )
        ),
      ),
    ),
  );
}