// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:mySobrero/common/ui.dart';

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
    headingNewsEnabled = json['heading_notice_enabled'];
    headingNewsBody = json['heading_notice_content'];
    bottomNoticeEnabled = json['trailing_notice_enabled'];
    bottomNoticeTitle = json['trailing_notice_title'];
    bottomNotice = json['trailing_notice_content'];
    bottomNoticeHeadingURL = json['trailing_notice_img'];
    bottomNoticeLinkTitle = json['trailing_notice_action'];
    bottomNoticeLink = json['trailing_notice_redirect'];
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
}

typedef SwitchPageCallback = void Function(int page);

typedef GradientTileLayoutBuilder = Function(Widget child);
typedef GradientTileRootBuilder = Function(double aspectRatio, Widget child);
typedef HorizontalSectionListItemBuilder = Function(bool safeLeft, bool safeRight, int index);

class SituazioneElement{
  int numeroVoti;
  double media;
  SituazioneElement(this.numeroVoti, this.media);
}