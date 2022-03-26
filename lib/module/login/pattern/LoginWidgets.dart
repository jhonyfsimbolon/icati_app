import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/module/login/login_otp_email/LoginOtpEmail.dart';
import 'package:icati_app/module/login/login_otp_sms/LoginSMS.dart';
import 'package:icati_app/module/login/login_otp_wa/LoginOtpWa.dart';
import 'package:icati_app/module/register/Register.dart';
import 'package:icati_app/module/register/RegisterOption.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginWidgets {
  Widget displayLoginEmailHpWa(
      BuildContext context,
      TextEditingController _emailHpWaCont,
      FocusNode _emailHpWaNode,
      FocusNode _passwordNode) {
    return FormField(
      validator: (value) {
        if (_emailHpWaCont.text.isEmpty) {
          return 'Kolom wajib diisi';
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
                  boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
              child: TextFormField(
                  controller: _emailHpWaCont,
                  focusNode: _emailHpWaNode,
                  textInputAction: TextInputAction.next,
                  style: Theme.of(context).textTheme.bodyText2,
                  onFieldSubmitted: (term) {
                    _emailHpWaNode.unfocus();
                    FocusScope.of(context).requestFocus(_passwordNode);
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: ScreenUtil().setSp(10),
                          horizontal: ScreenUtil().setSp(10)),
                      prefixIcon:
                          Icon(Icons.person, size: ScreenUtil().setSp(20)),
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).focusColor)),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      labelText: "Email/Hp/WhatsApp",
                      labelStyle: GoogleFonts.roboto(
                          fontSize: ScreenUtil().setSp(12)))),
            ),
            state.errorText != null
                ? Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setSp(3)),
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
    );
  }

  Widget displayLoginPassword(
      BuildContext context,
      TextEditingController _passwordCont,
      FocusNode _passwordNode,
      bool _passwordVisible,
      Function _passwordVisibility) {
    return FormField(
      validator: (value) {
        if (_passwordCont.text.isEmpty) {
          return 'Kolom wajib diisi';
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
                  boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
              child: TextFormField(
                controller: _passwordCont,
                focusNode: _passwordNode,
                obscureText: !_passwordVisible,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.symmetric(
                      vertical: ScreenUtil().setSp(10),
                      horizontal: ScreenUtil().setSp(10)),
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(
                    Icons.lock,
                    size: ScreenUtil().setSp(20),
                  ),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).focusColor)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  labelText: "Kata Sandi",
                  labelStyle:
                      GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: ScreenUtil().setSp(20),
                    ),
                    onPressed: () {
                      _passwordVisibility();
                    },
                  ),
                ),
              ),
            ),
            state.errorText != null
                ? Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setSp(3)),
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
    );
  }

  Widget displayLoginDivider(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(10)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(10)),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text(text,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Colors.black45, letterSpacing: 0.5)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(10)),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget displayLoginByAccount(BuildContext context, Function _logInByGoogle,
      Function _logInByFb, Function _logInByApple, Function _logInByTwitter) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _logInByGoogle,
              child: Material(
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setSp(6.5)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.google,
                          size: ScreenUtil().setSp(12), color: Colors.white),
                      SizedBox(width: ScreenUtil().setSp(5)),
                      Text("Google",
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Colors.white))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: ScreenUtil().setSp(8)),
            GestureDetector(
              onTap: _logInByFb,
              child: Material(
                color: Color(0xFF3B5998),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setSp(6.5)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.facebookF,
                          size: ScreenUtil().setSp(12), color: Colors.white),
                      SizedBox(width: ScreenUtil().setSp(5)),
                      Text("Facebook",
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Colors.white))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: ScreenUtil().setSp(8)),
            GestureDetector(
              onTap: _logInByTwitter,
              child: Material(
                color: Color(0xFF1DA1F2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setSp(6.5)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.twitter,
                          size: ScreenUtil().setSp(12), color: Colors.white),
                      SizedBox(width: ScreenUtil().setSp(5)),
                      Text("Twitter",
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Colors.white))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ScreenUtil().setSp(10)),
        Platform.isIOS
            ? Container(
                width: MediaQuery.of(context).size.width -
                    ScreenUtil().setWidth(112.w),
                child: SignInWithAppleButton(
                    onPressed: () {},
                    // _logInByApple,
                    height: ScreenUtil().setSp(35),
                    borderRadius: BorderRadius.circular(10)),
              )
            : SizedBox()
      ],
    );
  }

  Widget displayLoginByOtp(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoginOtpEmail("sendOtpEmail"),
              settings: RouteSettings(name: "Login Otp Email"),
            ));
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(ScreenUtil().setSp(5)),
            child: Row(
              children: [
                Container(
                    width: ScreenUtil().setSp(20),
                    height: ScreenUtil().setSp(20),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0XFFd44337)),
                    child: Icon(FontAwesomeIcons.envelope,
                        size: 10, color: Colors.white)),
                SizedBox(width: ScreenUtil().setSp(3)),
                Text("Email", style: Theme.of(context).textTheme.bodyText2)
              ],
            ),
          ),
        ),
        SizedBox(width: ScreenUtil().setSp(8)),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoginSMS(),
              settings: RouteSettings(name: "Login SMS"),
            ));
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(ScreenUtil().setSp(5)),
            child: Row(
              children: [
                Container(
                    width: ScreenUtil().setSp(20),
                    height: ScreenUtil().setSp(20),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0XFF969696)),
                    child: Icon(FontAwesomeIcons.sms,
                        size: 10, color: Colors.white)),
                SizedBox(width: ScreenUtil().setSp(3)),
                Text("SMS", style: Theme.of(context).textTheme.bodyText2)
              ],
            ),
          ),
        ),
        SizedBox(width: ScreenUtil().setSp(8)),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoginOtpWa("sendOtpWa"),
              settings: RouteSettings(name: "Login Otp Wa"),
            ));
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(ScreenUtil().setSp(5)),
            child: Row(
              children: [
                Container(
                    width: ScreenUtil().setSp(20),
                    height: ScreenUtil().setSp(20),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.green),
                    child: Icon(FontAwesomeIcons.whatsapp,
                        size: 10, color: Colors.white)),
                SizedBox(width: ScreenUtil().setSp(3)),
                Text("WhatsApp", style: Theme.of(context).textTheme.bodyText2)
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget displayRegister(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: "Akun Belum Terdaftar? ",
              style: Theme.of(context).textTheme.bodyText2,
              recognizer: TapGestureRecognizer()..onTap = () {}),
          TextSpan(
              text: " Daftar Sekarang",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
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
                }),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
