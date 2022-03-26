import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/model/LoginRequest.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
import 'package:icati_app/module/register/verifikasi_email/pattern/verifikasiOtpEmailPresenter.dart';
import 'package:icati_app/module/register/verifikasi_email/pattern/verifikasiOtpEmailView.dart';
import 'package:icati_app/module/register/verifikasi_email/pattern/verifikasiOtpEmailWidgets.dart';
import 'package:location/location.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifikasiOtpEmail extends StatefulWidget {
  String type;
  String mEmail;
  String mId;

  VerifikasiOtpEmail({this.mEmail, this.mId, this.type});

  @override
  _VerifikasiOtpEmailState createState() => _VerifikasiOtpEmailState();
}

class _VerifikasiOtpEmailState extends State<VerifikasiOtpEmail>
    implements VerifikasiOtpEmailView {
  VerifikasiOtpEmailPresenter _verifikasiOtpEmailPresenter;
  static final _formKey = new GlobalKey<FormState>();

  TextEditingController _emailCont = TextEditingController();
  TextEditingController _otpCont = TextEditingController();
  StreamController<ErrorAnimationType> _errorController;

  BaseData _baseData = BaseData(
      isSaving: false, codeOtp: "", resendOTP: false, isSavingResend: false);

  List _dataOtpLogin;

  Duration count;
  Duration interval = Duration(seconds: 1);
  Timer timer;

  LoginRequest _loginRequest = LoginRequest();
  Member _member = Member();

  @override
  void initState() {
    _verifikasiOtpEmailPresenter = VerifikasiOtpEmailPresenter();
    _verifikasiOtpEmailPresenter.attachView(this);
    print("ini email " + widget.mEmail);
    super.initState();
    // _sendOtpEmail();
    // _emailCont = widget.dataComplete[0]['email'].isNotEmpty;
    // _getCredential();
  }

  _getCredential() async {
    if (!mounted) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _baseData.isLogin =
        prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
    if (_baseData.isLogin == false) {
      print("credential");
      setState(() {
        _member.deviceId = prefs.getString("deviceid");
      });

      _getCurrentLocation();
    }
  }

  _getCurrentLocation() async {
    if (!mounted) return;
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      _member.lat = _locationData.latitude.toString();
      _member.long = _locationData.longitude.toString();
    });
    print("latitude : " + _member.lat);
    print("longitude : " + _member.long);
  }

  @override
  void dispose() {
    _errorController?.close();
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
          _baseData.resendOTP = true;
        } else {
          count = Duration(seconds: count.inSeconds - 1);
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .08),
                    widget.type == "sendOtp"
                        ? Column(
                            children: [
                              Center(
                                child: Image.asset(
                                    "assets/images/icon_email.png",
                                    width: 70,
                                    height: 70),
                              ),
                              SizedBox(height: 20),
                              Text("MASUK DENGAN OTP EMAIL",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline1),
                              SizedBox(height: 10),
                              Text("Selamat Datang di ICATI",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline2),
                            ],
                          )
                        : Column(
                            children: [
                              Center(
                                child: Image.asset("assets/images/icon_otp.png",
                                    width: 70, height: 70),
                              ),
                              SizedBox(height: 20),
                              Text("CEK EMAIL ANDA",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(letterSpacing: 1)),
                              SizedBox(height: 10),
                              Text(
                                  "Kami telah mengirim kode OTP \nke email Anda",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(letterSpacing: 1)),
                              SizedBox(height: 10),
                            ],
                          ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setSp(10)),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: <Widget>[
                                widget.type == "sendOtpEmail"
                                    ? RegisterOtpEmailWidgets()
                                        .displayOtpEmail(context, _emailCont)
                                    : RegisterOtpEmailWidgets()
                                        .displayEmailOtpInput(
                                            context, _otpCont, _errorController)
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          !_baseData.isSaving
                              ? Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          !_baseData.isSaving
                                              ? widget.type == "sendOtp"
                                                  ? _sendOtpEmail()
                                                  : _verificationOtpLogin()
                                              : null;
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary:
                                                Theme.of(context).buttonColor,
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setSp(15)),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )),
                                        child: Text(
                                            widget.type == "sendOtpEmail"
                                                ? "KIRIM KODE OTP"
                                                : "VERIFIKASI KODE OTP",
                                            style: Theme.of(context)
                                                .textTheme
                                                .button),
                                      ),
                                    ),
                                  ],
                                )
                              : BaseView().displayLoadingScreen(context,
                                  color: Theme.of(context).buttonColor),
                          SizedBox(height: 10),
                          widget.type == "verifyOtpEmail"
                              ? !_baseData.isSavingResend
                                  ? _displayResendOtp(context)
                                  : BaseView().displayLoadingScreen(context,
                                      color: Color(0XFFFFD700))
                              : Container(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _sendOtpEmail() async {
    setState(() {
      _baseData.isSaving = true;
      FocusScope.of(context).requestFocus(FocusNode());
    });
    // print("email" + widget.dataComplete[0]['email'].isNotEmpty);
    // print("wiget type" + widget.type);
    if (_formKey.currentState.validate()) {
      _verifikasiOtpEmailPresenter.sendLoginOtpEmail(widget.mEmail);
    } else {
      setState(() {
        _baseData.isSaving = false;
      });
    }
  }

  _verificationOtpLogin() {
    int now = new DateTime.now().millisecondsSinceEpoch ~/ 1000;
    print("ini now " + now.toString());
    setState(() {
      _baseData.isSaving = true;
      FocusScope.of(context).requestFocus(FocusNode());
    });
    if (_formKey.currentState.validate()) {
      if (_otpCont.text != _dataOtpLogin[0]['otp']) {
        _baseData.isSaving = false;
        BaseFunction().displayToastLong("Kode Verifikasi Salah");
      } else if (_dataOtpLogin[0]['otpexp'] < now) {
        _baseData.isSaving = false;
        BaseFunction()
            .displayToastLong("Kode OTP yang Anda masukkan sudah kedaluwarsa");
      } else {
        _loginRequest.mId = _dataOtpLogin[0]['mId'].toString();
        _loginRequest.email = _dataOtpLogin[0]['email'];
        _loginRequest.deviceId = _member.deviceId;
        _loginRequest.lat = _member.lat;
        _loginRequest.long = _member.long;

        _verifikasiOtpEmailPresenter.loginOtpEmail(_loginRequest);
      }
    } else {
      setState(() {
        _baseData.isSaving = false;
      });
    }
  }

  Widget _displayResendOtp(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (_baseData.resendOTP == true) {
                setState(() {
                  _baseData.isSavingResend = true;
                  startCount();
                  if (_dataOtpLogin != null) {
                    _verifikasiOtpEmailPresenter.resendLoginOtpEmail(
                        _dataOtpLogin[0]['email'],
                        _dataOtpLogin[0]['mId'].toString(),
                        _dataOtpLogin[0]['otp'],
                        _dataOtpLogin[0]['otpexp'].toString());
                  }
                });
              }
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
                    "Kirim Ulang OTP dalam " +
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

  @override
  onFailSendOtpEmail(Map data) {
    if (this.mounted) {
      setState(() {
        _baseData.isSaving = false;
        BaseFunction().displayToastLong(data['errorMessage']);
      });
    }
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessSendOtpEmail(Map data) async {
    if (this.mounted) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _baseData.isSaving = false;
        BaseFunction().displayToastLong(data['message']);

        widget.type = "verifyOtpEmail";

        if (widget.type == "verifyOtpEmail") {
          startCount();
        }

        final _dataOtpEmail = prefs.getString("otpEmail");
        final Map _dataOtp = jsonDecode(_dataOtpEmail);
        _dataOtpLogin = _dataOtp['otpemail'];
        print("ini data otp " + _dataOtp['otpemail'].toString());
      });
    }
  }

  @override
  onFailLoginOtpEmail(Map data) {
    if (this.mounted) {
      BaseFunction().displayToast(data['errorMessage']);
    }
  }

  @override
  onSuccessLoginOtpEmail(Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        List dataMember = data['message'];
        prefs.setBool("IS_LOGIN", true);
        prefs.setString("member", jsonEncode(dataMember));
        print("ini get member " + prefs.getString("member").toString());
        prefs.remove('otpEmail');
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
  onFailResendLoginOtpEmail(Map data) {
    if (this.mounted) {
      setState(() {
        _baseData.isSavingResend = false;
        BaseFunction().displayToastLong(data['errorMessage']);
      });
    }
  }

  @override
  onSuccessResendLoginOtpEmail(Map data) async {
    if (this.mounted) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _baseData.isSavingResend = false;
        _baseData.resendOTP = false;
        BaseFunction().displayToastLong(data['message']);

        widget.type = "verifyOtpEmail";

        if (widget.type == "verifyOtpEmail") {
          startCount();
        }

        final dataOtpEmail = prefs.getString("otpEmail");
        final Map dataOtp = jsonDecode(dataOtpEmail);
        _dataOtpLogin = dataOtp['otpemail'];
        print("ini data otp resend " + dataOtp['otpemail'].toString());
      });
    }
  }
}
