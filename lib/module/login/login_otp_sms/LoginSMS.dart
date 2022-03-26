import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/login/login_otp_sms/pattern/LoginSMSPresenter.dart';
import 'package:icati_app/module/login/login_otp_sms/pattern/LoginSMSWidgets.dart';
import 'package:icati_app/module/login/login_otp_sms/pattern/loginSMSView.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';

class LoginSMS extends StatefulWidget {
  @override
  _LoginSMSState createState() => _LoginSMSState();
}

class _LoginSMSState extends State<LoginSMS> implements LoginSMSView {
  final GlobalKey<State> keyLoader = new GlobalKey<State>();
  static final _formKey = new GlobalKey<FormState>();

  TextEditingController _hpCont = TextEditingController();

  TextEditingController _otpCont = TextEditingController();
  final FocusNode otpNode = FocusNode();
  StreamController<ErrorAnimationType> _errorController;

  BaseData _baseData = BaseData();
  LoginSMSPresenter _loginSMSPresenter;
  Member _member = Member();

  Duration _count;
  Duration _interval = Duration(seconds: 1);
  Timer _timer;
  String verificationId = "", resendToken = "";

  @override
  void initState() {
    _loginSMSPresenter = new LoginSMSPresenter();
    _loginSMSPresenter.attachView(this);
    getCurrentLocation();
    getCredential();
    startCount();
    _baseData.isSaving = false;
    _baseData.autoValidate = false;
    _baseData.hpValidate = false;
    _baseData.otpValidate = false;
    _baseData.resendOTP = false;
    _baseData.page = 1;
    _baseData.lat = "";
    _baseData.long = "";
    super.initState();
  }

  getCredential() async {
    if (!mounted) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _baseData.isLogin =
        prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
    _member.deviceId = prefs.getString("deviceid").toString();
    print("device id SMS " + _member.deviceId);
  }

  getCurrentLocation() async {
    if (!mounted) return;

    Location location = new Location();
    _baseData.serviceEnabled = await location.serviceEnabled();
    if (!_baseData.serviceEnabled) {
      _baseData.serviceEnabled = await location.requestService();
      if (!_baseData.serviceEnabled) {
        return;
      }
    }
    _baseData.permissionGranted = await location.hasPermission();
    if (_baseData.permissionGranted == PermissionStatus.denied) {
      _baseData.permissionGranted = await location.requestPermission();
      if (_baseData.permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _baseData.locationData = await location.getLocation();
    setState(() {
      _baseData.lat = _baseData.locationData.latitude.toString();
      _baseData.long = _baseData.locationData.longitude.toString();
    });
    print("latitude : " + _baseData.lat);
    print("longitude : " + _baseData.long);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startCount() async {
    setState(() {
      _count = Duration(seconds: 30);
    });
    _timer = Timer.periodic(_interval, showCountDown);
  }

  void showCountDown(Timer timer) {
    if (this.mounted) {
      setState(() {
        if (_count.inSeconds == 0) {
          timer.cancel();
          _baseData.resendOTP = true;
        } else {
          _count = Duration(seconds: _count.inSeconds - 1);
        }
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
                            _baseData.page == 1
                                ? "assets/images/icon_sms.png"
                                : "assets/images/icon_otp.png",
                            width: 70,
                            height: 70),
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          _baseData.page == 1
                              ? Text("MASUK DENGAN OTP SMS",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(letterSpacing: 1))
                              : Text("CEK SMS ANDA",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(letterSpacing: 1)),
                          SizedBox(height: 10),
                          _baseData.page == 1
                              ? Text("Selamat Datang di ICATI",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline2)
                              : Text(
                                  "Kami telah mengirim SMS kode OTP \nke nomor handphone Anda",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(letterSpacing: 1))
                        ],
                      ),
                      SizedBox(height: 30),
                      _baseData.page == 1
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
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(10)),
        child: Column(
          children: <Widget>[
            LoginSMSWidgets().displayHpForm(context, _hpCont),
            SizedBox(height: 10),
            displayButtonSubmit(),
          ],
        ),
      ),
    );
  }

  Widget displayButtonSubmit() {
    return !_baseData.isSaving
        ? Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_baseData.page == 1) {
                      if (this.mounted) {
                        setState(() {
                          _baseData.isSaving = true;
                        });
                        if (_formKey.currentState.validate()) {
                          _loginSMSPresenter.checkLoginSMS(_hpCont.text);
                        } else {
                          _baseData.isSaving = false;
                        }
                      }
                    } else if (_baseData.page == 2) {
                      verifyOTP();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).buttonColor,
                      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: Text(
                      _baseData.page == 1
                          ? "KIRIM KODE OTP"
                          : "VERIFIKASI KODE OTP",
                      style: Theme.of(context).textTheme.button),
                ),
              ),
            ],
          )
        : BaseView().displayLoadingScreen(context,
            color: Theme.of(context).buttonColor);
  }

  Widget displayVerifyPhoneNumber() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(10)),
        child: Column(
          children: <Widget>[
            LoginSMSWidgets()
                .displayOtpInput(context, _otpCont, _errorController),
            SizedBox(height: 10),
            displayButtonSubmit(),
            SizedBox(height: 10),
            displayResendOtp(),
          ],
        ),
      ),
    );
  }

  Widget displayResendOtp() {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            onPressed: !_baseData.resendOTP
                ? () {}
                : () {
                    if (this.mounted) {
                      setState(() {
                        _baseData.resendOTP = false;
                      });
                    }
                    sendOTP();
                    startCount();
                  },
            style: ElevatedButton.styleFrom(
                primary: _baseData.resendOTP == true
                    ? Color(0XFFFFD700)
                    : Color(0XFFFFD700).withOpacity(0.5),
                padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            child: _baseData.resendOTP == true
                ? Text("Kirim Ulang OTP",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.black,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500))
                : Text(
                    "Kirim Ulang OTP dalam" +
                        ' (${_count.inSeconds}' +
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

  sendOTP() async {
    setState(() {
      //baseData.isSaving = true;
      FocusScope.of(context).requestFocus(FocusNode());
    });
    // if (_formKey.currentState.validate() &&
    //     hpCont.text != "" &&
    //     (hpCont.text.length > 10 && hpCont.text.length < 13)) {
    //   _formKey.currentState.save();
    try {
      String phone;
      if (!_hpCont.text.substring(0, 2).contains("62")) {
        phone = "62" + _hpCont.text.substring(1);
      }
      print("no hp " + phone.toString());
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+$phone',
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            setState(() {
              _baseData.isSaving = false;
            });
            BaseFunction().displayToastLong("Phone number is not valid");
          } else if (e.code == "app-not-authorized") {
            setState(() {
              _baseData.isSaving = false;
            });
            BaseFunction().displayToastLong("App is not authorized");
          } else if (e.code == "web-context-cancelled") {
            setState(() {
              _baseData.isSaving = false;
            });
            BaseFunction().displayToastLong("Cancelled");
          } else {
            setState(() {
              _baseData.isSaving = false;
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
              _baseData.page = 2;
              _baseData.isSaving = false;
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
        _baseData.isSaving = false;
      });
      BaseFunction().displayToastLong("Gagal mengirimkan kode OTP");
    }
    // }
    // else {
    //   setState(() {
    //     baseData.isSaving = false;
    //     baseData.hpValidate = true;
    //   });
    //   BaseFunction().displayToastLong("Periksa kembali data Anda");
    // }
  }

  verifyOTP() async {
    print("page " + _baseData.page.toString());
    if (this.mounted) {
      if (_otpCont.text.length != 6) {
        _errorController
            .add(ErrorAnimationType.shake); // Triggering error shake animation
      } else {
        try {
          print("cek verifikasi");
          print(this.verificationId);
          print(_otpCont.text);
          setState(() {
            _baseData.isSaving = true;
          });
          final AuthCredential credential = PhoneAuthProvider.credential(
            verificationId: this.verificationId,
            smsCode: _otpCont.text,
          );
//          final User user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
          await FirebaseAuth.instance.signInWithCredential(credential);
          _loginSMSPresenter.loginSMS(
              _hpCont.text, _member.deviceId, _baseData.lat, _baseData.long);
        } on FirebaseAuthException catch (e) {
          print(e);
          switch (e.code) {
            case "invalid-verification-code":
              _otpCont.clear();
              otpNode.requestFocus();
              setState(() {
                _baseData.isSaving = false;
              });
              BaseFunction().displayToastLong("Kode verifikasi salah");
              break;
            default:
              setState(() {
                _baseData.isSaving = false;
              });
              BaseFunction().displayToastLong("Verifikasi gagal");
              break;
          }
        }
      }
    }
  }

  @override
  onNetworkError() {
    if (this.mounted) {
      setState(() {
        _baseData.isSaving = false;
      });
    }
    BaseFunction()
        .displayToastLong("Connection failed, please try again later");
  }

  @override
  onSuccessCheckLoginSMS(Map data) {
    sendOTP();
  }

  @override
  onFailCheckLoginSMS(Map data) {
    if (this.mounted) {
      setState(() {
        _baseData.isSaving = false;
      });
    }
    BaseFunction().displayToastLong(data['errorMessage']);
  }

  @override
  onSuccessLoginSMS(Map data) async {
    print("berhasil");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("data twitter " + data['message'].toString());
    if (this.mounted) {
      setState(() {
        List dataMember = data['message'];
        prefs.setBool("IS_LOGIN", true);
        prefs.setString("member", jsonEncode(dataMember));
        print("ini get member " + prefs.getString("member").toString());
        // OneSignal.shared.sendTags({"mId": dataMember[0]['mId'].toString(), "deviceId": prefs.getString("deviceid").toString()}).then((value) {
        // });
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MenuBar(currentPage: 0),
          ),
          (Route<dynamic> predicate) => false);
    }
  }

  @override
  onFailLoginSMS(Map data) {
    print("gagal");
    if (this.mounted) {
      setState(() {
        _baseData.isSaving = false;
      });
      BaseFunction().displayToastLong(data['errorMessage']);
    }
  }
}
