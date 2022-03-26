import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/module/organisasi/OrganisasiDetail.dart';

class OrganisasiWidgets {
  Widget displayGridOrganisasi(
    context,
    List dataOrganisasi,
  ) {
    return Container(
      child: GridView.builder(
        // mar: EdgeInsets.all(10),
        padding: EdgeInsets.only(top: 10),
        itemCount: dataOrganisasi.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OrganisasiDetail(
                    id: dataOrganisasi[index]['organizationId'].toString()),
                settings: RouteSettings(name: "Detail Organisasi"),
              ));
            },
            child: Container(
              height: 135,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                //color: Colors.grey.withOpacity(0.5),
              ),
              margin:
                  EdgeInsets.only(top: 0.0, bottom: 0.0, right: 3.0, left: 3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: dataOrganisasi[index]['urlSource'],
                    imageBuilder: (context, imageProvider) => Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, i) {
                      return Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/logo_ts_red.png'),
                              fit: BoxFit.cover),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) => Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/account_picture_default.png'),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      dataOrganisasi[index]['organizationName'],
                      style: TextStyle(fontSize: 11, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            // child: Container(
            //   color: Colors.white,
            //   margin: EdgeInsets.all(10),
            //   child: Center(
            //     child: FadeInImage.assetNetwork(
            //       width: 110.0,
            //       height: 110.0,
            //       fit: BoxFit.cover,
            //       placeholder: "assets/images/logo_ts_red.png",
            //       image: dataOrganisasi[index]["urlSource"],

            //     ),
            //   ),
            // ),
          );
        },
      ),
    );
  }

  Widget displayBoxPic(BuildContext context, String image, String name) {
    return GestureDetector(
      onTap: () {},
      child: new Container(
        color: Colors.white,
        padding: EdgeInsets.all(10.0),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FittedBox(
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: image,
                      placeholder: (context, i) {
                        return Image.asset("assets/images/logo_ts_red.png");
                      },
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(
                    name,
                    style: GoogleFonts.roboto(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  Widget displayBoxContact(
    BuildContext context,
    String web,
    String email,
    String phone,
  ) {
    return GestureDetector(
      onTap: () {},
      child: new Container(
        color: Colors.white,
        padding: EdgeInsets.all(10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            web.isEmpty
                ? Container()
                : Container(
                    margin: EdgeInsets.only(bottom: 7.0),
                    width: 300,
                    child: Row(
                      children: <Widget>[
                        new Icon(Icons.web, size: 14.0),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            web,
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'expressway',
                              fontSize: 13.0,
                            ),
                          ),
                        ),
                      ],
                    )),
            phone.isEmpty
                ? Container()
                : Container(
                    margin: EdgeInsets.only(bottom: 7.0),
                    width: 300,
                    child: Row(
                      children: <Widget>[
                        new Icon(Icons.phone, size: 14.0),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            phone,
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'expressway',
                              fontSize: 13.0,
                            ),
                          ),
                        ),
                      ],
                    )),
            email.isEmpty
                ? Container()
                : Container(
                    margin: EdgeInsets.only(bottom: 7.0),
                    width: 300,
                    child: Row(
                      children: <Widget>[
                        new Icon(Icons.email, size: 14.0),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            email,
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'expressway',
                              fontSize: 13.0,
                            ),
                          ),
                        ),
                      ],
                    )),
          ],
        ),
      ),
    );
  }

  Widget displayBoxMediaSisiol(
      BuildContext context,
      String facebook,
      String instagram,
      String twitter,
      String youtube,
      String tiktok,
      String wa,
      String telegram) {
    return Center(
        child: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                width:
                    MediaQuery.of(context).size.width - ScreenUtil().setSp(20),
                padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //sosmed
                    Padding(
                      padding: EdgeInsets.only(left: ScreenUtil().setSp(5)),
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: ScreenUtil().setSp(5),
                        runSpacing: ScreenUtil().setSp(5),
                        children: [
                          facebook.isEmpty ||
                                  facebook == "https://facebook.com/"
                              ? SizedBox.shrink()
                              : Container(
                                  height: ScreenUtil().setSp(30),
                                  width: 100,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF3B5998),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    label: Text("Facebook",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                color: Colors.white70,
                                                fontSize:
                                                    ScreenUtil().setSp(10))),
                                    onPressed: () {
                                      BaseFunction()
                                          .launchURL(facebook.toString());
                                    },
                                    //color: Theme.of(context).buttonColor,
                                    icon: Icon(
                                      FontAwesomeIcons.facebook,
                                      size: ScreenUtil().setSp(10),
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                          twitter.isEmpty || twitter == "https://twitter.com/"
                              ? SizedBox.shrink()
                              : Container(
                                  height: ScreenUtil().setSp(30),
                                  width: 100,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF1DA1F2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    label: Text("Twitter",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                color: Colors.white70,
                                                fontSize:
                                                    ScreenUtil().setSp(10))),
                                    onPressed: () {
                                      BaseFunction()
                                          .launchURL(twitter.toString());
                                    },
                                    //color: Theme.of(context).buttonColor,
                                    icon: Icon(
                                      FontAwesomeIcons.twitter,
                                      size: ScreenUtil().setSp(10),
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                          instagram.isEmpty ||
                                  instagram == "https://instagram.com/"
                              ? SizedBox.shrink()
                              : Container(
                                  height: ScreenUtil().setSp(30),
                                  width: 100,
                                  decoration: new BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color(0xff405DE6).withOpacity(0.8),
                                            Color(0xff5851DB).withOpacity(0.8),
                                            Color(0xff833AB4).withOpacity(0.8),
                                            Color(0xffC13584).withOpacity(0.8),
                                            Color(0xffE1306C).withOpacity(0.8),
                                            Color(0xffFD1D1D).withOpacity(0.8),
                                            Color(0xffF56040).withOpacity(0.8),
                                            Color(0xffF77737).withOpacity(0.8),
                                            Color(0xffFCAF45).withOpacity(0.8),
                                            Color(0xffFFDC80).withOpacity(0.8)
                                          ]),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    label: Text("Instagram",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                color: Colors.white70,
                                                fontSize:
                                                    ScreenUtil().setSp(10))),
                                    onPressed: () {
                                      BaseFunction()
                                          .launchURL(instagram.toString());
                                    },
                                    //color: Theme.of(context).buttonColor,
                                    icon: Icon(
                                      FontAwesomeIcons.instagram,
                                      size: ScreenUtil().setSp(10),
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                          youtube.isEmpty ||
                                  youtube == "https://www.youtube.com/channel/"
                              ? SizedBox.shrink()
                              : Container(
                                  height: ScreenUtil().setSp(30),
                                  width: 100,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xFFFF0000),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    label: Text("YouTube",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                color: Colors.white70,
                                                fontSize:
                                                    ScreenUtil().setSp(10))),
                                    onPressed: () {
                                      BaseFunction()
                                          .launchURL(youtube.toString());
                                    },
                                    //color: Theme.of(context).buttonColor,
                                    icon: Icon(
                                      FontAwesomeIcons.youtube,
                                      size: ScreenUtil().setSp(10),
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                          telegram.isEmpty || telegram == "https://t.me/"
                              ? SizedBox.shrink()
                              : Container(
                                  height: ScreenUtil().setSp(30),
                                  width: 100,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF2867B2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    label: Text("Telegram",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                color: Colors.white70,
                                                fontSize:
                                                    ScreenUtil().setSp(10))),
                                    onPressed: () {
                                      BaseFunction()
                                          .launchURL(telegram.toString());
                                    },
                                    //color: Theme.of(context).buttonColor,
                                    icon: Icon(
                                      FontAwesomeIcons.telegram,
                                      size: ScreenUtil().setSp(10),
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                          wa.isEmpty || wa == "https://wa.me/"
                              ? SizedBox.shrink()
                              : Container(
                                  height: ScreenUtil().setSp(30),
                                  width: 100,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF25D366),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    label: Text("WhatsApp",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                color: Colors.white70,
                                                fontSize:
                                                    ScreenUtil().setSp(10))),
                                    onPressed: () {
                                      BaseFunction().launchURL(wa.toString());
                                    },
                                    //color: Theme.of(context).buttonColor,
                                    icon: Icon(
                                      FontAwesomeIcons.whatsapp,
                                      size: ScreenUtil().setSp(10),
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                          tiktok.isEmpty || tiktok == "https://www.tiktok.com/"
                              ? SizedBox.shrink()
                              : Container(
                                  height: ScreenUtil().setSp(30),
                                  width: 100,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    label: Text("TikTok",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                color: Colors.white70,
                                                fontSize:
                                                    ScreenUtil().setSp(10))),
                                    onPressed: () {
                                      BaseFunction()
                                          .launchURL(tiktok.toString());
                                    },
                                    //color: Theme.of(context).buttonColor,
                                    icon: Icon(
                                      FontAwesomeIcons.tiktok,
                                      size: ScreenUtil().setSp(10),
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          SizedBox(height: ScreenUtil().setSp(20))
        ],
      ),
    ));
  }

  Widget displayBoxInfo(BuildContext context, String akDesc) {
    return GestureDetector(
      onTap: () {},
      child: new Container(
        color: Colors.white,
        padding: EdgeInsets.all(10.0),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  width: 300,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Html(
                          data: akDesc,
                        ),
                      ),
                    ],
                  )),
            ]),
      ),
    );
  }
}
