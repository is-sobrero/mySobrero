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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['code'] = this._code;
    if (this._data != null) {
      data['data'] = this._data.toJson();
    }
    return data;
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

  Data(
      {int latestVersion,
        bool headingNoticeEnabled,
        String headingNoticeContent,
        bool trailingNoticeEnabled,
        String trailingNoticeTitle,
        String trailingNoticeImg,
        String trailingNoticeContent,
        String trailingNoticeAction,
        String trailingNoticeRedirect}) {
    this._latestVersion = latestVersion;
    this._headingNoticeEnabled = headingNoticeEnabled;
    this._headingNoticeContent = headingNoticeContent;
    this._trailingNoticeEnabled = trailingNoticeEnabled;
    this._trailingNoticeTitle = trailingNoticeTitle;
    this._trailingNoticeImg = trailingNoticeImg;
    this._trailingNoticeContent = trailingNoticeContent;
    this._trailingNoticeAction = trailingNoticeAction;
    this._trailingNoticeRedirect = trailingNoticeRedirect;
  }

  int get latestVersion => _latestVersion;
  set latestVersion(int latestVersion) => _latestVersion = latestVersion;
  bool get headingNoticeEnabled => _headingNoticeEnabled;
  set headingNoticeEnabled(bool headingNoticeEnabled) =>
      _headingNoticeEnabled = headingNoticeEnabled;
  String get headingNoticeContent => _headingNoticeContent;
  set headingNoticeContent(String headingNoticeContent) =>
      _headingNoticeContent = headingNoticeContent;
  bool get trailingNoticeEnabled => _trailingNoticeEnabled;
  set trailingNoticeEnabled(bool trailingNoticeEnabled) =>
      _trailingNoticeEnabled = trailingNoticeEnabled;
  String get trailingNoticeTitle => _trailingNoticeTitle;
  set trailingNoticeTitle(String trailingNoticeTitle) =>
      _trailingNoticeTitle = trailingNoticeTitle;
  String get trailingNoticeImg => _trailingNoticeImg;
  set trailingNoticeImg(String trailingNoticeImg) =>
      _trailingNoticeImg = trailingNoticeImg;
  String get trailingNoticeContent => _trailingNoticeContent;
  set trailingNoticeContent(String trailingNoticeContent) =>
      _trailingNoticeContent = trailingNoticeContent;
  String get trailingNoticeAction => _trailingNoticeAction;
  set trailingNoticeAction(String trailingNoticeAction) =>
      _trailingNoticeAction = trailingNoticeAction;
  String get trailingNoticeRedirect => _trailingNoticeRedirect;
  set trailingNoticeRedirect(String trailingNoticeRedirect) =>
      _trailingNoticeRedirect = trailingNoticeRedirect;

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latest_version'] = this._latestVersion;
    data['heading_notice_enabled'] = this._headingNoticeEnabled;
    data['heading_notice_content'] = this._headingNoticeContent;
    data['trailing_notice_enabled'] = this._trailingNoticeEnabled;
    data['trailing_notice_title'] = this._trailingNoticeTitle;
    data['trailing_notice_img'] = this._trailingNoticeImg;
    data['trailing_notice_content'] = this._trailingNoticeContent;
    data['trailing_notice_action'] = this._trailingNoticeAction;
    data['trailing_notice_redirect'] = this._trailingNoticeRedirect;
    return data;
  }
}
