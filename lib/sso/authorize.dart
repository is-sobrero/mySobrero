// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

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