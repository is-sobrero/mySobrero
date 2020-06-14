class RemoteNews {
  bool headingNewsEnabled = false;
  String headingNewsBody;
  bool bottomNoticeEnabled = false;
  String bottomNoticeTitle;
  String bottomNotice;
  String bottomNoticeHeadingURL;
  String bottomNoticeLinkTitle;
  String bottomNoticeLink;

  RemoteNews(
      {this.headingNewsEnabled = false,
        this.headingNewsBody,
        this.bottomNoticeEnabled,
        this.bottomNoticeTitle,
        this.bottomNotice,
        this.bottomNoticeHeadingURL,
        this.bottomNoticeLinkTitle,
        this.bottomNoticeLink});

  RemoteNews.fromJson(Map<String, dynamic> json) {
    headingNewsEnabled = json['enabled'];
    headingNewsBody = json['description'];
    bottomNoticeEnabled = json['bottomNoticeEnabled'];
    bottomNoticeTitle = json['bottomNoticeTitle'];
    bottomNotice = json['bottomNotice'];
    bottomNoticeHeadingURL = json['bottomNoticeHeadingURL'];
    bottomNoticeLinkTitle = json['bottomNoticeLinkTitle'];
    bottomNoticeLink = json['bottomNoticeLink'];
  }

  RemoteNews.preFetch(){
    headingNewsEnabled = false;
    headingNewsBody = "";
    bottomNoticeEnabled = false;
    bottomNoticeTitle = "";
    bottomNotice = "";
    bottomNoticeHeadingURL = "";
    bottomNoticeLinkTitle = "";
    bottomNoticeLink = "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enabled'] = this.headingNewsEnabled;
    data['description'] = this.headingNewsBody;
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
