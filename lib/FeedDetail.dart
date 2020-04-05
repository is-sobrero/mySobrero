import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:mySobrero/SobreroFeed.dart';
import 'package:flutter_html/flutter_html.dart';


class FeedDetailView extends StatefulWidget {
  Items articolo;
  FeedDetailView({Key key, @required this.articolo}) : super(key: key);
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<FeedDetailView> with SingleTickerProviderStateMixin {

  double scroll = 0.0;
  int scrollThreshold = 300;
  double oldScroll = 0;

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

  void openURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          extraCustomTabs: <String>[
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }



  @override
  void initState(){
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    print(widget.articolo.pubDate);
    return Scaffold(
      extendBodyBehindAppBar: true,
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
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(scroll)
          ),
          child: Stack(
            children: <Widget>[
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 15),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: FloatingActionButton(
                              onPressed: () => Navigator.of(context).pop(),
                              mini: true,
                              child: Icon(Icons.arrow_back, color: Theme.of(context).textTheme.body1.color,),
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              elevation: 0,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.articolo.title,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).textTheme.body1.color.withOpacity(scroll),),
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
                color: Theme.of(context).primaryColor.withOpacity(scroll),
              )
            ],
            alignment: Alignment.bottomCenter,
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: elaboraScroll,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 10,
                          spreadRadius: 5
                      )
                    ]
                ),
                child: Column(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: widget.articolo.thumbnail,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.articolo.title, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
                    Html(
                      data: widget.articolo.content,
                      padding: EdgeInsets.only(top: 10),
                      showImages: false,
                      onLinkTap: (url) {
                        openURL(context, url);
                      }
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: ImageIcon(
                  AssetImage("assets/images/logo_sobrero_tb.png"),
                  color: Theme.of(context).textTheme.body1.color.withOpacity(0.3),
                  size: 40,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 90),
                child: Text(
                    "Contenuto di proprietà dell'I.S. \"A. Sobrero\"",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.body1.color.withOpacity(0.3),
                      fontWeight: FontWeight.bold,
                      fontSize: 17
                    ), textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          openURL(context, widget.articolo.link);
        },
        label: Text('Apri nel browser'),
        icon: Icon(Icons.open_in_browser),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

}