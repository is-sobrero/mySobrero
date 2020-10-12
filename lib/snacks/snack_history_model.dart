// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

class OrderHistory {
  String status;
  int code;
  Data data;

  OrderHistory({this.status, this.code, this.data});

  OrderHistory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<SnackBit> delivered;
  List<SnackBit> notDelivered;

  Data({this.delivered, this.notDelivered});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['delivered'] != null) {
      delivered = new List<SnackBit>();
      json['delivered'].forEach((v) {
        delivered.add(new SnackBit.fromJson(v));
      });
    }
    if (json['not_delivered'] != null) {
      notDelivered = new List<SnackBit>();
      json['not_delivered'].forEach((v) {
        notDelivered.add(new SnackBit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.delivered != null) {
      data['delivered'] = this.delivered.map((v) => v.toJson()).toList();
    }
    if (this.notDelivered != null) {
      data['not_delivered'] = this.notDelivered.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SnackBit {
  int id;
  String snack;
  String deliveredDate;
  String timestamp;
  int delivered;

  SnackBit(
      {this.id,
        this.snack,
        this.deliveredDate,
        this.timestamp,
        this.delivered});

  SnackBit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    snack = json['snack'];
    deliveredDate = json['delivered_date'];
    timestamp = json['timestamp'];
    delivered = json['delivered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['snack'] = this.snack;
    data['delivered_date'] = this.deliveredDate;
    data['timestamp'] = this.timestamp;
    data['delivered'] = this.delivered;
    return data;
  }
}