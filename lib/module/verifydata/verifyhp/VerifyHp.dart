import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/account/edit_profile/EditProfile.dart';
import 'package:icati_app/module/home/Home.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
import 'package:icati_app/module/verifydata/verify_member/VerifyMember.dart';
import 'package:icati_app/module/verifydata/verify_wa/VerifyWa.dart';
import 'package:icati_app/module/verifydata/verifyhp/pattern/VerifyHpPresenter.dart';
import 'package:icati_app/module/verifydata/verifyhp/pattern/VerifyHpView.dart';
import 'package:icati_app/module/verifydata/verifyhp/pattern/VerifyHpWidgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyHp extends StatefulWidget {
  List dataComplete, dataProfile;

  VerifyHp({this.dataComplete});

  @override
  _VerifyHpState createState() => _VerifyHpState();
}

class _VerifyHpState extends State<VerifyHp> implements VerifyHpView {
  VerifyHpPresenter _verifyHpPresenter;
  final GlobalKey<State> keyLoader = new GlobalKey<State>();
  static final _formKey = new GlobalKey<FormState>();

  TextEditingController hpCont = TextEditingController();
  final FocusNode hpNode = FocusNode();

  TextEditingController otpCont = TextEditingController();
  final FocusNode otpNode = FocusNode();
  StreamController<ErrorAnimationType> errorController;

  BaseData baseData = BaseData();
  Member member = Member();

  Duration count;
  Duration interval = Duration(seconds: 1);
  Timer timer;
  String verificationId = "", resendToken = "";

  @override
  void initState() {
    _verifyHpPresenter = new VerifyHpPresenter();
    _verifyHpPresenter.attachView(this);
    getCredential();
    //startCount();
    baseData.isSaving = false;
    baseData.isSavingResend = false;
    baseData.autoValidate = false;
    baseData.hpValidate = false;
    baseData.otpValidate = false;
    baseData.resendOTP = false;
    baseData.page = 1;
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startCount() async {
    setState(() {
      count = Duration(seconds: 30);
    });
    timer = Timer.periodic(interval, showCountDown);
  }

  void showCountDown(Timer timer) {
    if (this.mounted) {
      setState(() {
        if (count.inSeconds == 0) {
          timer.cancel();
          baseData.resendOTP = true;
        } else {
          count = Duration(seconds: count.inSeconds - 1);
        }
      });
    }
  }

  getCredential() async {
    if (!mounted) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    baseData.isLogin =
        prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
    if (baseData.isLogin) {
      setState(() {
        final user = prefs.getString("member");
        final List data = jsonDecode(user);
        widget.dataProfile = jsonDecode(user);
        member.mId = data[0]['mId'].toString();
        member.deviceId = prefs.getString("deviceid").toString();
      });
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
                        child: Image.asset(
                            baseData.page == 1
                                ? "assets/images/icon_hp.png"
                                : "assets/images/icon_otp.png",
                            width: 70,
                            height: 70),
                      ),
                      SizedBox(height: 30),
                      Column(
                        children: [
                          baseData.page == 1
                              ? Text("PENDAFTARAN NOMOR HANDPHONE",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(letterSpacing: 1))
                              : Text("VERIFIKASI NOMOR HANDPHONE",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(letterSpacing: 1)),
                          SizedBox(height: 10),
                          baseData.page == 1
                              ? Text(
                                  "Kami akan mengirim SMS verifikasi ke nomor handphone Anda",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(letterSpacing: 1))
                              : Text(
                                  "Kami telah mengirim SMS verifikasi \nke nomor handphone Anda",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(letterSpacing: 1))
                        ],
                      ),
                      SizedBox(height: 20),
                      baseData.page == 1
                          ? displayPhoneNumberInput()
                          : displayVerifyPhoneNumber()
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

  Widget displayPhoneNumberInput() {
    return Padding(
      padding: EdgeInsets.all(ScreenUtil().setSp(10)),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: <Widget>[
            VerifyHpWidgets().displayHpForm(context, hpCont),
            SizedBox(height: 20),
            displayButtonSubmit(),
          ],
        ),
      ),
    );
  }

  Widget displayVerifyPhoneNumber() {
    return Padding(
      padding: EdgeInsets.all(ScreenUtil().setSp(10)),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: <Widget>[
            VerifyHpWidgets()
                .displayOtpInput(context, otpCont, errorController),
            SizedBox(height: 20),
            displayButtonSubmit(),
            SizedBox(height: 20),
            displayResendOtp(),
          ],
        ),
      ),
    );
  }

  sendOTP() async {
    setState(() {
      //baseData.isSaving = true;
      FocusScope.of(context).requestFocus(FocusNode());
    });
    // if (_formKey.currentState.validate()) {
    //   _formKey.currentState.save();
    try {
      String phone;
      if (!hpCont.text.substring(0, 2).contains("62")) {
        phone = "62" + hpCont.text.substring(1);
      }
      print("no hp " + phone.toString());
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+$phone',
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            setState(() {
              baseData.isSaving = false;
            });
            BaseFunction().displayToastLong("Phone number is not valid");
          } else if (e.code == "app-not-authorized") {
            setState(() {
              baseData.isSaving = false;
            });
            BaseFunction().displayToastLong("App is not authorized");
          } else if (e.code == "web-context-cancelled") {
            setState(() {
              baseData.isSaving = false;
            });
            BaseFunction().displayToastLong("Cancelled");
          } else {
            setState(() {
              baseData.isSaving = false;
            });
            BaseFunction().displayToastLong("Gagal verifikasi");
          }
          print(e.code);
          print(e.message);
        },
        codeSent: (String verificationId, int resendToken) async {
          startCount();
          BaseFunction().displayToastLong("Kode OTP terkirim!");

          print("Code Sent");
          print("Verification Id: $verificationId}");
          print("Resend Token: $resendToken");
          if (this.mounted) {
            setState(() {
              baseData.page = 2;
              baseData.isSaving = false;
              this.verificationId = verificationId;
              this.resendToken = resendToken.toString();
            });
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Timeout!");
        },
      );
    } catch (e) {
      print(e);
      setState(() {
        baseData.isSaving = false;
      });
      BaseFunction().displayToastLong("Gagal mengirimkan kode OTP");
    }
    // } else {
    //   setState(() {
    //     baseData.isSaving = false;
    //     baseData.hpValidate = true;
    //   });
    //   BaseFunction().displayToastLong("Periksa kembali data Anda");
    // }
  }

  verifyOTP() async {
    if (this.mounted) {
      if (otpCont.text.length != 6) {
        errorController
            .add(ErrorAnimationType.shake); // Triggering error shake animation
      } else {
        try {
          print("cek verifikasi");
          print(this.verificationId);
          print(otpCont.text);
          setState(() {
            baseData.isSaving = true;
          });
          final AuthCredential credential = PhoneAuthProvider.credential(
            verificationId: this.verificationId,
            smsCode: otpCont.text,
          );
//          final User user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
          await FirebaseAuth.instance.signInWithCredential(credential);
          _verifyHpPresenter.phoneVerification(
              member.mId.toString(), hpCont.text);
        } on FirebaseAuthException catch (e) {
          print(e);
          switch (e.code) {
            case "invalid-verification-code":
              otpCont.clear();
              otpNode.requestFocus();
              setState(() {
                baseData.isSaving = false;
              });
              BaseFunction().displayToastLong("Kode verifikasi salah");
              break;
            default:
              setState(() {
                baseData.isSaving = false;
              });
              BaseFunction().displayToastLong("Verifikasi gagal");
              break;
          }
        }
      }
    }
  }

  sendHP() async {
    setState(() {
      baseData.isSaving = true;
      FocusScope.of(context).requestFocus(FocusNode());
    });
    if (_formKey.currentState.validate() && otpCont.text != "") {
      _formKey.currentState.save();
      verifyOTP();
    } else {
      setState(() {
        baseData.isSaving = false;
        baseData.autoValidate = true;
      });
    }
  }

  Widget displayResendOtp() {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            onPressed: !baseData.resendOTP
                ? () {}
                : () {
                    if (this.mounted) {
                      setState(() {
                        baseData.resendOTP = false;
                      });
                    }
                    sendOTP();
                    startCount();
                  },
            style: ElevatedButton.styleFrom(
                primary: baseData.resendOTP == true
                    ? Color(0XFFFFD700)
                    : Color(0XFFFFD700).withOpacity(0.5),
                padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            child: baseData.resendOTP == true
                ? Text("Kirim Ulang OTP",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.black,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500))
                : Text(
                    "Kirim Ulang OTP dalam" +
                        ' (${count.inSeconds}' +
                        " detik)",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.black45,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500)),
          ),
        ),
      ],
    );
  }

  Widget displayButtonSubmit() {
    return !baseData.isSaving
        ? Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (baseData.page == 1) {
                      if (this.mounted) {
                        setState(() {
                          baseData.isSaving = true;
                        });
                        if (_formKey.currentState.validate()) {
                          _verifyHpPresenter.checkPhone(
                              member.mId, hpCont.text);
                        } else {
                          baseData.isSaving = false;
                        }
                      }
                    } else {
                      sendHP();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).buttonColor,
                      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: Text(
                      baseData.page == 1
                          ? "KIRIM SMS VERIFIKASI"
                          : "VERIFIKASI KODE OTP",
                      style: Theme.of(context).textTheme.button),
                ),
              ),
            ],
          )
        : BaseView().displayLoadingScreen(context,
            color: Theme.of(context).buttonColor);
  }

  @override
  onNetworkError() {
    BaseFunction()
        .displayToastLong("Connection failed, please try again later");
  }

  @override
  onSuccessPhoneVerification(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isSaving = false;
        if (widget.dataComplete[0]['dataRequireComplete'] == 'n') {
          Navigator.pushAndRemoveUntil(
              context,
              // MaterialPageRoute(
              //     builder: (context) => EditProfile(widget.dataProfile),
              //     settings: RouteSettings(name: 'edit profile')),
              MaterialPageRoute(
                  // builder: (context) => Home(dataComplete: widget.dataComplete),
                  // settings: RouteSettings(name: 'Lengkapi Data Diri')),
                  builder: (context) => VerifyWa(),
                  settings: RouteSettings(name: 'wa')),
              (Route<dynamic> predicate) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyWa(),
                  settings: RouteSettings(name: 'wa')),
              (Route<dynamic> predicate) => false);
        }
      });
    }
  }

  @override
  onFailPhoneVerification(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isSaving = false;
      });
      BaseFunction().displayToastLong(data['errorMessage']);
    }
  }

  @override
  onSuccessCheckPhone(Map data) {
    sendOTP();
  }

  @override
  onFailCheckPhone(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isSaving = false;
      });
    }
    BaseFunction().displayToastLong(data['errorMessage']);
  }
}
