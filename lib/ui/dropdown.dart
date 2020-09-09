// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:mySobrero/custom/dropdown.dart';

class SobreroDropdown extends StatelessWidget {
  String value;
  List<Widget> items;
  String hint;
  Function(String) onChanged;
  EdgeInsets margin;

  SobreroDropdown({
    Key key,
    @required this.value,
    @required this.items,
    this.margin = EdgeInsets.zero,
    this.hint = "",
    this.onChanged,
  }) :  assert(value != null),
        assert(items != null),
        assert(margin != null),
        assert(hint != null),
        super(key: key);

  @override
  Widget build(BuildContext context){
    return Center(
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withAlpha(12),
              blurRadius: 10,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: CustomDropdownButtonHideUnderline(
            child: Container(
              child: ButtonTheme(
                alignedDropdown: true,
                child: CustomDropdownButton<String>(
                  radius: 15,
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(
                        Icons.unfold_more,
                        color: Theme.of(context).primaryColor
                    ),
                  ),
                  isExpanded: true,
                  hint: Text(
                    hint,
                    overflow: TextOverflow.ellipsis,
                  ),
                  value: value,
                  onChanged: onChanged,
                  items: items,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
