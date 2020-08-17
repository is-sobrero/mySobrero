// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

class UriIntent {
  static List<String> _supportedMethods = [
    'idp', 'open'
  ];

  static bool isInvokingMethod (String url){
    String method = RegExp(
      "(?<=:\/\/).+?(?=\/)",
      caseSensitive: false,
      multiLine: false,
    ).stringMatch(url).toString();
    return method != null;
  }

  static bool isMethodSupported (String url) {
    String method = RegExp(
      "(?<=:\/\/).+?(?=\/)",
      caseSensitive: false,
      multiLine: false,
    ).stringMatch(url).toString();
    if (method == null) return false;
    return _supportedMethods.contains(method);
  }

  static String getArgument (String url, String intent) => RegExp(
    "(?<=$intent\/).+?(?=\/)",
    caseSensitive: false,
    multiLine: false,
  ).stringMatch(url).toString();

  static String getMethodName (String url) => RegExp(
    "(?<=:\/\/).+?(?=\/)",
    caseSensitive: false,
    multiLine: false,
  ).stringMatch(url).toString();


}