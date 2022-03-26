import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/account/edit_profile/EditProfile.dart';
import 'package:icati_app/module/agenda/Agenda.dart';
import 'package:icati_app/module/agenda/AgendaDetail.dart';
import 'package:icati_app/module/directory/DirectoryDetail.dart';
import 'package:icati_app/module/donasi/Donasi.dart';
import 'package:icati_app/module/donasi/DonasiDetail.dart';
import 'package:icati_app/module/explore/DetailExplore.dart';
import 'package:icati_app/module/gallery/photo/GalleryPhoto.dart';
import 'package:icati_app/module/gallery/photo/GalleryPhotoDetail.dart';
import 'package:icati_app/module/gallery/video/GalleryVideo.dart';
import 'package:icati_app/module/herbal/HerbalDetail.dart';
import 'package:icati_app/module/herbal/HerbalList.dart';
import 'package:icati_app/module/jobvacancy/JobDetail.dart';
import 'package:icati_app/module/jobvacancy/JobList.dart';
import 'package:icati_app/module/kabarduka/KabarDuka.dart';
import 'package:icati_app/module/kabarduka/KabarDukaDetail.dart';
import 'package:icati_app/module/kerjasama/KerjaSama.dart';
import 'package:icati_app/module/login/Login.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
import 'package:icati_app/module/news/News.dart';
import 'package:icati_app/module/news/NewsDetail.dart';
import 'package:icati_app/module/notification/Notification.dart';
import 'package:icati_app/module/organisasi/Organisasi.dart';
import 'package:icati_app/module/organisasi/OrganisasiDetail.dart';
import 'package:icati_app/module/othermenu/about_us/AboutUs.dart';
import 'package:icati_app/module/othermenu/contact_us/Contact_Us.dart';
import 'package:icati_app/module/othermenu/pundi/PundiAmal.dart';
import 'package:icati_app/module/othermenu/pundi/PundiBerkah.dart';
import 'package:icati_app/module/othermenu/pundi/PundiKasih.dart';
import 'package:icati_app/module/register/Register.dart';
import 'package:icati_app/module/register/RegisterOption.dart';
import 'package:icati_app/module/relatedLink/RelatedLink.dart';
import 'package:icati_app/utils/Carousel_Pro.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomeWidgets {
  Widget displaySearchBox2(context, searchCont, Function navigateToSearch,
      Function onRefresh, bool isLogin) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              navigateToSearch(context);
            },
            child: IgnorePointer(
              ignoring: true,
              child: TextFormField(
                controller: searchCont,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Cari Organisasi"),
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 15.0),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 5),
        searchCont.text.isNotEmpty && isLogin == false
            ? GestureDetector(
                onTap: onRefresh, child: Icon(Icons.cancel, size: 30))
            : Container()
      ],
    );
  }

  Widget displaySearchBox(BuildContext context, String currentOrg,
      Function selectOrg, List dataOrg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormField(
          validator: (value) {
            if (currentOrg == null) {
              return 'Kolom harus diisi';
            }
            return null;
          },
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(seconds: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(blurRadius: 2, color: Colors.grey)
                      ]),
                  child: DropdownButtonFormField(
                    isDense: true,
                    isExpanded: true,
                    items: dataOrg != null
                        ? dataOrg.map((item) {
                            return DropdownMenuItem(
                                value: item['organizationId'].toString(),
                                child: Text(
                                  item['organizationName'].toString(),
                                  style: Theme.of(context).textTheme.bodyText2,
                                ));
                          }).toList()
                        : null,
                    value: currentOrg,
                    onChanged: selectOrg,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: ScreenUtil().setSp(10),
                          horizontal: ScreenUtil().setSp(10)),
                      prefixIcon:
                          Icon(Icons.filter_alt, size: ScreenUtil().setSp(20)),
                      // prefixText: "Organisasi:\t\t",
                      prefixStyle: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.black45),
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).focusColor)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      labelStyle:
                          GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                    ),
                  ),
                ),
                state.errorText != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          state.errorText,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: Colors.red),
                        ),
                      )
                    : Container(),
              ],
            );
          },
        )
      ],
    );
  }

  // displayMemberCard(BuildContext context, List dataCard) {
  //   return dataCard == null
  //       ? Container()
  //       : Column(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.all(36.0),
  //         child: Container(
  //           width: MediaQuery.of(context).size.width,
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(5.0),
  //             child: CachedNetworkImage(
  //               fit: BoxFit.cover,
  //               imageUrl: dataCard[0]['cardurl'].toString(),
  //               placeholder: (context, i) {
  //                 return Container();
  //               },
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget displayNews(BuildContext context, List dataNews) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(ScreenUtil().setSp(10)),
      child: Column(
        children: <Widget>[
          Container(
            child: Container(
              margin: EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 16.0, bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Row(
                    children: [
                      Icon(FontAwesomeIcons.newspaper,
                          size: 19, color: Colors.black),
                      SizedBox(width: 10),
                      Row(
                        children: [
                          Text(
                            "Berita",
                            style: GoogleFonts.roboto(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            " 消息",
                            style: GoogleFonts.roboto(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  )),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap:
                          //  () {},
                          () async {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => News(),
                          settings: RouteSettings(name: "Berita"),
                        ));
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
          ),
          Container(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 6.0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: dataNews == null ? 0 : dataNews.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          NewsDetail(id: dataNews[i]["newsId"].toString()),
                      settings: RouteSettings(name: "Detail Berita"),
                    ));
                  },
                  child: Container(
                    child: Container(
                      margin: const EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          FittedBox(
                            child: Container(
                              width: 100, //500,
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: dataNews[i]["newsPic"].toString(),
                                  placeholder: (context, i) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                          "assets/images/logo_ts_red.png"),
                                    );
                                  },
                                  errorWidget: (_, __, ___) {
                                    return Image.asset(
                                        "assets/images/logo_ts_red.png");
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      dataNews[i]["newsTitle"],
                                      style: GoogleFonts.roboto(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        fontSize: 13,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Container(
                                    width: 300,
                                    margin: EdgeInsets.only(
                                        left: 11.0, bottom: 3.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            dataNews[i]["newsDate"],
                                            style: GoogleFonts.roboto(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                              fontSize: 10,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  displayHomeWallpaper(
      BuildContext context,
      bool isLogin,
      List dataCard,
      Member member,
      int unreadNotification,
      Function handleBottomBarChanged,
      // Function showPundi,
      // _currentOrganisasi,
      // _selectOrganisasi,
      // _dataOrganisasi,
      Function displayQR,
      String qrURL,
      bool useMobileLayout,
      var card,
      Size sizeCard,
      Function _onFilterTap) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    print("shortestSide:  " + shortestSide.toString());
    final bool useMobileLayout = shortestSide < 500;
    var heightBgTop;
    var heightBgBottom;
    print("ini size card:  " + sizeCard.toString());
    // var sizeCard = 200;
    if (sizeCard != null) {
      if (shortestSide < 300) {
        heightBgTop = (sizeCard.height / 1);
        print("<300");
      } else if (shortestSide < 400) {
        print("<400");
        heightBgTop = (sizeCard.height / 1.17);
      } else if (shortestSide < 500) {
        print("<500");
        heightBgTop = (sizeCard.height / 1.25);
      } else if (shortestSide < 600) {
        print("<600");
        heightBgTop = (sizeCard.height / 1.3);
      } else {
        print("else");
        heightBgTop = (sizeCard.height / 1.35);
      }
    } else {
      if (shortestSide < 300) {
        heightBgTop = (MediaQuery.of(context).size.height / 4.15);
      } else if (shortestSide < 400) {
        heightBgTop = (MediaQuery.of(context).size.height / 3.3);
      } else if (shortestSide < 500) {
        heightBgTop = (MediaQuery.of(context).size.height / 4.23);
      } else if (shortestSide < 600) {
        heightBgTop = (MediaQuery.of(context).size.height / 2.5);
      } else {
        heightBgTop = (MediaQuery.of(context).size.height / 2.65);
      }
    }

    if (sizeCard != null) {
      if (shortestSide < 300) {
        heightBgBottom = (sizeCard.height / 1.95);
      } else if (shortestSide < 400) {
        heightBgBottom = (sizeCard.height / 2);
      } else if (shortestSide < 500) {
        heightBgBottom = (sizeCard.height / 2.2);
      } else if (shortestSide < 600) {
        heightBgBottom = (sizeCard.height / 2.1);
      } else {
        heightBgBottom = (sizeCard.height / 2.25);
      }
    } else {
      if (shortestSide < 300) {
        heightBgBottom = (MediaQuery.of(context).size.height / 7);
      } else if (shortestSide < 400) {
        heightBgBottom = (MediaQuery.of(context).size.height / 5);
      } else if (shortestSide < 500) {
        heightBgBottom = (MediaQuery.of(context).size.height / 6.5);
      } else if (shortestSide < 600) {
        heightBgBottom = (MediaQuery.of(context).size.height / 3.5);
      } else {
        heightBgBottom = (MediaQuery.of(context).size.height / 2.65);
      }
    }
    return Stack(
      children: <Widget>[
        // Column(
        //   children: <Widget>[
        //     Container(
        //         height: !isLogin
        //             ? ScreenUtil().setSp(170)
        //             : ScreenUtil().setSp(200),
        //         decoration: BoxDecoration(
        //             gradient: LinearGradient(
        //                 begin: Alignment.centerLeft,
        //                 end: Alignment.centerRight,
        //                 colors: [
        //               Color.fromRGBO(22, 50, 88, 1),
        //               Color.fromRGBO(5, 129, 174, 1)
        //             ]))),
        //     Container(
        //       margin: EdgeInsets.only(
        //           bottom: shortestSide < 300 ? ScreenUtil().setSp(0) :  shortestSide < 400 ? ScreenUtil().setSp(10) : shortestSide < 500 ? ScreenUtil().setSp(23) : ScreenUtil().setSp(5)),
        //       height: !isLogin
        //           ? shortestSide > 500 ? MediaQuery.of(context).size.height / ScreenUtil().setSp(12.5) : MediaQuery.of(context).size.height / ScreenUtil().setSp(25)
        //           : sizeCard != null
        //               ? useMobileLayout
        //                   ? (sizeCard.height / ScreenUtil().setSp(2) -
        //                       ScreenUtil().setSp(10))
        //                   : (sizeCard.height / ScreenUtil().setSp(1.5))
        //               : useMobileLayout
        //                   ? (MediaQuery.of(context).size.height /
        //                       ScreenUtil().setSp(7))
        //                   : MediaQuery.of(context).size.height /
        //                       ScreenUtil().setSp(2.9),
        //       color: baseColor,
        //     )
        //   ],
        // ),
        Column(
          children: <Widget>[
            Container(
                height: !isLogin ? ScreenUtil().setSp(150) : heightBgTop,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                      Color.fromRGBO(159, 28, 42, 1),
                      Color.fromRGBO(159, 28, 42, 1),
                    ]))),
            Container(
              margin: EdgeInsets.only(
                  bottom: isLogin
                      ? shortestSide < 300
                          ? ScreenUtil().setSp(20)
                          : shortestSide < 400
                              ? ScreenUtil().setSp(30)
                              : shortestSide < 500
                                  ? ScreenUtil().setSp(40)
                                  : ScreenUtil().setSp(45)
                      : 0),
              height: !isLogin
                  ? 0
                  // ? shortestSide > 500
                  //     ? MediaQuery.of(context).size.height /
                  //         ScreenUtil().setSp(12.5)
                  //     : MediaQuery.of(context).size.height /
                  //         ScreenUtil().setSp(25)
                  : heightBgBottom,
              color: baseColor,
            )
          ],
        ),
        isLogin
            ? Container()
            : Positioned(
                top: ScreenUtil().setSp(90),
                left: ScreenUtil().setSp(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Belum jadi member 非会员 ?",
                      style: GoogleFonts.roboto(
                        fontSize: ScreenUtil().setSp(10),
                        color: Colors.yellow[200],
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    InkWell(
                      onTap:
                          //  () {},
                          () {
                        if (Platform.isAndroid) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegisterOption()));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Register(
                                  name: "",
                                  email: "",
                                  googleId: "",
                                  fbId: "",
                                  appleId: "",
                                  twitterId: "",
                                  emailVerification: 'n'),
                              settings: RouteSettings(name: "Register")));
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            "Daftar Sekarang",
                            style: GoogleFonts.roboto(
                              fontSize: ScreenUtil().setSp(14),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "立即注册",
                            style: GoogleFonts.roboto(
                              fontSize: ScreenUtil().setSp(12),
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
        isLogin
            ? Container()
            : Positioned(
                top: ScreenUtil().setSp(90),
                right: ScreenUtil().setSp(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Sudah daftar 已经登记了 ?",
                      style: GoogleFonts.roboto(
                        fontSize: ScreenUtil().setSp(10),
                        color: Colors.yellow[200],
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    InkWell(
                      onTap:
                          // () {},
                          () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Row(
                        children: [
                          Text(
                            "Masuk",
                            style: GoogleFonts.roboto(
                              fontSize: ScreenUtil().setSp(14),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "登入",
                            style: GoogleFonts.roboto(
                              fontSize: ScreenUtil().setSp(12),
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
        // isLogin
        //     ?
        //     Positioned(
        //         top: ScreenUtil().setSp(125),
        //         left: ScreenUtil().setSp(0),
        //         right: ScreenUtil().setSp(0),
        //         child: HomeWidgets().displaySearchBox(
        //             context,
        //             _currentOrganisasi,
        //             _selectOrganisasi,
        //             _dataOrganisasi,)):Container(),
        //baru=======
        isLogin
            ? Positioned(
                // bottom: 10,
                top: ScreenUtil().setSp(48),
                left: ScreenUtil().setSp(-90),
                right: ScreenUtil().setSp(-90),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: isLogin
                      ? Column(
                          children: [
                            InkWell(
                                onDoubleTap: () {
                                  displayQR();
                                },
                                child: HomeWidgets()
                                    // .displayMemberCard(context, dataCard),
                                    .displayMemberCard(context, dataCard,
                                        member, card, qrURL)),
                            //     HomeWidgets().displaySearchBox(
                            // context,
                            // _currentOrganisasi,
                            // _selectOrganisasi,
                            // _dataOrganisasi,),
                          ],
                        )
                      : SizedBox.shrink(),
                ))
            : SizedBox.shrink(),

        // isLogin?Container():
        // Positioned(
        //         top: ScreenUtil().setSp(125),
        //         left: ScreenUtil().setSp(0),
        //         right: ScreenUtil().setSp(0),
        //         child: HomeWidgets().displaySearchBox(
        //             context,
        //             _currentOrganisasi,
        //             _selectOrganisasi,
        //             _dataOrganisasi,)),
        Positioned(
          left: 5,
          top: 40,
          child: Align(
            alignment: FractionalOffset(0.3, 0.7),
            child: Row(
              children: <Widget>[
                Image.asset("assets/images/logo_icati.png",
                    width: ScreenUtil().setSp(65),
                    height: ScreenUtil().setSp(40)),
                isLogin
                    ? Text(
                        "Halo 你好, " + member.mFirstName.toString(),
                        style: GoogleFonts.roboto(
                          fontSize: ScreenUtil().setSp(14),
                          color: Colors.yellow[200],
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Column(
                        children: [
                          Text(
                            "Halo ",
                            style: GoogleFonts.roboto(
                              fontSize: ScreenUtil().setSp(14),
                              color: Colors.yellow[200],
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text("你好 ",
                              style: GoogleFonts.roboto(
                                fontSize: ScreenUtil().setSp(11),
                                color: Colors.yellow[200],
                                fontWeight: FontWeight.w400,
                              ))
                        ],
                      ),
              ],
            ),
          ),
        ),
        !isLogin
            ? Positioned(
                right: 8,
                top: 34,
                child: Align(
                  alignment: FractionalOffset(0.9, 0.7),
                  child: IconButton(
                      padding: const EdgeInsets.all(4),
                      onPressed: _onFilterTap,
                      icon: Icon(Icons.filter_alt),
                      color: Colors.white),
                  // CircleAvatar(
                  //   child: CachedNetworkImage(
                  //     imageUrl: member.pic != null
                  //         ? member.urlSource + member.mDir + "/" + member.mPic
                  //         : "http://icati.webby.digital/assets/images/account_picture_default.png",
                  //     imageBuilder: (context, imageProvider) => Container(
                  //       width: 32.0,
                  //       height: 32.0,
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         image: DecorationImage(
                  //             image: imageProvider, fit: BoxFit.cover),
                  //       ),
                  //     ),
                  //     placeholder: (context, i) {
                  //       return Container(
                  //         decoration: BoxDecoration(
                  //             color: Colors.white, shape: BoxShape.circle),
                  //         child: SizedBox(
                  //           height: 32,
                  //           width: 32,
                  //           child:
                  //               Image.asset("assets/images/logo_ts_red.png"),
                  //         ),
                  //       );
                  //     },
                  //     errorWidget: (_, __, ___) {
                  //       return Image.asset(
                  //           "assets/images/account_picture_default.png");
                  //     },
                  //   ),
                  //   radius: 16,
                  // ),
                ),
              )
            : Positioned(
                right: 45,
                top: 34,
                child: Align(
                  alignment: FractionalOffset(0.9, 0.7),
                  child: IconButton(
                      padding: const EdgeInsets.all(4),
                      onPressed: _onFilterTap,
                      icon: Icon(Icons.filter_alt),
                      color: Colors.white),
                  // CircleAvatar(
                  //   child: CachedNetworkImage(
                  //     imageUrl: member.pic != null
                  //         ? member.urlSource + member.mDir + "/" + member.mPic
                  //         : "http://icati.webby.digital/assets/images/account_picture_default.png",
                  //     imageBuilder: (context, imageProvider) => Container(
                  //       width: 32.0,
                  //       height: 32.0,
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         image: DecorationImage(
                  //             image: imageProvider, fit: BoxFit.cover),
                  //       ),
                  //     ),
                  //     placeholder: (context, i) {
                  //       return Container(
                  //         decoration: BoxDecoration(
                  //             color: Colors.white, shape: BoxShape.circle),
                  //         child: SizedBox(
                  //           height: 32,
                  //           width: 32,
                  //           child:
                  //               Image.asset("assets/images/logo_ts_red.png"),
                  //         ),
                  //       );
                  //     },
                  //     errorWidget: (_, __, ___) {
                  //       return Image.asset(
                  //           "assets/images/account_picture_default.png");
                  //     },
                  //   ),
                  //   radius: 16,
                  // ),
                ),
              ),
        !isLogin
            ? Container()
            : Positioned(
                right: 8,
                top: 34,
                child: Align(
                  alignment: FractionalOffset(0.9, 0.7),
                  child: IconButton(
                    padding: const EdgeInsets.all(4),
                    icon: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Icon(
                              unreadNotification != 0
                                  ? FontAwesomeIcons.solidBell
                                  : FontAwesomeIcons.bell,
                              color: Colors.white),
                        ),
                        unreadNotification != 0
                            ? Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red),
                                  padding: EdgeInsets.all(
                                      unreadNotification < 10 ? 4 : 2),
                                  child: Text(unreadNotification.toString(),
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white)),
                                ),
                              )
                            : Container()
                      ],
                    ),
                    onPressed: () async {
                      final information = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => NotificationMain()),
                      );
                      // if (information != null) {
                      //   menuBarPresenter.getUnreadNotification(mId, employee.perusahaanId.toString());
                      // }
                    },
                    tooltip: "Notifikasi",
                  ),
                  // Stack(
                  //   children: <Widget>[
                  //     Align(
                  //       alignment: Alignment.center,
                  //       child: Icon(unreadNotification != 0 ? FontAwesomeIcons.solidBell : FontAwesomeIcons.bell, size: 22, color: Colors.white),
                  //     ),
                  //     unreadNotification == 0
                  //         ? Align(
                  //             alignment: Alignment.topRight,
                  //             child: Container(
                  //               decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  //               padding: EdgeInsets.all(unreadNotification < 10 ? 4 : 2),
                  //               child: Text(
                  //                 1.toString(),
                  //                 style: TextStyle(fontSize: 9, color: Colors.white),
                  //               ),
                  //             ),
                  //           )
                  //         : Container()
                  //   ],
                  // ),
                ),
              ),
      ],
    );
  }

  Widget displayAgenda(BuildContext context, List dataAgenda) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(
          left: ScreenUtil().setSp(10),
          top: ScreenUtil().setSp(10),
          right: ScreenUtil().setSp(10),
          bottom: ScreenUtil().setSp(10)),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setSp(10),
                right: ScreenUtil().setSp(10),
                top: ScreenUtil().setSp(16)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.calendar,
                            size: 19, color: Colors.black),
                        SizedBox(width: ScreenUtil().setSp(6)),
                        Row(
                          children: [
                            Text(
                              "Agenda Kegiatan",
                              style: GoogleFonts.roboto(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              " 活动议程",
                              style: GoogleFonts.roboto(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap:
                        //  () {},
                        () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Agenda(),
                        settings: RouteSettings(name: "Agenda"),
                      ));
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
            height: ScreenUtil().setSp(150),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dataAgenda == null ? 0 : dataAgenda.length,
                itemBuilder: (context, i) {
                  return new Container(
                    child: new Row(
                      children: <Widget>[
                        i == 0
                            ? SizedBox(width: ScreenUtil().setSp(1))
                            : SizedBox(),
                        agendaCard(
                          context,
                          i,
                          dataAgenda,
                        ),
                        SizedBox(width: ScreenUtil().setSp(5)),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget agendaCard(BuildContext context, int i, List dataAgenda) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              AgendaDetail(id: dataAgenda[i]["akId"].toString()),
          settings: RouteSettings(name: "Detail Agenda"),
        ));
      },
      child: Container(
        // margin: EdgeInsets.only(
        //   left: ScreenUtil().setSp(10),
        // ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    //top: ScreenUtil().setSp(10),
                    left: ScreenUtil().setSp(10),
                    right: ScreenUtil().setSp(10),
                    //bottom: ScreenUtil().setSp(10),
                  ),
                  width: ScreenUtil().setSp(120), //500,
                  height: ScreenUtil().setSp(120), //350,
                  child: FittedBox(
                    child: Container(
                      width: ScreenUtil().setSp(100), //500,
                      height: ScreenUtil().setSp(100),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: dataAgenda[i]['akPic'],
                          placeholder: (context, i) {
                            return Padding(
                              padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                              child:
                                  Image.asset("assets/images/logo_ts_red.png"),
                            );
                          },
                          errorWidget: (_, __, ___) {
                            return Padding(
                              padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                              child:
                                  Image.asset("assets/images/logo_ts_red.png"),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    width: ScreenUtil().setSp(175), //500,
                    height: ScreenUtil().setSp(125),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.only(right: ScreenUtil().setSp(10)),
                          child: Text(
                            dataAgenda[i]['akTitle'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: ScreenUtil().setSp(11),
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setSp(5)),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  dataAgenda[i]['akDate'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(fontSize: 10.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setSp(4)),
                        Container(
                            width: ScreenUtil().setSp(300),
                            //margin: EdgeInsets.only(left: 0.0, bottom: 0.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    dataAgenda[i]['akPlace'],
                                    // dataAgenda[i]['kabupatenName'] +
                                    //     ", " +
                                    //     dataAgenda[i]['provinsiName'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                            color: Colors.grey, fontSize: 10.5),
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(height: ScreenUtil().setSp(4)),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget displayDonasi(BuildContext context, List dataDonasi) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(ScreenUtil().setSp(10)),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setSp(16),
                right: ScreenUtil().setSp(16),
                top: ScreenUtil().setSp(16)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.donate,
                            size: 19, color: Colors.black),
                        SizedBox(width: ScreenUtil().setSp(6)),
                        Text(
                          "Donasi",
                          style: GoogleFonts.roboto(
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => Donasi()));
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
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            //removeBottom: true,
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: dataDonasi == null ? 0 : dataDonasi.length,
                itemBuilder: (context, i) {
                  return new Container(
                    child: donasiCard(context, i, dataDonasi),
                  );
                }),
          ),
          SizedBox(height: ScreenUtil().setSp(4)),
        ],
      ),
    );
  }

  Widget donasiCard(BuildContext context, int i, List dataDonasi) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              DonasiDetail(id: dataDonasi[i]["socialId"].toString()),
          settings: RouteSettings(name: "Detail Donasi"),
        ));
      },
      child: Container(
        //margin: EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setSp(10),
                  right: ScreenUtil().setSp(10),
                  top: ScreenUtil().setSp(10),
                  bottom: ScreenUtil().setSp(10)),
              width: ScreenUtil().setSp(120), //500,
              height: ScreenUtil().setSp(120), //350,
              child: FittedBox(
                child: Container(
                  width: ScreenUtil().setSp(100), //500,
                  height: ScreenUtil().setSp(100),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: dataDonasi[i]['socialPic'],
                      placeholder: (context, i) {
                        return Padding(
                          padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                          child: Image.asset("assets/images/logo_ts_red.png"),
                        );
                      },
                      errorWidget: (_, __, ___) {
                        return Padding(
                          padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                          child: Image.asset("assets/images/logo_ts_red.png"),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: ScreenUtil().setSp(175), //500,
                height: ScreenUtil().setSp(125),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(right: ScreenUtil().setSp(10)),
                      child: Text(
                        dataDonasi[i]['socialName'],
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: ScreenUtil().setSp(11),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setSp(4)),
                    Text(dataDonasi[i]['socialFundPretty'].toString()),
                    SizedBox(height: ScreenUtil().setSp(4)),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              dataDonasi[i]['socialDateRangePretty'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontSize: 10.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget displayOrganitation(BuildContext context, List dataOrganitation) {
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
                      Icon(FontAwesomeIcons.users,
                          size: 19, color: Colors.black),
                      SizedBox(width: 6),
                      Row(
                        children: [
                          Text(
                            " Organisasi",
                            style: GoogleFonts.roboto(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            " 组织",
                            style: GoogleFonts.roboto(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap:
                        //  () {},
                        () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Organisasi(),
                        settings: RouteSettings(name: "Organisasi"),
                      ));
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
              itemCount: dataOrganitation == null ? 0 : dataOrganitation.length,
              itemBuilder: (context, i) {
                return Row(
                  children: <Widget>[
                    i == 0
                        ? SizedBox(width: ScreenUtil().setSp(2))
                        : Container(),
                    GestureDetector(
                      onTap: () {},
                      child: organitation(
                        context,
                        i,
                        dataOrganitation,
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

  Widget organitation(BuildContext context, int i, List dataOrganitation) {
    return GestureDetector(
      onTap:
          // () {},
          () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OrganisasiDetail(
              id: dataOrganitation[i]['organizationId'].toString()),
          settings: RouteSettings(name: "Detail Organisasi"),
        ));
      },
      child: Container(
        child: new FittedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: dataOrganitation[i]['urlSource'],
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
                      dataOrganitation[i]['organizationName'],
                      maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
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

  Widget displayNewMember(BuildContext context, List dataMember, String mId) {
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
                        "Member Baru ",
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text("新成员",
                          style: GoogleFonts.roboto(
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          )),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => MenuBar(currentPage: 1)),
                        (Route<dynamic> predicate) => false,
                      );
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
                        mId,
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

  Widget newMember(BuildContext context, int i, List dataMember, String mId) {
    print(dataMember.toString());
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailExplore(
                  dataExplore: dataMember[i],
                  mId: mId,
                )));
      },
      child: Container(
        child: new FittedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: dataMember[i]['pic'] == ""
                    ? "http://icati.or.id/assets/images/account_picture_default.png"
                    : dataMember[i]['pic'],
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

  Widget displayBanner(BuildContext context, List dataBanner, isLogin) {
    return Container(
      // margin: EdgeInsets.only(
      //     bottom: ScreenUtil().setSp(14),
      //     top: isLogin ? 0 : ScreenUtil().setSp(10)),
      child: AspectRatio(
        aspectRatio: 2.5,
        child: Carousel_Pro(
          // boxFit: BoxFit.contain,
          autoplay: true,
          autoplayDuration: Duration(seconds: 3),
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 1000),
          dotSize: 6,
          dotSpacing: 16,
          dotColor: Colors.white,
          indicatorBgPadding: 15,
          dotBgColor: Colors.transparent,
          showIndicator: true,
          images: dataBanner.map((pic) {
            // print(pic);
            return CachedNetworkImageProvider(pic['mbanPic'],
                headers: {"url": pic['mbanURL']});
          }).toList(),
        ),
      ),
    );
  }

  Widget displayKerjasama(
      BuildContext context, List dataKerjasama, asyncConfirmDialog) {
    return Container(
      margin: EdgeInsets.only(
          right: ScreenUtil().setSp(10), top: ScreenUtil().setSp(10)),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Icon(FontAwesomeIcons.briefcase, size: 19, color: Colors.black),
                SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "Kerja Sama",
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        " 关系",
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap:
                        // () {},
                        () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => KerjaSama(),
                        settings: RouteSettings(name: "Kerja Sama"),
                      ));
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
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16.0, bottom: 20.0, left: 10),
            height: 120.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dataKerjasama == null ? 0 : dataKerjasama.length,
              itemBuilder: (context, i) {
                return Row(
                  children: <Widget>[
                    i == 0 ? SizedBox(width: 10.0) : Container(),
                    InkWell(
                      onTap: () {
                        asyncConfirmDialog(
                            context,
                            dataKerjasama[i]['KerjasamaName'],
                            dataKerjasama[i]['KerjasamaDesc'],
                            dataKerjasama[i]['KerjasamaLink'],
                            dataKerjasama[i]['urlSource']);
                      },
                      child: kerjasamaCard(
                        dataKerjasama[i]['urlSource'],
                        dataKerjasama[i]['KerjasamaName'],
                      ),
                    ),
                    SizedBox(width: 16.0),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget kerjasamaCard(String image, String titleName) {
    return Container(
      child: new FittedBox(
        child: Material(
          color: Colors.white,
          elevation: 0.0,
          borderRadius: BorderRadius.circular(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(children: <Widget>[
                Container(
                  height: 100,
                  margin: EdgeInsets.only(top: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.contain,
                      imageUrl: image,
                      placeholder: (context, i) {
                        return Image.asset("assets/images/logo_ts_red.png");
                      },
                    ),
                  ),
                ),
              ]),
              Container(
                width: 180,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    titleName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 14.0,
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

  Widget displayRelatedLink(BuildContext context, List data) {
    return Container(
      margin: EdgeInsets.only(
          right: ScreenUtil().setSp(10), top: ScreenUtil().setSp(5)),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              children: [
                Icon(FontAwesomeIcons.link, size: 19, color: Colors.black),
                SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "Link Terkait",
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        " 连接的链接",
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap:
                        // () {},
                        () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RelatedLink(),
                        settings: RouteSettings(name: "Link Terkait"),
                      ));
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
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                right: ScreenUtil().setSp(16),
                top: ScreenUtil().setSp(16),
                bottom: ScreenUtil().setSp(16)),
            height: 120.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, i) {
                return Row(
                  children: <Widget>[
                    i == 0 ? SizedBox(width: 20.0) : Container(),
                    GestureDetector(
                      onTap: () {
                        BaseFunction().launchURL(data[i]['relatedLink']);
                      },
                      child: relatedLink(
                        data[i]['relatedName'],
                        data[i]['relatedLink'],
                        data[i]['relatedPic'],
                      ),
                    ),
                    SizedBox(width: 16.0),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget relatedLink(String name, String link, String pic) {
    return Container(
      child: new FittedBox(
        child: Material(
          color: Colors.white,
          elevation: 0.0,
          borderRadius: BorderRadius.circular(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(children: <Widget>[
                Container(
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.contain,
                      imageUrl: pic,
                      placeholder: (context, i) {
                        return Image.asset("assets/images/logo_ts_red.png");
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                ),
              ]),
              Container(
                width: 168,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
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

  Widget displayDirectory(BuildContext context, List dataDirectory,
      int directoryTap, Function onChangeDirectory) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(ScreenUtil().setSp(10)),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 25.0),
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.store, size: 19, color: Colors.black),
                SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "Direktori Bisnis",
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        " 目录",
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => MenuBar(currentPage: 3)),
                        (Route<dynamic> predicate) => false,
                      );
                    },
                    child: Text(
                      "Lihat Semua",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'roboto',
                          fontWeight: FontWeight.bold,
                          color: Color(0xffBA0606)),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 70,
            // margin: EdgeInsets.only(top: 16.0, bottom: 20.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dataDirectory == null ? 0 : dataDirectory.length,
              itemBuilder: (context, i) {
                return Row(
                  children: <Widget>[
                    i == 0 ? SizedBox(width: 16.0) : Container(),
                    GestureDetector(
                      onTap: () {
                        //tapCategory(i);
                      },
                      child: catDirectory(context, i, dataDirectory,
                          onChangeDirectory, directoryTap),
                    ),
                    SizedBox(width: 16.0),
                  ],
                );
              },
            ),
          ),
          Container(
            height: 240.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dataDirectory[directoryTap]['data'] == null
                  ? 0
                  : dataDirectory[directoryTap]['data'].length,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemBuilder: (context, i) {
                return Row(
                  children: <Widget>[
                    i != 0 ? SizedBox(width: 16.0) : Container(),
                    directoryList(
                        context, i, dataDirectory[directoryTap]['data']),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget catDirectory(BuildContext context, int i, List dataCat,
      Function onChangeDirectory, int directoryTap) {
    return InkWell(
        onTap: () async {
          onChangeDirectory(i);
        },
        child: Container(
          child: new FittedBox(
            child: Material(
              color: Colors.white,
              elevation: 2.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Column(
                children: <Widget>[
                  dataCat[i] == dataCat[directoryTap]
                      ? Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              dataCat[i]['mCatName'],
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                        )
                      : Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              dataCat[i]['mCatName'],
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ));
  }

  Widget directoryList(BuildContext context, int i, List dataDirectory) {
    return GestureDetector(
      onTap: () {
        var route = new MaterialPageRoute(
          builder: (BuildContext context) => DirectoryDetail(
            id: dataDirectory[i]['merchantId'].toString(),
          ),
          settings: RouteSettings(name: 'Detail Directory Page'),
        );
        Navigator.of(context).push(route);
      },
      child: Container(
        child: new FittedBox(
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0.0),
            //shadowColor: Color(0x802196F3),
            child: Column(
              children: <Widget>[
                Stack(
                  children: [
                    FittedBox(
                      child: Container(
                        width: 325, //500,
                        height: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(19.0),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: dataDirectory[i]['merchantPic'],
                            placeholder: (context, i) {
                              return Image.asset(
                                  "assets/images/logo_ts_red.png");
                            },
                            errorWidget: (_, __, ___) {
                              return Image.asset(
                                  "assets/images/logo_ts_red.png");
                            },
                          ),
                        ),
                      ),
                    ),
                    dataDirectory[i]['merchantDiscount'].toString() == ""
                        ? Container()
                        : Positioned(
                            top: 0,
                            right: 0,
                            child: dataDirectory[i]['merchantDiscount']
                                        .toString() !=
                                    "0"
                                ? Stack(
                                    children: <Widget>[
                                      new Container(
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: new BoxDecoration(
                                            borderRadius:
                                                new BorderRadius.circular(20.0),
                                            color: Colors.deepOrange[400]),
                                        child: Text(
                                          "Disc " +
                                              dataDirectory[i]
                                                  ['merchantDiscount'] +
                                              "%",
                                          //textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: 'expressway',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          )
                  ],
                ),
                Container(
                  width: 300, //500,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 5.0),
                    child: Text(
                      dataDirectory[i]['merchantName'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                    width: 300,
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: new Icon(Icons.location_on),
                        ),
                        SizedBox(width: 5.0),
                        Expanded(
                          child: Text(dataDirectory[i]['merchantAddress'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontSize: 22)),
                        ),
                      ],
                    )),
                Container(
                    width: 300,
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        new Icon(Icons.phone_android),
                        SizedBox(width: 5.0),
                        Expanded(
                          child: Text(dataDirectory[i]['merchantHp'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontSize: 22)),
                        ),
                      ],
                    )),
                Container(
                    width: 300,
                    margin: EdgeInsets.only(bottom: 60.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: new Icon(Icons.access_time),
                        ),
                        SizedBox(width: 5.0),
                        Expanded(
                          child: Text(
                              dataDirectory[i]['merchantTime'].toString() == ""
                                  ? "-"
                                  : dataDirectory[i]['merchantTime'].toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontSize: 22)),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget displayProfileBar(
      BuildContext context, List dataComplete, Function completeDataHome) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    return dataComplete[0]["profilebar"] == 100
        ? Container()
        : Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setSp(6),
                right: ScreenUtil().setSp(6),
                top: shortestSide < 300
                    ? ScreenUtil().setSp(0)
                    : ScreenUtil().setSp(0),
                bottom: 10),
            height: 100,
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    dataComplete[0]["profilebar"] == 100
                        ? Container()
                        : InkWell(
                            onTap: () {},
                            child: Center(
                              child: Text(
                                "Data Anda belum lengkap! Yuk lengkapi!",
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            )),
                    SizedBox(height: 16),
                    dataComplete[0]["profilebar"] == 100
                        ? Container()
                        : InkWell(
                            onTap: () {
                              completeDataHome;
                              print("ini tap profile");
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      EditProfile(dataComplete),
                                  settings:
                                      RouteSettings(name: "Ubah Profil")));
                            },
                            child: LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width - 60,
                              animation: true,
                              lineHeight: 20.0,
                              addAutomaticKeepAlive: false,
                              animationDuration: 2000,
                              center: Text(
                                dataComplete[0]["profilebar"].toString() + "%",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "roboto",
                                    color: Colors.white),
                              ),
                              percent: dataComplete[0]["profilebar"] / 100,
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              progressColor: Colors.lightBlueAccent,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget displayJob(BuildContext context, List dataJob) {
    print(dataJob);
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(ScreenUtil().setSp(10)),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setSp(16),
                right: ScreenUtil().setSp(16),
                top: ScreenUtil().setSp(16)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: [
                      Icon(FontAwesomeIcons.suitcase,
                          size: 19, color: Colors.black),
                      SizedBox(width: ScreenUtil().setSp(10)),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              "Lowongan Kerja",
                              style: GoogleFonts.roboto(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              " 工作",
                              style: GoogleFonts.roboto(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ScreenUtil().setSp(8)),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobList(),
                          settings: RouteSettings(name: 'Job List'),
                        ),
                      );
                    },
                    child: Text(
                      "Lihat Semua",
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffBA0606),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            //margin: EdgeInsets.only(top: ScreenUtil().setSp(0)),
            height: shortestSide > 500
                ? ScreenUtil().setSp(265)
                : shortestSide < 400
                    ? ScreenUtil().setSp(275)
                    : ScreenUtil().setSp(245),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dataJob == null ? 0 : dataJob.length,
                itemBuilder: (context, i) {
                  return new Container(
                    child: new Row(
                      children: <Widget>[
                        i == 0
                            ? SizedBox(width: ScreenUtil().setSp(1))
                            : SizedBox(),
                        jobCard(
                          context,
                          i,
                          dataJob,
                        ),
                        SizedBox(width: ScreenUtil().setSp(5)),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget jobCard(BuildContext context, int i, List dataJob) {
    return GestureDetector(
      onTap: () {
        var route = new MaterialPageRoute(
            builder: (BuildContext context) =>
                new JobDetail(id: dataJob[i]['lokerId'].toString()));
        Navigator.of(context).push(route);
      },
      child: new Container(
        margin: EdgeInsets.only(
            left: i == 0 ? ScreenUtil().setSp(10) : 0,
            top: ScreenUtil().setSp(16)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              //padding: EdgeInsets.all(ScreenUtil().setSp(3)),
              width: ScreenUtil().setSp(120),
              height: ScreenUtil().setSp(120),
              child: FittedBox(
                child: Container(
                  width: ScreenUtil().setSp(100), //500,
                  height: ScreenUtil().setSp(100),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: dataJob[i]['lokerPic'],
                      placeholder: (context, i) {
                        return Image.asset("assets/images/logo_ts_red.png");
                      },
                      errorWidget: (_, __, ___) {
                        return Image.asset("assets/images/logo_ts_red.png");
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setSp(10)),
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setSp(5), right: ScreenUtil().setSp(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: ScreenUtil().setSp(100),
                    child: Text(
                      dataJob[i]['lokerName'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: ScreenUtil().setSp(11),
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setSp(10)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: ScreenUtil().setSp(4)),
                        child: Icon(Icons.location_city, size: 15),
                      ),
                      SizedBox(width: ScreenUtil().setSp(10)),
                      Container(
                        width: ScreenUtil().setSp(100),
                        child: Text(
                          dataJob[i]['lokerCompanyName'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontSize: 10.5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenUtil().setSp(3)),
                  Row(
                    children: <Widget>[
                      new Icon(Icons.supervisor_account, size: 15),
                      SizedBox(width: ScreenUtil().setSp(10)),
                      Container(
                        width: ScreenUtil().setSp(100),
                        child: Text(
                          dataJob[i]['bidangName'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontSize: 10.5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenUtil().setSp(3)),
                  Row(
                    children: <Widget>[
                      new Icon(Icons.calendar_today, size: 15),
                      SizedBox(width: ScreenUtil().setSp(10)),
                      Container(
                        width: ScreenUtil().setSp(100),
                        child: Text(
                          dataJob[i]['lokerCombineDate'].toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontSize: 10.5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenUtil().setSp(3)),
                  Row(
                    children: <Widget>[
                      new Icon(Icons.location_on, size: 15),
                      SizedBox(width: ScreenUtil().setSp(10)),
                      Container(
                        width: ScreenUtil().setSp(100),
                        child: Text(
                          // "m",
                          dataJob[i]['lokerlocation'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontSize: 10.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget displayPhoto(BuildContext context, List dataPhoto) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(ScreenUtil().setSp(10)),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: 16.0, right: 16.0, top: 16.0, bottom: 0.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.images,
                            size: 19, color: Colors.black),
                        SizedBox(width: 6),
                        Row(
                          children: [
                            Text(
                              "Galeri Foto",
                              style: GoogleFonts.roboto(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              " 照片库",
                              style: GoogleFonts.roboto(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap:
                        // () {},
                        () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GalleryPhoto(),
                        settings: RouteSettings(name: "Galeri Foto"),
                      ));
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
            height: 160.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dataPhoto == null ? 0 : dataPhoto.length,
                itemBuilder: (context, i) {
                  return new Container(
                    child: new Row(
                      children: <Widget>[
                        i == 0 ? SizedBox(width: 1.0) : SizedBox(),
                        photoCard(
                          context,
                          i,
                          dataPhoto,
                        ),
                        //SizedBox(width: 16.0),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget photoCard(BuildContext context, int i, List dataPhoto) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GalleryPhotoDetail(
            albumId: dataPhoto[i]["albId"].toString(),
            albumName: dataPhoto[i]["albName"],
          ),
          settings: RouteSettings(name: "Detail Galeri Foto"),
        ));
      },
      child: Container(
        margin: EdgeInsets.only(
          left: i == 0 ? 10 : 0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    top: 10,
                    //left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  width: 130, //500,
                  height: 130, //350,
                  child: FittedBox(
                    child: Container(
                      width: 100, //500,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: dataPhoto[i]['albPic'],
                          placeholder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child:
                                  Image.asset("assets/images/logo_ts_red.png"),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                    width: 120, //500,
                    height: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.only(left: 0.0, right: 10.0, top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  BaseFunction().convertToDate(
                                      dataPhoto[i]['albAddedDate'], "d MMMM y"),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          color: Colors.black45, fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 120,
                          child: Text(dataPhoto[i]['albName'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(
                                      fontSize: 12.5,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 8),
                        Container(
                            width: 300,
                            margin: EdgeInsets.only(left: 0.0, bottom: 0.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.photo, size: 15),
                                SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    dataPhoto[i]['jumlahPhoto'].toString() +
                                        " Foto",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(height: 4),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget displayVideo(BuildContext context, List dataVideo) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(ScreenUtil().setSp(10)),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setSp(16),
                right: ScreenUtil().setSp(16),
                top: ScreenUtil().setSp(16)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.images,
                            size: 19, color: Colors.black),
                        SizedBox(width: ScreenUtil().setSp(6)),
                        Row(
                          children: [
                            Text(
                              "Galeri Video",
                              style: GoogleFonts.roboto(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              " 视频库",
                              style: GoogleFonts.roboto(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap:
                        // () {},
                        () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GalleryVideo(),
                        settings: RouteSettings(name: "Galeri Video"),
                      ));
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
            height: ScreenUtil().setSp(200),
            //margin: const EdgeInsets.only(bottom: 16),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dataVideo == null ? 0 : dataVideo.length,
                itemBuilder: (context, i) {
                  return new Container(
                    child: new Row(
                      children: <Widget>[
                        i == 0
                            ? SizedBox(width: ScreenUtil().setSp(1))
                            : SizedBox(),
                        videoCard(context, i, dataVideo),
                        //SizedBox(width: 16.0),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget videoCard(BuildContext context, int i, List dataVideo) {
    return InkWell(
      onTap: () {
        BaseFunction().launchURL(dataVideo[i]['vidLink']);
      },
      child: Container(
        margin: EdgeInsets.only(
            left: ScreenUtil().setSp(5), top: ScreenUtil().setSp(10)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(ScreenUtil().setSp(10)),
              width: ScreenUtil().setSp(140), //500,
              height: ScreenUtil().setSp(140), //350,
              child: FittedBox(
                child: Container(
                  width: ScreenUtil().setSp(100), //500,
                  height: ScreenUtil().setSp(100),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: dataVideo[i]['albPic'],
                      placeholder: (context, i) {
                        return Padding(
                          padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                          child: Image.asset("assets/images/logo_ts_red.png"),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: ScreenUtil().setSp(120),
              padding: EdgeInsets.only(left: ScreenUtil().setSp(10)),
              child: Text(dataVideo[i]['vidName'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline1.copyWith(
                      fontSize: 12.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w500)),
            ),
            SizedBox(height: ScreenUtil().setSp(4))
          ],
        ),
      ),
    );
  }

  Widget displayMemberCard(BuildContext context, List dataCard, Member member,
      var card, String qrURL) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    print("diplayMemberCard dataCard:    " + dataCard.toString());
    return dataCard == null
        ? Container()
        : Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setSp(16), right: ScreenUtil().setSp(16)),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0), child: card),
                  ),
                ),
                Positioned(
                  left: shortestSide > 500 ? 80 : 70,
                  bottom: shortestSide > 500 ? 80 : 65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      dataCard == null
                          ? Container()
                          : Text(
                              member.mName,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontSize: 16,
                                height: 0.5,
                              ),
                            ),
                      dataCard == null
                          ? Container()
                          : Text(
                              member.mIdReference,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 12.5,
                                color: Colors.white,
                              ),
                            ),
                    ],
                  ),
                ),
                qrURL != "noQR"
                    ? Positioned(
                        right: shortestSide > 500 ? 80 : 70,
                        bottom: shortestSide > 500 ? 80 : 55,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            dataCard == null
                                ? Container()
                                : Container(
                                    // decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                                    width: 60.0,
                                    child: Image(
                                      fit: BoxFit.contain,
                                      image: NetworkImage(qrURL),
                                    ),
                                  ),
                          ],
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          );
  }

//   Widget displayHerb(BuildContext context, List dataHerb) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       margin: EdgeInsets.all(ScreenUtil().setSp(10)),
//       child: Column(
//         children: <Widget>[
//           Container(
//             margin: EdgeInsets.only(
//                 left: 16.0, right: 16.0, top: 16.0, bottom: 0.0),
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: Container(
//                     child: Row(
//                       children: [
//                         Icon(FontAwesomeIcons.leaf,
//                             size: 19, color: Colors.black),
//                         SizedBox(width: 6),
//                         Text(
//                           "Tanaman Herbal",
//                           style: GoogleFonts.roboto(
//                             textStyle: Theme.of(context).textTheme.headline4,
//                             fontSize: 15,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           maxLines: 4,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: InkWell(
//                     onTap: () async {
//                       Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => HerbalList(),
//                         settings: RouteSettings(name: "Tanaman Herbal"),
//                       ));
//                     },
//                     child: Text(
//                       "Lihat Semua",
//                       style: GoogleFonts.roboto(
//                         textStyle: Theme.of(context).textTheme.headline4,
//                         fontSize: 13,
//                         color: Color(0xffBA0606),
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: 160.0,
//             child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: dataHerb == null ? 0 : dataHerb.length,
//                 itemBuilder: (context, i) {
//                   return new Container(
//                     child: new Row(
//                       children: <Widget>[
//                         i == 0 ? SizedBox(width: 1.0) : SizedBox(),
//                         herbCard(
//                           context,
//                           i,
//                           dataHerb,
//                         ),
//                         //SizedBox(width: 16.0),
//                       ],
//                     ),
//                   );
//                 }),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget herbCard(BuildContext context, int i, List dataHerb) {
//     return InkWell(
//       onTap: () {
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => HerbalDetail(
//             herbalId: dataHerb[i]['herbalId'].toString(),
//           ),
//           settings: RouteSettings(name: "Detail HerbalList"),
//         ));
//       },
//       child: Container(
//         margin: EdgeInsets.only(
//           left: i == 0 ? 10 : 0,
//         ),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Stack(
//           children: <Widget>[
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   padding: EdgeInsets.only(
//                     top: 10,
//                     //left: 10,
//                     right: 10,
//                     bottom: 10,
//                   ),
//                   width: 130, //500,
//                   height: 130, //350,
//                   child: FittedBox(
//                     child: Container(
//                       width: 100, //500,
//                       height: 100,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(5.0),
//                         child: CachedNetworkImage(
//                           fit: BoxFit.cover,
//                           imageUrl: dataHerb[i]['herbalPic'],
//                           placeholder: (context, i) {
//                             return Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child:
//                                   Image.asset("assets/images/logo_ts_red.png"),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                     margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
//                     width: 120, //500,
//                     height: 120,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Container(
//                           width: 120,
//                           child: Text(dataHerb[i]['herbalName'],
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headline1
//                                   .copyWith(
//                                       fontSize: 12.5,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w500)),
//                         ),
//                         SizedBox(height: 8),
//                         // Container(
//                         //   child: Row(
//                         //     crossAxisAlignment: CrossAxisAlignment.start,
//                         //     children: <Widget>[
//                         //       Expanded(
//                         //         child: Text(
//                         //           dataHerb[i]['herbalTime'],
//                         //           maxLines: 2,
//                         //           overflow: TextOverflow.ellipsis,
//                         //           style: Theme.of(context)
//                         //               .textTheme
//                         //               .bodyText2
//                         //               .copyWith(
//                         //               color: Colors.black, fontSize: 11),
//                         //         ),
//                         //       ),
//                         //     ],
//                         //   ),
//                         // ),
//                         //SizedBox(height: 8),
//                         Container(
//                           child: Container(
//                             padding: EdgeInsets.all(4),
//                             decoration: BoxDecoration(
//                               color: dataHerb[i]['herbalStatus'] == "Tersedia"
//                                   ? Colors.green
//                                   : Colors.red,
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: Text(dataHerb[i]['herbalStatus'],
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .headline1
//                                     .copyWith(
//                                         fontSize: 10,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w500)),
//                           ),
//                         ),
//                       ],
//                     )),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

  Widget displayKabarDuka(BuildContext context, List dataKabarduka) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(ScreenUtil().setSp(10)),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: 16.0, right: 16.0, top: 16.0, bottom: 0.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.idCardAlt,
                            size: 19, color: Colors.black),
                        SizedBox(width: 6),
                        Row(
                          children: [
                            Text(
                              " Berita Duka",
                              style: GoogleFonts.roboto(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              " 讣告",
                              style: GoogleFonts.roboto(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap:
                        // () {
                        //   print("list kabarduka");
                        // },
                        () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => KabarDuka(),
                        settings: RouteSettings(name: "Berita Duka"),
                      ));
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
            height: 160.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dataKabarduka == null ? 0 : dataKabarduka.length,
                itemBuilder: (context, i) {
                  return new Container(
                    child: new Row(
                      children: <Widget>[
                        i == 0 ? SizedBox(width: 2.0) : SizedBox(),
                        kabarDukaCard(context, i, dataKabarduka),
                        //SizedBox(width: 16.0),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget kabarDukaCard(BuildContext context, int i, List dataKabarduka) {
    return InkWell(
      onTap:
          // () {},
          () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => KabarDukaDetail(
            kabardukaId: dataKabarduka[i]["kabardukaId"].toString(),
            kabardukaNama: dataKabarduka[i]["kabardukaName"].toString() +
                " (" +
                dataKabarduka[i]["kabardukaUmur"].toString() +
                " Tahun" +
                ")",
            //     " (" +
            //     _dataKabardukaList[i]["kabardukaUmur"].toString() +
            //     " Tahun)"
          ),
          settings: RouteSettings(name: "Detail Berita Duka"),
        ));
      },
      child: Container(
        margin: EdgeInsets.only(
          left: i == 0 ? 10 : 0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  width: 130, //500,
                  height: 130, //350,
                  child: FittedBox(
                    child: Container(
                      width: 100, //500,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: dataKabarduka[i]['kabardukaThumUrl'],
                          placeholder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child:
                                  Image.asset("assets/images/logo_ts_red.png"),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(
                        top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
                    width: 120, //500,
                    height: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  dataKabarduka[i]['kabardukaName'] +
                                      " (" +
                                      dataKabarduka[i]['kabardukaUmur']
                                          .toString() +
                                      " Tahun)",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          color: Colors.black,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 120,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.calendar_today, size: 15),
                              SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                    dataKabarduka[i]['kabardukaMeninggalDate']
                                        .toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .copyWith(
                                            fontSize: 11,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                            width: 300,
                            margin: EdgeInsets.only(left: 0.0, bottom: 0.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.calendar_today_outlined, size: 15),
                                SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    dataKabarduka[i]['kabardukaJenis'] +
                                        "-" +
                                        dataKabarduka[i]
                                                ['kabardukaAkhirDateTime']
                                            .toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(height: 4),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
