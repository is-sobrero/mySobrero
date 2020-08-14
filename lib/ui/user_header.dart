import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mySobrero/common/skeleton.dart';
import 'package:mySobrero/localization/localization.dart';

class SobreroUserHeader extends StatelessWidget {
  String name, year, section, course;
  String profileURL;
  SobreroUserHeader({
    Key key,
    @required this.name,
    @required this.year,
    @required this.section,
    @required this.course,
    @required this.profileURL
  }) :  assert(name != null),
        assert(year != null),
        assert(section != null),
        assert(course != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${AppLocalizations.of(context).translate('hello')} $name!",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
            Text(
              AppLocalizations.of(context).translate('class') +
                " $year $section - $course"
            ),
          ],
        ),
      ),
      Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              offset: Offset(0, 5),
              blurRadius: 10,
            )
          ],
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Container(
            width: 50,
            height: 50,
            child: CachedNetworkImage(
              imageUrl: profileURL ?? "no",
              placeholder: (context, url) => Skeleton(),
              errorWidget: (context, url, error) => Image.asset(
                "assets/images/profile.jpg",
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      )
    ],
  );
}