import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/module/directory/DirectoryDetail.dart';
import 'package:icati_app/module/directory/DirectorySubCat.dart';

class DirectoryWidgets {
  Widget displayProvinceBox(BuildContext context, String _currentProvince,
      Function _selectProvince, List _dataProvince) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormField(
          validator: (value) {
            if (_currentProvince == null) {
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
                    items: _dataProvince != null
                        ? _dataProvince.map((item) {
                            return DropdownMenuItem(
                                value: item['provinsiId'].toString(),
                                child: Text(
                                  item['provinsiName'].toString(),
                                  style: Theme.of(context).textTheme.bodyText2,
                                ));
                          }).toList()
                        : null,
                    value: _currentProvince,
                    onChanged: _selectProvince,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: ScreenUtil().setSp(10),
                          horizontal: ScreenUtil().setSp(10)),
                      prefixIcon:
                          Icon(Icons.apartment, size: ScreenUtil().setSp(20)),
                      prefixText: _currentProvince == "0" ? "": "Prov: ",
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

Widget displayCityBox(BuildContext context, String _currentCity,
      Function _selectCity, List _dataCity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormField(
          validator: (value) {
            if (_currentCity == null) {
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
                    items: _dataCity != null
                        ? _dataCity.map((item) {
                            return DropdownMenuItem(
                                value: item['kabupatenId'].toString(),
                                child: Text(
                                  item['kabupatenName'].toString(),
                                  style: Theme.of(context).textTheme.bodyText2,
                                ));
                          }).toList()
                        : null,
                    value: _currentCity,
                    onChanged: _selectCity,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: ScreenUtil().setSp(10),
                          horizontal: ScreenUtil().setSp(10)),
                      prefixIcon:
                          Icon(Icons.apartment, size: ScreenUtil().setSp(20)),
                      prefixText: _currentCity == "0" ? "": "Kab: ",
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

  Widget displayPicture(BuildContext context, List dataDirectory) {
    return new Container(
        color: Colors.white,
        padding: new EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            FittedBox(
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: dataDirectory[0]['merchantPic'],
                    placeholder: (context, i) {
                      return Image.asset("assets/images/logo_ts_red.png");
                    },
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 15.0, bottom: 13.0),
                child: Text(
                  dataDirectory[0]['merchantName'],
                  //textAlign: TextAlign.justify,
                  style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            dataDirectory[0]['merchantType'].isEmpty
                ? Container()
                : Container(
                    margin: EdgeInsets.only(top: 0.0, bottom: 13.0),
                    child: Text(
                      dataDirectory[0]['merchantType'],
                      style: GoogleFonts.roboto(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54),
                    ),
                  ),
          ],
        ));
  }

  Widget displayInfo(BuildContext context, List dataDirectory) {
    var decor = BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Theme.of(context).dividerColor)));
    return GestureDetector(
        onTap: () {},
        child: new Container(
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 20.0, top: 10.0),
            padding: EdgeInsets.all(10.0),
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: dataDirectory[0]['merchantDiscountTerms'] ==
                                null ||
                            dataDirectory[0]['merchantDiscountTerms'].isEmpty
                        ? null
                        : decor,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              bottom: 20.0,
                              top: dataDirectory[0]['merchantDiscountTerms'] ==
                                          null ||
                                      dataDirectory[0]['merchantDiscountTerms']
                                          .isEmpty
                                  ? 0
                                  : 20.0),
                          child: dataDirectory[0]['merchantDiscount'] == ""
                              ? Container()
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: dataDirectory[0]['merchantDiscount']
                                              .toString() !=
                                          "0"
                                      ? Stack(
                                          children: <Widget>[
                                            new Container(
                                              height: 25,
                                              width: 70,
                                              decoration: new BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          16.0),
                                                  color:
                                                      Colors.deepOrange[400]),
                                            ),
                                            Positioned.fill(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Disc " +
                                                      dataDirectory[0]
                                                          ['merchantDiscount'] +
                                                      "%",
                                                  //textAlign: TextAlign.justify,
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontFamily: 'expressway',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ),
                        ),
                        dataDirectory[0]['merchantDiscountTerms'] == null ||
                                dataDirectory[0]['merchantDiscountTerms']
                                    .isEmpty
                            ? Container()
                            : Center(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      HtmlWidget(
                                        dataDirectory[0]
                                            ['merchantDiscountTerms'],
                                        textStyle: GoogleFonts.roboto(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  dataDirectory[0]['merchantDiscountTerms'] == null ||
                          dataDirectory[0]['merchantDiscountTerms'].isEmpty
                      ? Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 0),
                          child: Text(
                            "Contact",
                            //textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: 'expressway',
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 20),
                          child: Text(
                            "Contact",
                            //textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: 'expressway',
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 20.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context).dividerColor))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // link website
                          Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: dataDirectory[0]['merchantWeb'].isNotEmpty
                                  ? Row(
                                      children: <Widget>[
                                        new Icon(
                                          Icons.phonelink,
                                          size: 15.0,
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              if (!dataDirectory[0]
                                                      ['merchantWeb']
                                                  .contains("https://")) {
                                                BaseFunction().launchURL(
                                                    "https://" +
                                                        dataDirectory[0]
                                                            ['merchantWeb']);
                                              } else {
                                                BaseFunction().launchURL(
                                                    dataDirectory[0]
                                                        ['merchantWeb']);
                                              }
                                            },
                                            child: Text(
                                              dataDirectory[0]['merchantWeb']
                                                      .contains("http://")
                                                  ? "-"
                                                  : dataDirectory[0]
                                                      ['merchantWeb'],
                                              style: TextStyle(
                                                color: Colors.blue[700],
                                                fontFamily: 'expressway',
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container()),

                          //  email merchant
                          Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: dataDirectory[0]['merchantEmail']
                                      .isNotEmpty
                                  ? Row(
                                      children: <Widget>[
                                        new Icon(
                                          Icons.email,
                                          size: 15.0,
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              BaseFunction().launchMail(
                                                  dataDirectory[0]
                                                      ['merchantEmail']);
                                            },
                                            child: Text(
                                              dataDirectory[0]['merchantEmail'],
                                              style: TextStyle(
                                                color: Colors.blue[700],
                                                fontFamily: 'expressway',
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container()),

                          // merchant hp
                          Container(
                              margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
                              child: dataDirectory[0]['merchantHp'].isNotEmpty
                                  ? Row(
                                      children: <Widget>[
                                        new Icon(
                                          Icons.phone,
                                          size: 15.0,
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              BaseFunction().phoneCall(
                                                  dataDirectory[0]
                                                      ['merchantHp']);
                                            },
                                            child: Text(
                                              dataDirectory[0]['merchantHp'],
                                              style: TextStyle(
                                                color: Colors.blue[700],
                                                fontFamily: 'expressway',
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container()),
                          Container(
                            child: Text(
                              "Information",
                              //textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'expressway',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          Container(
                            child: Column(
                              children: <Widget>[
                                // jam operasi
                                Container(
                                    margin: EdgeInsets.only(
                                        top: 15.0, bottom: 10.0),
                                    child: dataDirectory[0]
                                                ['merchantOperational']
                                            .isNotEmpty
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 3.0),
                                                child: new Icon(
                                                  Icons.access_time,
                                                  size: 15.0,
                                                ),
                                              ),
                                              SizedBox(width: 10.0),
                                              Expanded(
                                                child: Text(
                                                  dataDirectory[0]
                                                      ['merchantOperational'],
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontFamily: 'expressway',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: <Widget>[
                                              new Icon(
                                                Icons.access_time,
                                                size: 15.0,
                                              ),
                                              SizedBox(width: 10.0),
                                              Expanded(
                                                child: Text(
                                                  "-",
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontFamily: 'expressway',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                              ],
                            ),
                          ),

                          // address
                          Container(
                            child: Column(
                              children: <Widget>[
                                // jam operasi
                                Container(
                                    margin:
                                        EdgeInsets.only(top: 0.0, bottom: 10.0),
                                    child: dataDirectory[0]['merchantAddress']
                                            .isNotEmpty
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 3.0),
                                                child: new Icon(
                                                  Icons.location_on,
                                                  size: 15.0,
                                                ),
                                              ),
                                              SizedBox(width: 10.0),
                                              Expanded(
                                                child: Text(
                                                  dataDirectory[0]
                                                      ['merchantAddress'],
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontFamily: 'expressway',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: <Widget>[
                                              new Icon(
                                                Icons.location_on,
                                                size: 15.0,
                                              ),
                                              SizedBox(width: 10.0),
                                              Expanded(
                                                child: Text(
                                                  "Alamat belum tersedia",
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontFamily: 'expressway',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                              ],
                            ),
                          ),

                          // city
                          Container(
                            child: Column(
                              children: <Widget>[
                                // jam operasi
                                Container(
                                    margin:
                                        EdgeInsets.only(top: 0.0, bottom: 20.0),
                                    child: dataDirectory[0]['kabupatenName']
                                                .isNotEmpty ||
                                            dataDirectory[0]['provinsiName']
                                                .isNotEmpty
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Icon(
                                                Icons.location_city,
                                                size: 15.0,
                                              ),
                                              SizedBox(width: 10.0),
                                              Expanded(
                                                child: Text(
                                                  dataDirectory[0]
                                                              ['kabupatenName']
                                                          .toString() +
                                                      ", " +
                                                      dataDirectory[0]
                                                              ['provinsiName']
                                                          .toString(),
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontFamily: 'expressway',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: <Widget>[
                                              new Icon(
                                                Icons.location_city,
                                                size: 15.0,
                                              ),
                                              SizedBox(width: 10.0),
                                              Expanded(
                                                child: Text(
                                                  "Wilayah belum tersedia",
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontFamily: 'expressway',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                              ],
                            ),
                          ),
                          displaySocialMedia(context, dataDirectory),
                        ]),
                  ),
                ])));
  }

  Widget displaySocialMedia(BuildContext context, List dataDirectory) {
    return GestureDetector(
      onTap: () {},
      child: new Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 20.0, bottom: 0.0),
        child:
            new Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Text(
                  "Sosial Media",
                  style: TextStyle(
                      fontSize: 13.0,
                      fontFamily: 'expressway',
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              width: 300,
              child: Row(
                children: <Widget>[
                  dataDirectory[0]['merchantFacebook'].isNotEmpty &&
                          dataDirectory[0]['merchantFacebook'] !=
                              'https://www.facebook.com/'
                      ? GestureDetector(
                          onTap: () {
                            BaseFunction().launchURL(
                                dataDirectory[0]['merchantFacebook']);
                          },
                          child: Container(
                              margin: const EdgeInsets.only(right: 20.0),
                              child: Tooltip(
                                  message: dataDirectory[0]['merchantFacebook'],
                                  child: Icon(FontAwesomeIcons.facebook,
                                      color: Color(0xff3b5998)))))
                      : Container(),
                  dataDirectory[0]['merchantTwitter'].isNotEmpty &&
                          dataDirectory[0]['merchantTwitter'] !=
                              'https://www.twitter.com/'
                      ? GestureDetector(
                          onTap: () {
                            BaseFunction()
                                .launchURL(dataDirectory[0]['merchantTwitter']);
                          },
                          child: Container(
                              margin: const EdgeInsets.only(right: 20.0),
                              child: Tooltip(
                                  message: dataDirectory[0]['merchantTwitter'],
                                  child: Icon(FontAwesomeIcons.twitter,
                                      color: Color(0xff1DA1F2)))))
                      : Container(),
                  dataDirectory[0]['merchantInstagram'].isNotEmpty &&
                          dataDirectory[0]['merchantInstagram'] !=
                              'https://www.instagram.com/'
                      ? GestureDetector(
                          onTap: () {
                            BaseFunction().launchURL(
                                dataDirectory[0]['merchantInstagram']);
                          },
                          child: Container(
                              margin: const EdgeInsets.only(right: 20.0),
                              child: Tooltip(
                                  message: dataDirectory[0]
                                      ['merchantInstagram'],
                                  child: Icon(FontAwesomeIcons.instagram))),
                        )
                      : Container(),
                  dataDirectory[0]['merchantYoutube'].isNotEmpty &&
                          dataDirectory[0]['merchantYoutube'] !=
                              'https://www.youtube.com/'
                      ? GestureDetector(
                          onTap: () {
                            BaseFunction()
                                .launchURL(dataDirectory[0]['merchantYoutube']);
                            print(dataDirectory[0]['merchantYoutube']);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 20.0),
                            child: Tooltip(
                              message: dataDirectory[0]['merchantYoutube'],
                              child: Icon(
                                FontAwesomeIcons.youtube,
                                color: Color(0xffff0000),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  dataDirectory[0]['merchantWa'].isNotEmpty &&
                          dataDirectory[0]['merchantWa'] !=
                              'https://www.youtube.com/'
                      ? GestureDetector(
                          onTap: () {
                            BaseFunction().sendWhatsApp(
                                dataDirectory[0]['merchantWa'], "Halo. ");
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 20.0),
                            child: Tooltip(
                              message: dataDirectory[0]['merchantWa'],
                              child: Icon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  dataDirectory[0]['merchantLine'].isNotEmpty &&
                          dataDirectory[0]['merchantLine'] !=
                              'https://www.youtube.com/'
                      ? GestureDetector(
                          onTap: () {
                            BaseFunction()
                                .launchURL(dataDirectory[0]['merchantLine']);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 20.0),
                            child: Tooltip(
                              message: dataDirectory[0]['merchantLine'],
                              child: Icon(
                                FontAwesomeIcons.line,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              )),
        ]),
      ),
    );
  }

  Widget displayDirectoryCategory(BuildContext context, String title, int catId,
      List dataDirectory, String currentProvince, String currentCity) {
    // List dataDirectoryNew = [];
    // if (currentCity != '0') {
    //   int index = 0;
    //   for (int idxDirectory = 0;
    //       idxDirectory < dataDirectory.length;
    //       idxDirectory++) {
    //     if (dataDirectory[idxDirectory]['provinsiId'].toString() !=
    //         currentCity) {
    //       // dataDirectoryNew[index] = dataDirectory[idxDirectory]['provinsiId'];
    //       dataDirectory.removeAt(index);
    //     } else {
    //       index++;
    //     }
    //   }
    // }
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 16.0),
      //padding: EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontFamily: 'expressway',
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                  textAlign: TextAlign.left,
                )),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DirectorySubCat(
                              catId: catId.toString(),
                              provinsiId: currentProvince??"0",
                              kabupatenId: currentCity??"0",
                            ),
                            settings:
                                RouteSettings(name: 'Direktori Sub Category'),
                          ),
                        );
                      },
                      child: Text(
                        "Lihat Semua",
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 16.0),
            height: 250.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dataDirectory == null ? 0 : dataDirectory.length,
                itemBuilder: (context, i) {
                  return new Container(
                    child: new Row(
                      children: <Widget>[
                        i == 0 ? SizedBox(width: 16.0) : SizedBox(),
                        directoryBox(
                          context,
                          i,
                          dataDirectory,
                        ),
                        SizedBox(width: 16.0),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget directoryBox(BuildContext context, int idx, List dataDirectory) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DirectoryDetail(
              id: dataDirectory[idx]['merchantId'].toString(),
            ),
            settings: RouteSettings(name: 'Direktori Detail'),
          ),
        );
      },
      child: Container(
        child: new FittedBox(
          child: Material(
            color: Colors.white,
            elevation: 0.0,
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
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl:
                                dataDirectory[idx]['merchantPic'].toString(),
                            placeholder: (context, i) {
                              return Image.asset(
                                  "assets/images/logo_ts_red.png");
                            },
                          ),
                        ),
                      ),
                    ),
                    dataDirectory[idx]['merchantDiscount'].toString() == ""
                        ? Container()
                        : Positioned(
                            top: 0,
                            right: 0,
                            child: dataDirectory[idx]['merchantDiscount']
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
                                              dataDirectory[idx]
                                                      ['merchantDiscount']
                                                  .toString() +
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
                      dataDirectory[idx]['merchantName'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'expressway',
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                      ),
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
                          child: Text(
                            dataDirectory[idx]['merchantAddress'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'expressway',
                              fontSize: 22.0,
                            ),
                          ),
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
                          child: Text(
                            dataDirectory[idx]['merchantHp'],
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'expressway',
                              fontSize: 22.0,
                            ),
                          ),
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
                            dataDirectory[idx]['merchantOperational']
                                .toString()==""?"-":dataDirectory[idx]['merchantOperational']
                                .toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'expressway',
                              fontSize: 22.0,
                            ),
                          ),
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

  Widget displaySubCatList(BuildContext context, List dataDirectory) {
    return ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: dataDirectory == null ? 0 : dataDirectory.length,
      itemBuilder: (context, i) {
        return new Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.all(5.0),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DirectoryDetail(
                      id: dataDirectory[i]["merchantId"].toString()),
                  settings: RouteSettings(name: "Direktori Detail"),
                ));
              },
              child: new Container(
                padding: new EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: [
                        FittedBox(
                          child: Container(
                            width: 100, //500,
                            height: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    dataDirectory[i]["merchantPic"].toString(),
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
                                            padding: const EdgeInsets.all(4.0),
                                            decoration: new BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        20.0),
                                                color: Colors.deepOrange[400]),
                                            child: Text(
                                              "Disc " +
                                                  dataDirectory[i]
                                                          ['merchantDiscount']
                                                      .toString() +
                                                  "%",
                                              //textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  fontSize: 10.0,
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 10.0),
                            child: Text(
                              dataDirectory[i]["merchantName"].toString(),
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
                              dataDirectory[i]["merchantAddress"].toString(),
                              style: GoogleFonts.roboto(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0),
                            padding: EdgeInsets.all(2),
                            child: Text(
                              dataDirectory[i]["merchantHp"].toString(),
                              style: GoogleFonts.roboto(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0),
                            padding: EdgeInsets.all(2),
                            child: Text(
                              dataDirectory[i]["merchantOperational"]
                                  .toString(),
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
