import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/base/LoadingScreen.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/account/pattern/AccountPresenter.dart';
import 'package:icati_app/module/account/pattern/AccountView.dart';
import 'package:icati_app/module/account/pattern/AccountWidgets.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';

// ignore: must_be_immutable
class Account extends StatefulWidget {
  List dataComplete;

  Account({this.dataComplete});

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> implements AccountView {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  AccountPresenter _accountPresenter;
  List dataProfile, dataWaKeyword, dataCard;
  bool isLogin = false;
  Member _member = Member();
  String copiedText = "",
      noreferensi = "",
      urlReferensi = "",
      urlApp = "https://bit.ly/psmtiriauandroid",
      urlAppIos = "https://bit.ly/psmtiriauios",
      urlVideo = "https://www.youtube.com/watch?v=tdmgtPglxWM";

  @override
  void initState() {
    _accountPresenter = new AccountPresenter();
    _accountPresenter.attachView(this);
    super.initState();
    getCredential();
  }

  getCredential() async {
    if (!mounted) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
    if (isLogin == true) {
      if (prefs.containsKey("member")) {
        if (this.mounted) {
          setState(() {
            final member = prefs.getString("member");
            dataProfile = jsonDecode(member);
            print("ini data profile akun cache " + dataProfile.toString());

            _member.deviceId = prefs.getString("deviceid");
            _member.mId = dataProfile[0]['mId'].toString();
            noreferensi = dataProfile[0]['mIdReference'];
            urlReferensi = "https://icati.or.id/signup/$noreferensi";
            print("ini mid" + _member.mId.toString());
          });
        }
      }
      print(widget.dataComplete.toString());
      _accountPresenter.getMemberCardList();
      _accountPresenter.getWaKeyword(_member.mId);
      _accountPresenter.getProfile(_member.mId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: dataProfile != null
            ? Center(
                child: RefreshIndicator(
                  onRefresh: onRefresh,
                  color: Colors.black,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        dataProfile.isNotEmpty || dataProfile != null
                            ? AccountWidgets().displayMemberCard(
                                context,
                                dataCard,
                                displayQR,
                                dataProfile,
                                widget.dataComplete[0]['qr'].toString() ?? "",
                              )
                            : Container(),
                        dataProfile != null
                            ? AccountWidgets().displayMemberDetail(context,
                                dataProfile, _verifyEmail, widget.dataComplete)
                            : Container(),
                        widget.dataComplete == null
                            ? Container()
                            : widget.dataComplete[0]["profilebar"] == 100
                                ? Container()
                                : AccountWidgets().displayProfileBar(
                                    context, widget.dataComplete, dataProfile),
                        // dataProfile == null
                        //     ? Container()
                        //     : dataProfile[0]['mVA'].toString() == "0" ||
                        //             dataProfile[0]['mVA'].isEmpty
                        //         ? Container()
                        //         : AccountWidgets().displayVirtualAccount(
                        //             context, dataProfile),
                        AccountWidgets().editField(context, "Ajak Teman Anda",
                            shareText: _shareText),
                        AccountWidgets().editField(context, "Ubah Profil",
                            dataProfile: dataProfile, onRefresh: onRefresh),
                        AccountWidgets()
                            .editField(context, "Ubah Media Sosial"),
                        AccountWidgets().editField(context, "Ubah No HP"),
                        AccountWidgets().editField(context, "Ubah Email",
                            dataProfile: dataProfile, onRefresh: onRefresh),
                        AccountWidgets().editField(
                            context, "Ubah Nomor WhatsApp",
                            dataWaKeyword: dataWaKeyword),
                        AccountWidgets().editField(context, "Ubah Kata Sandi",
                            onRefresh: onRefresh, dataProfile: dataProfile),
                        AccountWidgets().editField(context, "Keluar",
                            confirmLogout: confirmLogout)
                      ],
                    ),
                  ),
                ),
              )
            : BaseView().displayLoadingScreen(context, color: Colors.black),
      ),
    );
  }

  Future<void> displayQR() async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Container(
              width: 250.0,
              margin: EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: Image(
                  fit: BoxFit.contain,
                  image: NetworkImage(widget.dataComplete[0]['qr'].toString()),
                ),
              ),
            ),
          ]),
        );
      },
    );
  }

  void _verifyEmail() async {
    _accountPresenter.resendVerifyEmail(_member.mId);
  }

  Future<Null> onRefresh() async {
    print("onrefresh akun");
    _accountPresenter.getMemberCardList();
    _accountPresenter.getProfile(_member.mId);
    _accountPresenter.getWaKeyword(_member.mId);
  }

  confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Container(
          color: Colors.black.withOpacity(0.6),
          child: AlertDialog(
            contentPadding: EdgeInsets.all(3),
            title: Text("Keluar Akun",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 18)),
            content: Padding(
              padding: const EdgeInsets.only(
                  top: 3, right: 16.0, left: 16, bottom: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Apakah Anda yakin ingin keluar ? ",
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(fontWeight: FontWeight.w300)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: ScreenUtil().setSp(35),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                padding: EdgeInsets.all(ScreenUtil().setSp(5)),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "BATAL",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          height: ScreenUtil().setSp(35),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).buttonColor,
                                padding: EdgeInsets.all(ScreenUtil().setSp(5)),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onPressed: logout,
                            child: Text(
                              "YA",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                      fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _shareText() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://install.icati.or.id/signup',
      link: Uri.parse('https://install.icati.or.id/signup?ref=$noreferensi'),
      androidParameters: AndroidParameters(
        packageName: 'com.icati.icati_app',
        fallbackUrl: Uri.parse(
            "https://play.google.com/store/apps/details?id=com.icati.icati_app"),
//        minimumVersion: 48
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.icati.icati-app',
        appStoreId: '1491447616',
        fallbackUrl:
            Uri.parse("https://apps.apple.com/us/app/icati/id1491447616"),
//        minimumVersion: '1.0.2'
      ),
    );

    // ignore: await_only_futures
    print(parameters.uriPrefix.toString());
    final ShortDynamicLink shortDynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    // (await parameters.uriPrefix) as ShortDynamicLink;
    final Uri shortUrl = shortDynamicLink.shortUrl;
    print("Uri shortUrl dynamiclink: ...");
    print(shortUrl);
    final Uri dynamicUrl = await parameters.link;
    print("Uri dynamicUrl:...");
    print(dynamicUrl);
    try {
      Share.share(
        "*Halo!*\nYuk, Bergabung di ICATI.\n" +
            // urlVideo +
            " \n\nSilakan *daftar online* melalui aplikasi Android atau iOS di"
                "\n$shortUrl\n\n" +
            "##########\n"
                "*GRATIS* dan *tanpa* iuran bulanan!\nAda banyak keuntungan memiliki kartu virtual ICATI termasuk *diskon spesial* di merchant terdaftar!",
        subject: "Ajak Teman Anda",
      );
    } catch (e) {
      print('error: $e');
    }
  }

  void logout() async {
    try {
      Navigator.pop(context);
      LoadingScreen.showLoadingDialog(context, _keyLoader);
      _accountPresenter.logout(_member.mId, _member.deviceId);
      print("log out");
      print(_member.mId.toString());
      print(_member.deviceId.toString());
      OneSignal.shared.deleteTags(["mId", "deviceId"]).then((value) {});
    } catch (e) {
      print("error logout");
    }
  }

  @override
  onFailProfile(Map data) {
    if (this.mounted) {
      setState(() {
        _accountPresenter.logout(_member.mId, _member.deviceId);
      });
    }
  }

  @override
  onSuccessProfile(Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        dataProfile = data['message'];
        prefs.setString("member", jsonEncode(dataProfile));
        print("ini data profile api " + dataProfile.toString());
      });
    }
  }

  @override
  onFailLogout(Map data) {
    if (this.mounted) {
      setState(() {
        BaseFunction().displayToast(data['errorMessage']);
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      });
    }
  }

  @override
  onSuccessLogout(Map data) async {
    if (this.mounted) {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      // var facebookLogin = new FacebookLogin();
      // facebookLogin.logOut();
      FacebookAuth.instance.logOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("IS_LOGIN", false);
      prefs.remove('member');
      // setState(() {
      //   setState(() {
      //     Hive.close();
      //     Hive.deleteFromDisk();
      //   });
      // });
      await _auth.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MenuBar(currentPage: 0)),
        (Route<dynamic> predicate) => false,
      );
    }
  }

  @override
  onNetworkError() {}

  @override
  onSuccessWaKeyword(Map data) {
    if (this.mounted) {
      setState(() {
        dataWaKeyword = data['message'];
      });
    }
  }

  @override
  onSuccessMemberCard(Map data) {
    if (this.mounted) {
      setState(() {
        dataCard = data['message'];
      });
    }
  }

  @override
  onFailMemberCard(Map data) {}

  @override
  onFailResendVerifyEmail(Map data) {
    if (this.mounted) {
      BaseFunction().displayToastLong(data['errorMessage']);
    }
  }

  @override
  onSuccessResendVerifyEmail(Map data) {
    if (this.mounted) {
      BaseFunction().displayToastLong(data['message']);
    }
  }
}
