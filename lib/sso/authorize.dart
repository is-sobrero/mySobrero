import 'dart:convert';

import 'package:mySobrero/sso/authentication_qr.dart';

class SSOAuthorize {

  static AuthenticationQR getDetails ({
    String data,
  }) {
    AuthenticationQR _req;
    try {
      var json = jsonDecode(data);
      _req = AuthenticationQR.fromJson(json);
      return _req;
    } on FormatException catch (e){
      return null;
    }
  }

}