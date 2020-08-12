// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

class AuthenticationQR {
  String domain;
  String session;
  String clientIp;
  String clientCountry;
  String clientCity;

  AuthenticationQR({
    this.domain,
    this.session,
    this.clientIp,
    this.clientCountry,
    this.clientCity
  });

  AuthenticationQR.fromJson(Map<String, dynamic> json) {
    domain = json['domain'];
    session = json['session'];
    clientIp = json['client_ip'];
    clientCountry = json['client_country'];
    clientCity = json['client_city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domain'] = this.domain;
    data['session'] = this.session;
    data['client_ip'] = this.clientIp;
    data['client_country'] = this.clientCountry;
    data['client_city'] = this.clientCity;
    return data;
  }
}