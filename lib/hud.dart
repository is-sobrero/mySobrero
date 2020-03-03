import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class dialogoHUD extends StatelessWidget{
  Future<bool> future;
  String titolo;
  dialogoHUD({Key key, @required this.titolo, @required this.future}) : super(key: key);

  @override
  Widget build (BuildContext context){
    future.then((bool){
      Navigator.of(context).pop();
    });

    return Dialog(
      backgroundColor: Theme.of(context).cardColor.withAlpha(240),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), //this right here
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: SpinKitDualRing(
                            color: Colors.white,
                            size: 50.0,
                            lineWidth: 3,
                          ),
                        ),
                         AutoSizeText(
                            titolo,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

}