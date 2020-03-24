import 'package:flutter/material.dart';
import 'package:mySobrero/SobreroFeed.dart';

class FeedDetailView extends StatefulWidget {
  Items articolo;
  FeedDetailView({Key key, @required this.articolo}) : super(key: key);
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<FeedDetailView> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            brightness: Theme.of(context).brightness,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            snap: false,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                title: Text(widget.articolo.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 20, color: Theme.of(context).textTheme.body1.color
                    )),
                background: Image.network(
                  widget.articolo.thumbnail,
                  fit: BoxFit.cover,
                )
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(4),
              child: Container(color: Theme.of(context).primaryColor, height: 4,),
            ),
          ),
          new SliverList(
              delegate: new SliverChildListDelegate(_buildList(50))
          ),
        ],
      ),
    );
  }

  List _buildList(int count) {
    List<Widget> listItems = List();

    for (int i = 0; i < count; i++) {
      listItems.add(new Padding(padding: new EdgeInsets.all(20.0),
          child: new Text(
              'Item ${i.toString()}',
              style: new TextStyle(fontSize: 25.0)
          )
      ));
    }

    return listItems;
  }
}