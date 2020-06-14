class RemoteNotice {
  bool enabled;
  String description;
  bool bottomNoticeEnabled;
  String bottomNoticeTitle;
  String bottomNotice;
  String bottomNoticeHeadingURL;
  String bottomNoticeLinkTitle;
  String bottomNoticeLink;

  RemoteNotice(
      {this.enabled,
        this.description,
        this.bottomNoticeEnabled,
        this.bottomNoticeTitle,
        this.bottomNotice,
        this.bottomNoticeHeadingURL,
        this.bottomNoticeLinkTitle,
        this.bottomNoticeLink});

  RemoteNotice.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    description = json['description'];
    bottomNoticeEnabled = json['bottomNoticeEnabled'];
    bottomNoticeTitle = json['bottomNoticeTitle'];
    bottomNotice = json['bottomNotice'];
    bottomNoticeHeadingURL = json['bottomNoticeHeadingURL'];
    bottomNoticeLinkTitle = json['bottomNoticeLinkTitle'];
    bottomNoticeLink = json['bottomNoticeLink'];
  }

  RemoteNotice.preFetch(){
    enabled = false;
    description = "";
    bottomNoticeEnabled = false;
    bottomNoticeTitle = "";
    bottomNotice = "";
    bottomNoticeHeadingURL = "";
    bottomNoticeLinkTitle = "";
    bottomNoticeLink = "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enabled'] = this.enabled;
    data['description'] = this.description;
    data['bottomNoticeEnabled'] = this.bottomNoticeEnabled;
    data['bottomNoticeTitle'] = this.bottomNoticeTitle;
    data['bottomNotice'] = this.bottomNotice;
    data['bottomNoticeHeadingURL'] = this.bottomNoticeHeadingURL;
    data['bottomNoticeLinkTitle'] = this.bottomNoticeLinkTitle;
    data['bottomNoticeLink'] = this.bottomNoticeLink;
    return data;
  }
}

typedef SwitchPageCallback = void Function(int page);
