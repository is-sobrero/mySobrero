// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:googleapis_auth/auth.dart';

class GSuiteConnector {
  GSuiteConnector._internal(){
    if (Platform.isAndroid) {
      _credentials = new ClientId(
        "TODO: android_cred",
        "",
      );
    } else if (Platform.isIOS) {
      _credentials = new ClientId(
        "405003841721-la8qle96b2si82894f1hdl1ie30nlbu5.apps.googleusercontent.com",
        "",
      );
    }
  }
  static final GSuiteConnector instance = GSuiteConnector._internal();

  var _credentials;
}