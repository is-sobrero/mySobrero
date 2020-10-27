import 'dart:convert';

class ConfigData {
  String _status;
  int _code;
  Data _data;

  ConfigData({String status, int code, Data data}) {
    this._status = status;
    this._code = code;
    this._data = data;
  }

  String get status => _status;
  set status(String status) => _status = status;
  int get code => _code;
  set code(int code) => _code = code;
  Data get data => _data;
  set data(Data data) => _data = data;

  ConfigData.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _code = json['code'];
    _data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  int _latestVersion;
  bool _headingNoticeEnabled;
  String _headingNoticeContent;
  bool _trailingNoticeEnabled;
  String _trailingNoticeTitle;
  String _trailingNoticeImg;
  String _trailingNoticeContent;
  String _trailingNoticeAction;
  String _trailingNoticeRedirect;
  String _stopEnabled;
  String _stopType;
  String _stopDescription;
  List<int> _stopExceptions;

  int get latestVersion => _latestVersion;
  bool get headingNoticeEnabled => _headingNoticeEnabled;
  String get headingNoticeContent => _headingNoticeContent;
  bool get trailingNoticeEnabled => _trailingNoticeEnabled;
  String get trailingNoticeTitle => _trailingNoticeTitle;
  String get trailingNoticeImg => _trailingNoticeImg;
  String get trailingNoticeContent => _trailingNoticeContent;
  String get trailingNoticeAction => _trailingNoticeAction;
  String get trailingNoticeRedirect => _trailingNoticeRedirect;
  String get stopEnabled => _stopEnabled;
  String get stopType => _stopType;
  String get stopDescription => _stopDescription;
  List<int> get stopExceptions => _stopExceptions;

  Data.fromJson(Map<String, dynamic> json) {
    _latestVersion = json['latest_version'];
    _headingNoticeEnabled = json['heading_notice_enabled'];
    _headingNoticeContent = json['heading_notice_content'];
    _trailingNoticeEnabled = json['trailing_notice_enabled'];
    _trailingNoticeTitle = json['trailing_notice_title'];
    _trailingNoticeImg = json['trailing_notice_img'];
    _trailingNoticeContent = json['trailing_notice_content'];
    _trailingNoticeAction = json['trailing_notice_action'];
    _trailingNoticeRedirect = json['trailing_notice_redirect'];
    _stopEnabled = json['stop_enabled'];
    _stopType = json['stop_type'];
    _stopDescription = json['stop_description'];
    _stopExceptions = jsonDecode(json['stop_exceptions']).cast<int>();
  }

}
