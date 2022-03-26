import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icati_app/module/login/Login.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
// import 'package:icati_app/base/BaseData.dart';
// import 'package:icati_app/module/menubar/MenuBar.dart';
// import 'package:icati_app/module/register/pattern/RegisterPresenter.dart';
// import 'package:icati_app/module/register/pattern/RegisterView.dart';
// import 'package:icati_app/module/register/pattern/RegisterWidgets.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SuccessRegister extends StatefulWidget {
  const SuccessRegister({key, String mEmail, String mPassword})
      : super(key: key);

  @override
  _SuccessRegisterState createState() => _SuccessRegisterState();
}

class _SuccessRegisterState extends State<SuccessRegister> {
  //   late RegisterPresenter _registerPresenter;
  // late SharedPreferences prefs;
  // final BaseData _baseData = BaseData(isLogin: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/images/icon_bg_login.jpg"),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              Image.asset(
                "assets/images/logo_icati.png",
                width: 100,
                height: 100,
                // color: Colors.red[700],
              ),
              // Image.asset(
              //   "assets/images/icon_success.png",
              //   width: 100,
              //   height: 100,
              //   color: Colors.red[700],
              // ),
              SizedBox(height: 10),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Akun Telah Berhasil Didaftarkan",
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(fontSize: 25, color: Colors.redAccent[800]),
                      textAlign: TextAlign.center)),
              SizedBox(height: 10),
              Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  child: Text(
                      "Data anda sudah berhasil didaftarkan di sistem kami. "
                      "Email verifikasi sudah terkirim. "
                      "Silahkan periksa email"
                      // " Silakan masuk menggunakan akun anda dengan "
                      "menekan tombol di bawah ini.",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Color(0XFF746C61), fontSize: 15),
                      textAlign: TextAlign.center)),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                                (Route<dynamic> predicate) => false);
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).buttonColor,
                              padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          child: Text("LANJUTKAN VERIFIKAI EMAIL",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  )),
            ],
          )),
    );
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}

@override
onFailCheckRegister(Map data) {
  // TODO: implement onFailCheckRegister
  throw UnimplementedError();
}

@override
onFailCity(Map data) {
  // TODO: implement onFailCity
  throw UnimplementedError();
}

@override
onFailLoginApple(Map data) {
  // TODO: implement onFailLoginApple
  throw UnimplementedError();
}

@override
onFailProvince(Map data) {
  // TODO: implement onFailProvince
  throw UnimplementedError();
}

@override
onFailRegister(Map data) {
  // TODO: implement onFailRegister
  throw UnimplementedError();
}

@override
onNetworkError() {
  // TODO: implement onNetworkError
  throw UnimplementedError();
}

@override
onSuccessCheckRegister(Map data) {
  // TODO: implement onSuccessCheckRegister
  throw UnimplementedError();
}

@override
onSuccessCity(Map data) {
  // TODO: implement onSuccessCity
  throw UnimplementedError();
}

@override
onSuccessLoginApple(Map data) {
  // TODO: implement onSuccessLoginApple
  throw UnimplementedError();
}

@override
onSuccessProvince(Map data) {
  // TODO: implement onSuccessProvince
  throw UnimplementedError();
}

@override
onSuccessRegister(Map data) {
  // TODO: implement onSuccessRegister
  throw UnimplementedError();
}
