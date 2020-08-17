// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

class AuthenticationQR {
  String domain;
  String session;
  String clientIp;
  String clientCountry;
  String clientCity;
  String clientLat;
  String clientLog;
  int timestamp;
  String method;

  AuthenticationQR(
      {this.domain,
        this.session,
        this.clientIp,
        this.clientCountry,
        this.clientCity,
        this.clientLat,
        this.clientLog,
        this.timestamp,
        this.method});

  AuthenticationQR.fromJson(Map<String, dynamic> json) {
    domain = json['domain'];
    session = json['session'];
    clientIp = json['client_ip'];
    clientCountry = json['client_country'];
    clientCity = json['client_city'];
    clientLat = json['client_lat'];
    clientLog = json['client_log'];
    timestamp = json['timestamp'];
    method = json['method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domain'] = this.domain;
    data['session'] = this.session;
    data['client_ip'] = this.clientIp;
    data['client_country'] = this.clientCountry;
    data['client_city'] = this.clientCity;
    data['client_lat'] = this.clientLat;
    data['client_log'] = this.clientLog;
    data['timestamp'] = this.timestamp;
    data['method'] = this.method;
    return data;
  }
}
