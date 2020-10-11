class IntData {
  String _status;
  int _code;
  int _data;

  IntData({String status, int code, int data}) {
    this._status = status;
    this._code = code;
    this._data = data;
  }

  String get status => _status;
  int get code => _code;
  int get data => _data;

  IntData.fromJson(Map<String, dynamic> json) {
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
