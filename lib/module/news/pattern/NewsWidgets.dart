import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/module/news/NewsDetail.dart';
import 'package:icati_app/utils/Carousel_Pro.dart';
import 'package:share/share.dart';

class NewsWidgets {
  Widget displayNewsList(BuildContext context, List dataNewsList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: dataNewsList == null ? 0 : dataNewsList.length,
      itemBuilder: (context, i) {
        return new Container(
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: 0.0, color: Colors.white)),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      NewsDetail(id: dataNewsList[i]["newsId"].toString()),
                  settings: RouteSettings(name: "Detail Berita"),
                ));
              },
              child: new Container(
                padding: new EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FittedBox(
                      child: Container(
                        width: 100, //500,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: dataNewsList[i]["newsPic"],
                            placeholder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                    "assets/images/logo_ts_red.png"),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 10.0),
                              child: Text(
                                dataNewsList[i]["newsTitle"],
                                style: GoogleFonts.roboto(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              margin: EdgeInsets.only(left: 10.0),
                              padding: EdgeInsets.all(2),
                              child: Text(
                                dataNewsList[i]["newsAddedOn"],
                                style: GoogleFonts.roboto(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget displayNewsPic(BuildContext context, List dataNews) {
    return GestureDetector(
      onTap: () {},
      child: new Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 10.0),
        padding: EdgeInsets.all(10.0),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 13.0),
                child: Text(
                  dataNews[0]['newsTitle'],
                  style: GoogleFonts.roboto(
                    textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  //textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(
                            //   child: Text(
                            //     dataNews[0]['kabupatenName'].toString(),
                            //     style: GoogleFonts.roboto(
                            //       textStyle:
                            //           Theme.of(context).textTheme.headline4,
                            //       fontSize: 12,
                            //       color: Colors.black,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //     //textAlign: TextAlign.justify,
                            //   ),
                            // ),
                            SizedBox(height: 4),
                            Text(
                              dataNews[0]['newsAddedDate'],
                              style: GoogleFonts.roboto(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // RaisedButton.icon(
                    //     onPressed: () => Share.share(dataNews[0]["newsShare"],
                    //         subject: dataNews[0]["newsTitle"]),
                    //     shape: RoundedRectangleBorder(
                    //         side: BorderSide(color: Colors.black),
                    //         borderRadius: BorderRadius.circular(3)
                    //     ),
                    //     icon: Image.asset("assets/images/icon_share.png", width: 15, height: 15),
                    //     color: Colors.white,
                    //     splashColor: Colors.grey,
                    //     label: Text(
                    //       "Share",
                    //       style: GoogleFonts.roboto(
                    //         textStyle: Theme.of(context).textTheme.headline4,
                    //         fontSize: 13,
                    //         color: Colors.black,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     )),
                  ],
                ),
              ),
              dataNews[0]['slider'].length > 0
                  ? Container(
                      // margin: EdgeInsets.only(
                      //     bottom: ScreenUtil().setSp(14),
                      //     top: isLogin ? 0 : ScreenUtil().setSp(10)),
                      child: AspectRatio(
                        aspectRatio: 1.5,
                        child: Carousel_Pro(
                          // boxFit: BoxFit.contain,
                          autoplay: true,
                          autoplayDuration: Duration(seconds: 3),
                          animationCurve: Curves.fastOutSlowIn,
                          animationDuration: Duration(milliseconds: 1000),
                          dotSize: 4,
                          dotSpacing: 16,
                          dotColor: Colors.white,
                          indicatorBgPadding: 15,
                          dotBgColor: Colors.transparent,
                          showIndicator: true,
                          images: dataNews[0]['slider'].map((pic) {
                            // print(pic);
                            return CachedNetworkImageProvider(
                              pic['newsSlide'],
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  : CachedNetworkImage(
                      fit: BoxFit.cover,
                      placeholder: (context, i) {
                        return Image.asset("assets/images/logo_ts_red.png");
                      },
                      imageUrl: dataNews[0]['newsPic'],
                    ),
            ]),
      ),
    );
  }

  Widget displayNewsContent(
      BuildContext context, List dataNews, int selectedPage) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dataNews == null ? 0 : dataNews.length,
              itemBuilder: (context, i) {
                return Column(
                  children: [
                    selectedPage == 0 &&
                            dataNews[i]["newsContent"][selectedPage]
                                    ["newsPage"] ==
                                selectedPage + 1
                        ? Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: HtmlWidget(
                              dataNews[i]["newsHeadline"],
                              textStyle: GoogleFonts.roboto(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        : Container(),
                    dataNews[i]["newsContent"][selectedPage]["newsPage"] ==
                            selectedPage + 1
                        ? Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            margin: EdgeInsets.only(top: 15),
                            child: HtmlWidget(
                              dataNews[i]["newsContent"][selectedPage]
                                  ["newsContent"],
                              textStyle: GoogleFonts.roboto(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        : Container(),
                    // ListView.builder(
                    //     shrinkWrap: true,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     itemCount: dataNews[i]["newsContent"] == null
                    //         ? 0
                    //         : dataNews[i]["newsContent"].length,
                    //     itemBuilder: (context, j) {
                    //       return Text((j + 1).toString());
                    //     }),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     ListView.builder(
                    //         shrinkWrap: true,
                    //         physics: const NeverScrollableScrollPhysics(),
                    //         itemCount: 3,
                    //         itemBuilder: (context, j) {
                    //           return Text(j.toString());
                    //         }),
                    //   ],
                    // )
                  ],
                );
              }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 16, bottom: 5),
                child: Text(
                  "Penulis: " + dataNews[0]['newsAuthor'].toString(),
                  style: GoogleFonts.roboto(
                    textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // SizedBox(height: 5),
              dataNews[0]['source'] != ""
                  ? Container(
                      padding: EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                        top: 0,
                      ),
                      child: Text(
                        "Sumber: " + dataNews[0]['source'].toString(),
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child:
                Divider(thickness: 2, color: Color.fromRGBO(186, 186, 186, 1)),
          ),
        ],
      ),
    );
  }

  Widget displayPagination(
      BuildContext context, Function onSelectPage, int selectedPage) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 0,
              itemBuilder: (context, i) {
                return null;
              }),
        ],
      ),
    );
  }

  Widget displayComment(BuildContext context, List dataComment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 15, bottom: 15, top: 30),
            child: dataComment == null
                ? Text(
                    "0 Komentar",
                    style: GoogleFonts.roboto(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                : Text(
                    dataComment.length.toString() + "  Komentar",
                    style: GoogleFonts.roboto(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  )),
        Container(
            margin: EdgeInsets.only(left: 0.0, right: 10.0, bottom: 20),
            child: (ListView.builder(
              padding: EdgeInsets.only(top: 8.0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: dataComment == null ? 0 : dataComment.length,
              itemBuilder: (context, i) {
                return Container(
                    margin: EdgeInsets.only(left: 15, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                                child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                  "assets/images/logo_ts_red.png",
                                  width: 50,
                                  height: 50),
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      dataComment[i]['cName'],
                                      style: GoogleFonts.roboto(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )),
                                SizedBox(height: 4),
                                Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      dataComment[i]['addedDate'],
                                      style: GoogleFonts.roboto(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )),
                                SizedBox(height: 10),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    dataComment[i]['cContent'],
                                    style: TextStyle(
                                        fontFamily: "roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ));
              },
            ))),
      ],
    );
  }

  Widget displaySendComment(
      BuildContext context,
      TextEditingController nameCont,
      TextEditingController emailCont,
      TextEditingController msgCont,
      formKey,
      bool _autoValidate,
      bool isSaving,
      Function submit,
      Function sendComment) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 10),
            child: Text("Tambahkan Komentar",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    fontFamily: "roboto",
                    color: Colors.black)),
          ),
          Form(
            key: formKey,
            // autovalidate: _autoValidate,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    controller: msgCont,
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Komentar tidak boleh kosong';
                      }
                      return null;
                    },
                    maxLines: null,
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 45.0, horizontal: 10.0),
                      fillColor: Color.fromRGBO(241, 241, 241, 1),
                      filled: true,
                      hintText: "Komentar",
                      hintStyle: TextStyle(
                        fontFamily: "roboto",
                        fontSize: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(241, 241, 241, 1),
                              width: 2)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(241, 241, 241, 1),
                              width:
                                  2)), //                        icon: Icon(Icons.email),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16, top: 16),
                        child: MaterialButton(
                          height: 45,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: !isSaving ? submit : null,
                          color: Color.fromRGBO(49, 48, 77, 1),
                          child: !isSaving
                              ? Text(
                                  'Kirim',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "roboto"),
                                )
                              : CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
