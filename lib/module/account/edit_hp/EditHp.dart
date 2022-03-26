import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/account/edit_hp/pattern/EditHpPresenter.dart';
import 'package:icati_app/module/account/edit_hp/pattern/EditHpView.dart';
import 'package:icati_app/module/account/edit_hp/pattern/EditHpWidgets.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';

// ignore: must_be_immutable
class EditHp extends StatefulWidget {
  List dataComplete;

  EditHp({this.dataComplete});

  @override
  _EditHpState createState() => _EditHpState();
}

class _EditHpState extends State<EditHp> implements EditHpView {
  EditHpPresenter _editHpPresenter;
  static final _formKey = new GlobalKey<FormState>();

  TextEditingController _hpCont = TextEditingController();

  TextEditingController _otpCont = TextEditingController();
  final FocusNode _otpNode = FocusNode();
  StreamController<ErrorAnimationType> _errorController;

  BaseData _baseData = BaseData();
  Member _member = Member();

  Duration _count;
  Duration _interval = Duration(seconds: 1);
  Timer _timer;
  String verificationId = "", resendToken = "";

  @override
  void initState() {
    _editHpPresenter = new EditHpPresenter();
    _editHpPresenter.attachView(this);
    getCredential();
    //startCount();
    _baseData.isSaving = false;
    _baseData.autoValidate = false;
    _baseData.hpValidate = false;
    _baseData.otpValidate = false;
    _baseData.resendOTP = false;
    _baseData.page = 1;
    super.initState();
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

  getCredential() async {
    if (!mounted) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _baseData.isLogin =
        prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
    if (_baseData.isLogin) {
      setState(() {
        final user = prefs.getString("member");
        final List data = jsonDecode(user);
        _member.mId = data[0]['mId'].toString();
        _member.mHp = data[0]['mHp'].toString();
        print("nomor hp " + data[0]['mHp'].toString());
        if (_member.mHp.substring(0, 2).contains("62")) {
          _member.mHp = "0" + _member.mHp.substring(2);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          titleSpacing: 0,
          title: Text("UBAH NOMOR HP",
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(color: Colors.white)),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Color.fromRGBO(159, 28, 42, 1),
                  Color.fromRGBO(159, 28, 42, 1),
                ])),
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _baseData.page == 1
            ? displayPhoneNumberInput()
            : displayVerifyPhoneNumber(),
      ),
    );
  }

  Widget displayPhoneNumberInput() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          EditHpWidgets().displayCurrentPhoneNumber(context, _member),
          SizedBox(height: 20),
          EditHpWidgets().displayHpForm(context, _hpCont),
          SizedBox(height: 20),
          displayButtonSubmit(),
        ],
      ),
    );
  }

  Widget displayVerifyPhoneNumber() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: <Widget>[
          Container(
            width: 70.0,
            height: 70.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xffCCC9DC).withOpacity(0.5),
                      Color(0xffCCC9DC).withOpacity(0.5)
                    ])),
            child: Center(
              child: Image.asset("assets/images/icon_otp.png",
                  width: 70, height: 70),
            ),
          ),
          SizedBox(height: 30),
          Column(
            children: [
              Text("VERIFIKASI NOMOR HANDPHONE",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(letterSpacing: 1)),
              SizedBox(height: 10),
              Text(
                  "Kami telah mengirim SMS verifikasi \nke nomor handphone Anda",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(letterSpacing: 1))
            ],
          ),
          SizedBox(height: 20),
          EditHpWidgets().displayOtpInput(context, _otpCont, _errorController),
          SizedBox(height: 20),
          displayButtonSubmit(),
          SizedBox(height: 20),
          displayResendOtp(),
        ],
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
                padding: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
      // _baseData.isSaving = true;
      FocusScope.of(context).requestFocus(FocusNode());
    });
    // if (_formKey.currentState.validate() &&
    //     _hpCont.text != "" &&
    //     (_hpCont.text.length > 10 && _hpCont.text.length < 13)) {
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
    // } else {
    //   setState(() {
    //     _baseData.isSaving = false;
    //     _baseData.hpValidate = true;
    //   });
    //   BaseFunction().displayToastLong("Periksa kembali data Anda");
    // }
  }

  verifyOTP() async {
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
          _editHpPresenter.editHp(_member.mId.toString(), _hpCont.text);
        } on FirebaseAuthException catch (e) {
          print(e);
          switch (e.code) {
            case "invalid-verification-code":
              _otpCont.clear();
              _otpNode.requestFocus();
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
                          _editHpPresenter.checkPhone(
                              _member.mId, _hpCont.text);
                        } else {
                          _baseData.isSaving = false;
                        }
                      }
                    } else {
                      verifyOTP();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).buttonColor,
                      padding: const EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: Text(
                      _baseData.page == 1 ? "SIMPAN" : "VERIFIKASI KODE",
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
  onSuccessEditHp(Map data) {
    if (this.mounted) {
      setState(() {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => MenuBar(currentPage: 4),
                settings: RouteSettings(name: 'Edit HP')),
            (Route<dynamic> predicate) => false);
      });
      BaseFunction().displayToastLong(data['message']);
    }
  }

  @override
  onFailEditHp(Map data) {
    if (this.mounted) {
      setState(() {
        _baseData.isSaving = false;
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
        _baseData.isSaving = false;
      });
    }
    BaseFunction().displayToastLong(data['errorMessage']);
  }
}
