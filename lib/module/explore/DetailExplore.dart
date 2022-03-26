import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/module/agenda/Agenda.dart';
import 'package:icati_app/module/chat/ChatMember.dart';

class DetailExplore extends StatefulWidget {
  final Map dataExplore;
  final String mId;

  DetailExplore({this.dataExplore, this.mId});

  @override
  _DetailExploreState createState() => _DetailExploreState();
}

class _DetailExploreState extends State<DetailExplore> {
  @override
  Widget build(BuildContext context) {
    print("ini mid detail explore " + widget.mId);
    print("ini widgetr data explore" + widget.dataExplore['pic'].toString());
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: new IconButton(
              icon: new Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                if (this.mounted) {
                  Navigator.of(context).pop();
                }
              },
            )),
        body: Center(
            child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(widget.dataExplore['pic'] == ""
                      ? "http://icati.or.id/assets/images/backgroundexplore2.jpg"
                      : widget.dataExplore['pic']),
                  fit: BoxFit.cover)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width -
                        ScreenUtil().setSp(20),
                    padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(ScreenUtil().setSp(16)),
                              child: CircleAvatar(
                                radius: ScreenUtil().setSp(50),
                                backgroundColor: Colors.white,
                                backgroundImage: CachedNetworkImageProvider(widget
                                            .dataExplore['pic'] ==
                                        ""
                                    ? "http://icati.or.id/assets/images/account_picture_default.png"
                                    : widget.dataExplore['pic']),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.dataExplore['mName'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .copyWith(),
                                  ),
                                  SizedBox(height: ScreenUtil().setSp(3)),
                                  Text(
                                    widget.dataExplore['kota'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(
                                            fontSize: ScreenUtil().setSp(12.5)),
                                  ),
                                  SizedBox(height: ScreenUtil().setSp(3)),
                                  widget.dataExplore['wa'].isEmpty
                                      ? Container()
                                      : Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                BaseFunction().sendWhatsApp(
                                                    widget.dataExplore['wa']
                                                        .toString(),
                                                    '');
                                              },
                                              child: Material(
                                                color: Colors.green,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                elevation: 3,
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      ScreenUtil().setSp(5)),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .whatsapp,
                                                        size: ScreenUtil()
                                                            .setSp(12),
                                                        color: Colors.white70,
                                                      ),
                                                      SizedBox(
                                                          width: ScreenUtil()
                                                              .setSp(5)),
                                                      Text(
                                                          widget.dataExplore[
                                                              'wa'],
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText2
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white70,
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              11.5)))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                  SizedBox(height: ScreenUtil().setSp(3)),
                                  widget.dataExplore['email'].isEmpty
                                      ? Container()
                                      : InkWell(
                                          onTap: () {
                                            BaseFunction().launchMail(
                                                widget.dataExplore['email']);
                                          },
                                          child: Material(
                                            color: Colors.deepOrangeAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 3,
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  ScreenUtil().setSp(5)),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.envelope,
                                                    size: 12,
                                                    color: Colors.white70,
                                                  ),
                                                  SizedBox(width: 8.0),
                                                  Expanded(
                                                    child: Text(
                                                        widget.dataExplore[
                                                            'email'],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2
                                                            .copyWith(
                                                                color: Colors
                                                                    .white70,
                                                                fontSize:
                                                                    11.5)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        widget.dataExplore['bio'].isEmpty
                            ? Container()
                            : Padding(
                                padding: EdgeInsets.only(
                                    left: ScreenUtil().setSp(20)),
                                child: Text(
                                  widget.dataExplore['bio'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(
                                          fontSize: ScreenUtil().setSp(12.5)),
                                ),
                              ),
                        SizedBox(
                            height: widget.dataExplore['bio'].isEmpty
                                ? 0
                                : ScreenUtil().setSp(20)),
                        //sosmed
                        Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setSp(5)),
                          child: Wrap(
                            direction: Axis.horizontal,
                            spacing: ScreenUtil().setSp(5),
                            runSpacing: ScreenUtil().setSp(5),
                            children: [
                              widget.dataExplore['facebook'].isEmpty
                                  ? Container()
                                  : Container(
                                      height: ScreenUtil().setSp(30),
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xFF3B5998),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            )),
                                        label: Text(
                                            widget.dataExplore['facebook']
                                                .replaceAll(
                                                    "https://facebook.com/",
                                                    ""),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    color: Colors.white70,
                                                    fontSize: ScreenUtil()
                                                        .setSp(11.5))),
                                        onPressed: () {
                                          BaseFunction().launchURL(widget
                                              .dataExplore['facebook']
                                              .toString());
                                        },
                                        //color: Theme.of(context).buttonColor,
                                        icon: Icon(
                                          FontAwesomeIcons.facebook,
                                          size: ScreenUtil().setSp(12),
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                              widget.dataExplore['twitter'].isEmpty
                                  ? Container()
                                  : Container(
                                      height: ScreenUtil().setSp(30),
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xFF1DA1F2),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            )),
                                        label: Text(
                                            widget.dataExplore['twitter']
                                                .replaceAll(
                                                    "https://twitter.com/", ""),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    color: Colors.white70,
                                                    fontSize: ScreenUtil()
                                                        .setSp(11.5))),
                                        onPressed: () {
                                          BaseFunction().launchURL(widget
                                              .dataExplore['twitter']
                                              .toString());
                                        },
                                        //color: Theme.of(context).buttonColor,
                                        icon: Icon(
                                          FontAwesomeIcons.twitter,
                                          size: ScreenUtil().setSp(12),
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                              widget.dataExplore['instagram'].isEmpty
                                  ? Container()
                                  : Container(
                                      height: ScreenUtil().setSp(30),
                                      decoration: new BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xff405DE6)
                                                    .withOpacity(0.8),
                                                Color(0xff5851DB)
                                                    .withOpacity(0.8),
                                                Color(0xff833AB4)
                                                    .withOpacity(0.8),
                                                Color(0xffC13584)
                                                    .withOpacity(0.8),
                                                Color(0xffE1306C)
                                                    .withOpacity(0.8),
                                                Color(0xffFD1D1D)
                                                    .withOpacity(0.8),
                                                Color(0xffF56040)
                                                    .withOpacity(0.8),
                                                Color(0xffF77737)
                                                    .withOpacity(0.8),
                                                Color(0xffFCAF45)
                                                    .withOpacity(0.8),
                                                Color(0xffFFDC80)
                                                    .withOpacity(0.8)
                                              ]),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            )),
                                        label: Text(
                                            widget.dataExplore['instagram']
                                                .replaceAll(
                                                    "https://instagram.com/",
                                                    ""),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    color: Colors.white70,
                                                    fontSize: ScreenUtil()
                                                        .setSp(11.5))),
                                        onPressed: () {
                                          BaseFunction().launchURL(widget
                                              .dataExplore['instagram']
                                              .toString());
                                        },
                                        //color: Theme.of(context).buttonColor,
                                        icon: Icon(
                                          FontAwesomeIcons.instagram,
                                          size: ScreenUtil().setSp(12),
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                              widget.dataExplore['youtube'].isEmpty
                                  ? Container()
                                  : Container(
                                      height: ScreenUtil().setSp(30),
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xFFFF0000),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            )),
                                        label: Text(
                                            widget.dataExplore['youtube']
                                                .replaceAll(
                                                    "https://www.youtube.com/channel/",
                                                    ""),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    color: Colors.white70,
                                                    fontSize: ScreenUtil()
                                                        .setSp(11.5))),
                                        onPressed: () {
                                          BaseFunction().launchURL(widget
                                              .dataExplore['youtube']
                                              .toString());
                                        },
                                        //color: Theme.of(context).buttonColor,
                                        icon: Icon(
                                          FontAwesomeIcons.youtube,
                                          size: ScreenUtil().setSp(12),
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                              widget.dataExplore['linkedin'].isEmpty
                                  ? Container()
                                  : Container(
                                      height: ScreenUtil().setSp(30),
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xFF2867B2),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            )),
                                        label: Text(
                                            widget.dataExplore['linkedin']
                                                .replaceAll(
                                                    "https://www.linkedin.com/in/",
                                                    ""),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    color: Colors.white70,
                                                    fontSize: ScreenUtil()
                                                        .setSp(11.5))),
                                        onPressed: () {
                                          BaseFunction().launchURL(widget
                                              .dataExplore['linkedin']
                                              .toString());
                                        },
                                        //color: Theme.of(context).buttonColor,
                                        icon: Icon(
                                          FontAwesomeIcons.linkedin,
                                          size: ScreenUtil().setSp(12),
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                              widget.dataExplore['tiktok'].isEmpty
                                  ? Container()
                                  : Container(
                                      height: ScreenUtil().setSp(30),
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            )),
                                        label: Text(
                                            widget.dataExplore['tiktok']
                                                .replaceAll(
                                                    "https://www.tiktok.com/",
                                                    ""),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    color: Colors.white70,
                                                    fontSize: ScreenUtil()
                                                        .setSp(11.5))),
                                        onPressed: () {
                                          BaseFunction().launchURL(widget
                                              .dataExplore['tiktok']
                                              .toString());
                                        },
                                        //color: Theme.of(context).buttonColor,
                                        icon: Icon(
                                          FontAwesomeIcons.tiktok,
                                          size: ScreenUtil().setSp(12),
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                              widget.dataExplore['website'].isEmpty
                                  ? Container()
                                  : Container(
                                      height: ScreenUtil().setSp(30),
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            )),
                                        label: Text(
                                            widget.dataExplore['website']
                                                .replaceAll("https://", ""),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    color: Colors.white70,
                                                    fontSize: ScreenUtil()
                                                        .setSp(11.5))),
                                        onPressed: () {
                                          BaseFunction().launchURL(widget
                                              .dataExplore['website']
                                              .toString());
                                        },
                                        //color: Theme.of(context).buttonColor,
                                        icon: Icon(
                                          FontAwesomeIcons.globe,
                                          size: ScreenUtil().setSp(12),
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        widget.dataExplore['mId'].toString() != widget.mId
                            ? FlatButton(
                                color: Colors.green,
                                onPressed: () {
                                  var dataChat = {
                                    "mId": widget.dataExplore['mId'].toString(),
                                    "mName": widget.dataExplore['mName'],
                                    "mPic": widget.dataExplore['pic'],
                                    "mSenderId": widget.mId,
                                    "mRecipientId":
                                        widget.dataExplore['mId'].toString(),
                                  };
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ChatMember(recipientData: dataChat),
                                    // Agenda(),
                                    settings:
                                        RouteSettings(name: "Chat Member"),
                                  ));
                                },
                                child: Text("Mulai Chat",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12)),
                              )
                            : Container(),
                      ],
                    ),
                  )),
              SizedBox(height: ScreenUtil().setSp(20))
            ],
          ),
        )));
  }
}
