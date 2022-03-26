import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
import 'package:icati_app/module/verifydata/verify_wa/pattern/VerifyWaPresenter.dart';
import 'package:icati_app/module/verifydata/verify_wa/pattern/VerifyWaView.dart';

class VerifyWa extends StatefulWidget {
  @override
  _VerifyWaAppState createState() => _VerifyWaAppState();
}

class _VerifyWaAppState extends State<VerifyWa>
    with WidgetsBindingObserver
    implements VerifyWaView {
  VerifyWaPresenter _verifyWaPresenter;

  List _dataWaKeyword;
  BaseData _baseData = BaseData(isLogin: false);
  Member _member = Member();

  @override
  void initState() {
    _verifyWaPresenter = VerifyWaPresenter();
    _verifyWaPresenter.attachView(this);
    _getCredential();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("masuk sini");
    print(state.toString());
    if (state == AppLifecycleState.resumed) {
      print("APP IS RESUMED 1");
      if (_baseData.isLogin == true) {
        _verifyWaPresenter.checkWaExist(_member.mId);
      }
    }
  }

  void _getCredential() async {
    if (!mounted) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _baseData.isLogin =
        prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
    if (_baseData.isLogin == true) {
      final member = prefs.getString("member");
      final List data = jsonDecode(member);
      print(data);
      if (this.mounted) {
        setState(() {
          _member.mId = data[0]['mId'].toString();
          print("ini mid" + _member.mId.toString());
        });
      }
      _verifyWaPresenter.getWaKeyword(_member.mId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          height: height,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(ScreenUtil().setSp(5)),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .08),
                      Center(
                        child: Image.asset("assets/images/icon_wa.png",
                            width: 70, height: 70),
                      ),
                      SizedBox(height: 30),
                      Column(
                        children: [
                          Text("VERIFIKASI NOMOR WHATSAPP",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(letterSpacing: 1)),
                          SizedBox(height: 10),
                          Text(
                            "Verifikasi nomor WhatsApp Anda tanpa mengubah kalimat di bawah ini",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(letterSpacing: 1),
                          ),
                          SizedBox(height: 20),
                          _dataWaKeyword != null
                              ? Padding(
                                  padding:
                                      EdgeInsets.all(ScreenUtil().setSp(10)),
                                  child: Wrap(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[350],
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        padding: const EdgeInsets.all(4),
                                        child: Text(
                                            _dataWaKeyword[0]['keyword'],
                                            style: GoogleFonts.sourceCodePro(),
                                            textAlign: TextAlign.justify),
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox(),
                          _dataWaKeyword != null
                              ? MaterialButton(
                                  minWidth: 200,
                                  onPressed: () {
                                    // print(_dataWaKeyword[0]['wa']);
                                    BaseFunction().sendWhatsApp(
                                        _dataWaKeyword[0]['wa'],
                                        _dataWaKeyword[0]['keyword']);
                                  },
                                  color: Color(0xff28A745),
                                  child: Wrap(
                                    spacing: 8,
                                    children: [
                                      Icon(FontAwesomeIcons.whatsapp,
                                          color: Colors.white, size: 15),
                                      Text("Klik Di Sini",
                                          style: GoogleFonts.roboto(
                                              color: Colors.white)),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Shimmer.fromColors(
                                    child: Container(
                                        width: 150,
                                        height: 35,
                                        color: Colors.grey),
                                    baseColor: Colors.grey,
                                    highlightColor: Colors.grey[100],
                                  ),
                                ),
                          MaterialButton(
                            minWidth: 200,
                            onPressed: () {
                              // print(_dataWaKeyword[0]['wa']);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MenuBar(currentPage: 0),
                                      settings: RouteSettings(name: 'Login')),
                                  (Route<dynamic> predicate) => false);
                            },
                            color: Colors.red[900],
                            child: Wrap(
                              spacing: 8,
                              children: [
                                // Icon(FontAwesomeIcons.whatsapp,
                                //     color: Colors.white, size: 15),
                                Text("Lewati",
                                    style: GoogleFonts.roboto(
                                        color: Colors.white)),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessWaKeyword(Map data) {
    if (this.mounted) {
      setState(() {
        _dataWaKeyword = data['message'];
      });
    }
  }

  @override
  onSuccessCheckWaExist(Map data) {
    if (this.mounted) {
      print("ini data message " + data['message'].toString());
      if (data['message'] == 'y') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => MenuBar(currentPage: 0),
                settings: RouteSettings(name: 'Login')),
            (Route<dynamic> predicate) => false);
      }
    }
  }
}
