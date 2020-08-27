import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/ui/helper.dart';

class SobreroLoading extends StatelessWidget{
  final String loadingStringKey;
  SobreroLoading({
    Key key,
    @required this.loadingStringKey,
  }) :  assert(loadingStringKey != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(15.0),
    child: Center(
      child: Column(
        children: <Widget>[
          SpinKitDualRing(
            color: Theme.of(context).textTheme.bodyText1.color,
            size: 40,
            lineWidth: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              AppLocalizations.of(context).translate(loadingStringKey),
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}

class SobreroError extends StatelessWidget{
  final String snapshotError;
  SobreroError({
    Key key,
    @required this.snapshotError,
  }) :  assert(snapshotError != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
    child: Column(
      children: <Widget>[
        Icon(Icons.warning, size: 40,),
        Text(snapshotError,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

class SobreroEmptyState extends StatelessWidget {
  // TODO: schermi grandi
  SobreroEmptyState({
    Key key,
    @required this.emptyStateKey,
  }) :  assert(emptyStateKey != null),
        super(key: key);

  final String emptyStateKey;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Flex(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        direction: UIHelper.isWide(context)
            ? Axis.horizontal : Axis.vertical,
        children: [
          Container(
            width: 200,
            height: 200,
            child: FlareActor(
              "assets/animations/empty.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "idle",
            ),
          ),
          Text(
            AppLocalizations.of(context).translate(emptyStateKey),
            style: TextStyle(
                fontSize: 20
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}