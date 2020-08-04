import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mySobrero/localization/localization.dart';

class SobreroLoading extends StatelessWidget{
  String loadingStringKey;
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
  String snapshotError;
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

  String emptyStateKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset("assets/images/empty_state.png", width: 200,),
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