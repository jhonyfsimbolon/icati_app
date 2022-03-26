import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/module/stories/SubStories.dart';

class StoryWidgets {
  Widget displayNewMember(BuildContext context, List dataMember) {
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setSp(10)),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setSp(10), right: ScreenUtil().setSp(10)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: [
                      Icon(FontAwesomeIcons.user,
                          size: 19, color: Colors.black),
                      SizedBox(width: 6),
                      Text(
                        "Member Baru",
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      // Navigator.of(context).pushAndRemoveUntil(
                      //   MaterialPageRoute(
                      //       builder: (context) => MenuBar(currentPage: 1)),
                      //       (Route<dynamic> predicate) => false,
                      // );
                    },
                    child: Text(
                      "Lihat Semua",
                      style: GoogleFonts.roboto(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 13,
                        color: Color(0xffBA0606),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setSp(16)),
            height: ScreenUtil().setSp(120),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dataMember == null ? 0 : dataMember.length,
              itemBuilder: (context, i) {
                return Row(
                  children: <Widget>[
                    i == 0
                        ? SizedBox(width: ScreenUtil().setSp(2))
                        : Container(),
                    GestureDetector(
                      onTap: () {},
                      child: newMember(
                        context,
                        i,
                        dataMember,
                      ),
                    ),
                    SizedBox(width: ScreenUtil().setSp(10)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget newMember(BuildContext context, int i, List dataMember) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SubStories(
                  dataMember: dataMember,
                  dataStory: dataMember[i]['story'],
                  index: i,
                )));
      },
      child: Container(
        child: new FittedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: dataMember[i]['pic'],
                imageBuilder: (context, imageProvider) => Container(
                  width: ScreenUtil().setSp(80),
                  height: ScreenUtil().setSp(80),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, i) {
                  return Container(
                      height: ScreenUtil().setSp(80),
                      width: ScreenUtil().setSp(80),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage("assets/images/logo_ts_red.png"),
                            fit: BoxFit.cover),
                      ));
                },
                errorWidget: (_, __, ___) {
                  return Container(
                      height: ScreenUtil().setSp(80),
                      width: ScreenUtil().setSp(80),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage("assets/images/logo_ts_red.png"),
                            fit: BoxFit.cover),
                      ));
                },
              ),
              Container(
                width: ScreenUtil().setSp(80),
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                  child: Center(
                    child: Text(
                      dataMember[i]['mName'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
