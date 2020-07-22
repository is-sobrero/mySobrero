class StringData {
  String _status;
  int _code;
  String _data;

  StringData({String status, int code, String data}) {
    this._status = status;
    this._code = code;
    this._data = data;
  }

  String get status => _status;
  set status(String status) => _status = status;
  int get code => _code;
  set code(int code) => _code = code;
  String get data => _data;
  set data(String data) => _data = data;

  StringData.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _code = json['code'];
    _data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['code'] = this._code;
    data['data'] = this._data;
    return data;
  }
}
