import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/module/account/edit_email/EditEmail.dart';
import 'package:icati_app/module/account/edit_hp/EditHp.dart';
import 'package:icati_app/module/account/edit_password/EditSetPass.dart';
import 'package:icati_app/module/account/edit_profile/EditProfile.dart';
import 'package:icati_app/module/account/edit_sosmed/EditSosMed.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

class AccountWidgets {
  Widget displayMemberDetail(BuildContext context, dataProfile,
      Function verifyEmail, List dataComplete) {
    String hp = "";
    String wa = "";
    if (dataProfile != null) {
      String mHP = dataProfile[0]['mHp'].toString();
      String mWA = dataProfile[0]['mWA'].toString();
      hp = mHP.isNotEmpty
          ? mHP.substring(0, 2) == "62"
              ? "0" + mHP.substring(2, mHP.length)
              : mHP
          : "";
      wa = mWA.isNotEmpty
          ? mWA.substring(0, 2) == "62"
              ? "0" + mWA.substring(2, mWA.length)
              : mWA
          : "";
    }
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          elevation: 5.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(16.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditProfile(dataProfile),
                            settings: RouteSettings(name: "Ubah Profil")));
                      },
                      child: dataProfile != null
                          ? dataProfile[0]['mPic'].toString().isEmpty ||
                                  dataProfile[0]['mPic'].toString() == null
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: CircleAvatar(
                                    radius: 38,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                        "http://icati.or.id/assets/images/account_picture_default.png"),
                                    child: Container(
                                      margin: EdgeInsets.only(top: 40),
                                      child: Icon(Icons.add_circle,
                                          color: Colors.black),
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(dataProfile[0]
                                          ['urlSource'] +
                                      dataProfile[0]['mDir'] +
                                      "/" +
                                      dataProfile[0]['mPic']),
                                )
                          : Container(),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              dataProfile[0]['mName'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          dataProfile[0]['mEmail'].isNotEmpty
                              ? Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          dataProfile[0]['mEmail'],
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.grey),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 4.0),
                                      child: dataProfile[0]['mEmailStatus'] ==
                                              'y'
                                          ? Container(
                                              child: Icon(Icons.verified_user,
                                                  color: Colors.green,
                                                  size: 15.0),
                                            )
                                          : Container(
                                              child: Icon(Icons.cancel,
                                                  color: Colors.red,
                                                  size: 15.0),
                                            ),
                                    )
                                  ],
                                )
                              : Container(),
                          dataProfile[0]['mEmail'].isNotEmpty &&
                                  dataProfile[0]['mEmailStatus'] == 'n'
                              ? InkWell(
                                  onTap: () {
                                    verifyEmail();
                                  },
                                  child: Text(
                                    'Kirim Email Verifikasi',
                                    style: GoogleFonts.roboto(
                                        fontSize: 12, color: Colors.green),
                                  ),
                                )
                              : Container(),
                          //dataProfile == null
                          hp.isNotEmpty
                              ? Row(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 8.0, right: 8.0),
                                      child: Icon(
                                        Icons.phone_android_rounded,
                                        size: 13,
                                      ),
                                      width: 13,
                                      height: 13,
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(top: 8.0),
                                        child: Text(hp,
                                            style: GoogleFonts.roboto(
                                                fontSize: 12))),
                                  ],
                                )
                              : Container(),
                          wa.isNotEmpty
                              ? Row(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 8.0, right: 8.0),
                                      child: Icon(FontAwesomeIcons.whatsapp,
                                          size: 13),
                                      width: 13,
                                      height: 13,
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(top: 8.0),
                                        child: Text(wa,
                                            style: GoogleFonts.roboto(
                                                fontSize: 12))),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget editField(BuildContext context, String title,
      {Function confirmLogout,
      List dataProfile,
      Function onRefresh,
      dataWaKeyword,
      Function shareText}) {
    return InkWell(
      onTap: () {
        switch (title) {
          case "Ajak Teman Anda":
            // () => null;
            shareText();
            break;
          case "Ubah Profil":
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => EditProfile(dataProfile),
                    settings: RouteSettings(name: "Ubah Profil")))
                .then((value) => onRefresh());
            break;
          case "Ubah Email":
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => EditEmail(dataProfile[0]['mEmail']),
                    settings: RouteSettings(name: 'Ubah Email')))
                .then((value) => onRefresh());
            break;
          case "Ubah No HP":
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditHp(),
                settings: RouteSettings(name: "Edit No HP")));
            break;
          case "Ubah Nomor WhatsApp":
            if (dataWaKeyword != null) {
              print("masuk");
              BaseFunction().sendWhatsApp(
                  dataWaKeyword[0]['wa'], dataWaKeyword[0]['keyword']);
            }
            break;
          case "Ubah Kata Sandi":
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) =>
                        EditSetPass(dataProfile[0]['mPassword']),
                    settings: RouteSettings(name: "Ubah Profil")))
                .then((value) => onRefresh());
            break;
          case "Ubah Media Sosial":
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditSosMed(),
                settings: RouteSettings(name: "Ubah Media Sosial")));
            break;
          case "Keluar":
            confirmLogout(context);
            break;
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                    left: 3.0, right: 8.0, top: 15.0, bottom: 8.0),
                child: Row(
                  children: <Widget>[
                    // title == "Ajak Teman Anda"?
                    // Text(
                    //   title,
                    //   style: GoogleFonts.roboto(
                    //       fontWeight:
                    //           title == "Ajak Teman Anda" ? FontWeight.bold : null,
                    //       color: title == "Ajak Teman Anda" ? Colors.green : Colors.black),
                    // )
                    // :Container(),
                    title == "Ajak Teman Anda"
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.person_add,
                              size: 20,
                              color: Colors.yellow[700],
                            ))
                        : Container(),
                    title == "Ubah Nomor WhatsApp"
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(FontAwesomeIcons.whatsapp, size: 15))
                        : Container(),
                    title == "Ubah Profil"
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.person, size: 15))
                        : Container(),
                    title == "Ubah Email"
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(FontAwesomeIcons.envelope, size: 15))
                        : Container(),
                    title == "Ubah No HP"
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.phone_android_rounded, size: 15))
                        : Container(),
                    title == "Ubah Kata Sandi"
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.lock, size: 15))
                        : Container(),
                    title == "Ubah Media Sosial"
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(FontAwesomeIcons.globeAsia, size: 15))
                        : Container(),
                    Text(
                      title,
                      style: GoogleFonts.roboto(
                          fontSize: title == "Ajak Teman Anda" ? 15 : 13,
                          fontWeight:
                              title == "Keluar" || title == "Ajak Teman Anda"
                                  ? FontWeight.bold
                                  : null,
                          color: title == "Keluar"
                              ? Colors.red
                              : title == "Ajak Teman Anda"
                                  ? Colors.green[500]
                                  : Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            title != "Keluar"
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16.0,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  displayMemberCard(BuildContext context, List dataCard, Function displayQR,
      List dataProfile, String qrURL) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    return dataCard == null
        ? Container(
            margin: const EdgeInsets.all(16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(height: 205, color: Colors.white)),
            ),
          )
        : InkWell(
            onDoubleTap: () {
              displayQR();
            },
            child: Container(
              margin: EdgeInsets.only(top: ScreenUtil().setSp(16)),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.network(
                          dataCard[0]['cardurl'].toString(),
                          scale: 0.1,
                          fit: BoxFit.contain,
                          // placeholder: (context, i) {
                          //   return Container();
                          // },
                        )),
                  ),
                  Positioned(
                    left: shortestSide > 500 ? 60 : 40,
                    bottom: shortestSide > 500 ? 50 : 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        dataCard == null
                            ? Container()
                            : Text(
                                dataProfile[0]['mName'],
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
                                dataProfile[0]['mIdReference'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12.5,
                                  color: Colors.white,
                                ),
                              ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: shortestSide > 500 ? 60 : 40,
                    bottom: shortestSide > 500 ? 45 : 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        dataCard == null
                            ? Container()
                            : Container(
                                // decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                                width: 50.0,
                                child: Image(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(qrURL),
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Widget displayProfileBar(
      BuildContext context, List dataComplete, List dataProfile) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                dataComplete[0]["profilebar"] == 100
                    ? Container()
                    : InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditProfile(dataProfile),
                              settings: RouteSettings(name: "Ubah Profil")));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 5, right: 5, top: 10),
                          child: Column(
                            children: [
                              Text(
                                "Data Anda belum lengkap! Yuk lengkapi!",
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              SizedBox(height: 10),
                              LinearPercentIndicator(
                                //width: MediaQuery.of(context).size.width - 66,
                                animation: true,
                                lineHeight: 20.0,
                                animationDuration: 2000,
                                center: Text(
                                  dataComplete[0]["profilebar"].toString() +
                                      "%",
                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                percent: dataComplete[0]["profilebar"] / 100,
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                progressColor: Colors.lightBlueAccent,
                              ),
                            ],
                          ),
                        ),
                      ),
                SizedBox(height: 8)
              ],
            ),
          ),
        ),
      ),
    );
  }

  displayVirtualAccount(BuildContext context, List dataProfile) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            SizedBox(height: 8),
            dataProfile[0]['mVA'].toString() == "0" ||
                    dataProfile[0]['mVA'].isEmpty
                ? Container()
                : Container(
                    margin: EdgeInsets.only(left: 16, bottom: 16, right: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Virtual Account BCA",
                            style: GoogleFonts.roboto(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(dataProfile[0]['mVA'].toString(),
                                  style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ),
                            InkWell(
                              onTap: () {
                                FlutterClipboard.copy(
                                        dataProfile[0]['mVA'].toString())
                                    .then((value) {
                                  BaseFunction().displayToastLong("Copied");
                                });
                              },
                              child: Container(
                                  child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.copy,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 4),
                                  Text("SALIN",
                                      style: GoogleFonts.roboto(
                                          color: Colors.red,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ]),
        ),
      ),
    );
  }
}
