// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

class SnacksResponse {
  String status;
  int code;
  List<Snack> snacks;

  SnacksResponse({this.status, this.code, this.snacks});

  SnacksResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      snacks = new List<Snack>();
      json['data'].forEach((v) {
        snacks.add(new Snack.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.snacks != null) {
      data['data'] = this.snacks.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Snack {
  int id;
  String name;
  String description;
  int cost;
  bool available;
  String image;

  Snack({
    this.id,
        this.name,
        this.description,
        this.cost,
        this.available,
        this.image});

  Snack.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    cost = json['cost'];
    available = json['available'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['cost'] = this.cost;
    data['available'] = this.available;
    data['image'] = this.image;
    return data;
  }
}