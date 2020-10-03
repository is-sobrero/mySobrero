// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'dart:convert';


class REAPIException implements Exception {
  int code;
  String description;
  REAPIException({this.code, this.description});
}

class StartupData {
  Status status;
  User user;
  List<Mark> marks_firstperiod, marks_finalperiod;
  List<Notice> notices;
  List<Assignment> assignments;
  COVID19Info covid19info;
}

class User {
  final String name, surname, birthday, level;
  final String matricola, fullclass, course;
  String fullname;
  final List<Curriculum> curriculum;

  User ({
    @required this.name,
    @required this.surname,
    @required this.birthday,
    @required this.level,
    @required this.matricola,
    @required this.fullclass,
    @required this.course,
    @required this.curriculum
  }){
    this.fullname = "${this.name} ${this.surname}";
  }

}
class Status {
  final int code;
  final String description;

  Status(this.code, this.description);
}

class Curriculum {
  final String fullclass, course, points, outcome, year;
  Curriculum ({
    @required this.fullclass,
    @required this.course,
    @required this.points,
    @required this.outcome,
    @required this.year,
  });
}

class Mark {
  final String date;
  final String subject;
  final String tipologia;
  final String comment;
  final String professor;
  final String signed;
  final String signed_user;

  double mark;
  int weight;

  Mark ({
    @required this.date,
    @required this.subject,
    @required this.tipologia,
    @required mark,
    @required mark_txt,
    @required this.comment,
    @required this.professor,
    @required String weight,
    @required this.signed,
    @required this.signed_user
  }) {
    this.mark = double.parse(mark.replaceAll(",", ".").trim());
    if (double.tryParse(mark_txt) == null) this.weight = 0;
    else this.weight = int.parse(weight.trim());
  }
}

class Notice {
  final String date;
  final String sender;
  final String body;
  final String read;
  final String object;
  final int id;
  List<Attachment> attachments;

  Notice({
    @required this.date,
    @required this.sender,
    @required this.body,
    @required this.read,
    @required this.object,
    @required this.id,
  });
}

class Attachment {
  final String name;
  final String url;

  Attachment({@required this.name, @required this.url});
}

class Assignment {
  final String date;
  final String subject;
  final String description;

  Assignment({
    @required this.date,
    @required this.subject,
    @required this.description,
  });
}

class Report {
  Map<String, FinalMark> subjects;
  double average;
  final String term, outcome, comment;

  Report({
    @required this.term,
    @required this.outcome,
    @required this.comment,
  });
}

class FinalMark {
  int absences, mark;
  FinalMark({
    @required this.absences,
    @required this.mark,
  });
}

class Absence {
  String date, reason, type, hour, contributes;
  Absence({
    @required this.date,
    @required this.reason,
    @required this.type,
    @required this.hour,
    @required this.contributes,
  });
}

class OverallAbsences {
  List<Absence> justified, wo_justification;
}

class Topic {
  final String subject, description, hours, date;
  Topic({
    @required this.subject,
    @required this.description,
    @required this.hours,
    @required this.date
  });
}

class Folder {
  final String id, name;
  Folder({@required this.id, @required this.name});
}

class Professor {
  final String name, id;
  List<Folder> folders;
  Professor({@required this.name, @required this.id});
}

class File {
  String name, url;
  File({@required this.name, @required this.url});
}

class COVID19Info {
  String fam_enabled;
  String fam_required;
  String fam_file;
  String fam_pin;
  String fam_text;
  String fam_url;
  String data_accettazione;

  COVID19Info({
    this.fam_enabled,
    this.fam_required,
    this.fam_file,
    this.fam_pin,
    this.fam_text,
    this.fam_url,
    this.data_accettazione
  });

  COVID19Info.fromJSON(Map<String, dynamic> json) {
    fam_enabled = json["fam_enabled"];
    fam_required = json["fam_required"];
    fam_file = json["fam_file"];
    fam_pin = json["fam_pin"];
    fam_text = utf8.decode(base64.decode(json["fam_text"]));
    fam_url = json["fam_url"];
    data_accettazione = json["data_accettazione"];
  }

}









