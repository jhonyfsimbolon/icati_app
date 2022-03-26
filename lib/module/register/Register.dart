import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icati_app/model/LoginRequest.dart';
import 'package:icati_app/module/register/success_register.dart';
import 'package:icati_app/module/register/verifikasiEmail.dart';
import 'package:icati_app/module/register/verifikasi_email/verifikasi_otp_email.dart';
// import 'package:icati_app/module/register/verifikasi_email/verifikasi_otp_email.dart';
import 'package:location/location.dart' as location;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
import 'package:icati_app/module/register/pattern/RegisterPresenter.dart';
import 'package:icati_app/module/register/pattern/RegisterView.dart';
import 'package:icati_app/module/register/pattern/RegisterWidgets.dart';

class Register extends StatefulWidget {
  final String email,
      name,
      googleId,
      fbId,
      twitterId,
      appleId,
      emailVerification;
  String refcode;

  Register(
      {this.email,
      this.name,
      this.googleId,
      this.fbId,
      this.appleId,
      this.twitterId,
      this.emailVerification,
      this.refcode});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> implements RegisterView {
  RegisterPresenter _registerPresenter;

  static final _formKey = new GlobalKey<FormState>();

  // TextEditingController _currentNegara = TextEditingController();
  TextEditingController _regEmailCont = TextEditingController();
  TextEditingController _regNameCont = TextEditingController();
  TextEditingController _regNameMandarinCont = TextEditingController();
  TextEditingController _regUnivCont = TextEditingController();
  TextEditingController _regThnMasukCont = TextEditingController();
  // TextEditingController _regAlamatCont = TextEditingController();
  // TextEditingController _regTmpLahirCont = TextEditingController();
  TextEditingController _regPasswordCont = TextEditingController();
  TextEditingController _regRePasswordCont = TextEditingController();
  TextEditingController _regRefCont = TextEditingController();
  // TextEditingController _regBirthDayCont = TextEditingController();

  BaseData _baseData = BaseData(
      isSaving: false,
      passwordVisible: false,
      rePasswordVisible: false,
      autoValidate: false);
  LoginRequest _loginRequest = LoginRequest();

  String _deviceId = "",
      _lat = "",
      _long = "",
      _currentGender = "",
      _currentReligion = "",
      // _currentUniv = "",
      // _currentThnMasuk = "",
      // _currentTmpLahir = "",
      // _currentAlamat = "",
      _currentBlood = "",
      _currentNegara = "100",
      _currentProvince,
      _currentCity;

  List _dataProvince, _dataCity, _dataProvinceNew, _dataCityNew, _dataNegara;

  List gender = [
    {'genderId': 'm', 'genderName': 'Pria'},
    {'genderId': 'f', 'genderName': 'Wanita'}
  ];

  List religion = [
    {'religionId': 'buddha', 'religionName': 'Buddha'},
    {'religionId': 'hindu', 'religionName': 'Hindu'},
    {'religionId': 'islam', 'religionName': 'Islam'},
    {'religionId': 'katolik', 'religionName': 'Katolik'},
    {'religionId': 'konghucu', 'religionName': 'Konghucu'},
    {'religionId': 'kristen-protestan', 'religionName': 'Kristen Protestan'},
  ];

  @override
  void initState() {
    _registerPresenter = new RegisterPresenter();
    _registerPresenter.attachView(this);
    getCredential();
    _getCurrentLocation();
    super.initState();
    // print("google id " + widget.googleId);
    // print("apple id " + widget.appleId);
    // print("fb id " + widget.fbId);
    // print("twitter id " + widget.twitterId);

    if (_currentGender == null) {
      _currentGender = gender[0]['genderId'].toString();
    }
    if (_currentReligion == null) {
      _currentReligion = religion[0]['religionId'].toString();
    }
  }

  getCredential() async {
    if (!mounted) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _deviceId = prefs.getString("deviceid");
    if (widget.email.isNotEmpty) {
      _regEmailCont.text = widget.email;
    }
    if (widget.name.isNotEmpty) {
      _regNameCont.text = widget.name;
    }
    if (widget.refcode != null) {
      _regRefCont.text = widget.refcode.toString();
    }

    _registerPresenter.getNegara();
  }

  _getCurrentLocation() async {
    if (!mounted) return;
    bool _serviceEnabled;
    _serviceEnabled = await location.Location().serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.Location().requestService();
      if (!_serviceEnabled) {
        print("Location service disabled.");
        _lat = "";
        _long = "";
      } else {
        await _getPermissionLocation();
      }
    } else {
      await _getPermissionLocation();
    }
  }

  _getPermissionLocation() async {
    if (mounted) {
      location.PermissionStatus _permissionGranted;
      location.LocationData _locationData;
      _permissionGranted = await location.Location().hasPermission();
      print("Permission location hasPermission?");
      if (_permissionGranted == location.PermissionStatus.denied) {
        _permissionGranted = await location.Location().requestPermission();
        if (_permissionGranted != location.PermissionStatus.granted) {
          print("Permission location denied.");
          _lat = "";
          _long = "";
        } else {
          print("Permission location granted 2nd time.");
          _locationData = await new location.Location().getLocation();
          _lat = _locationData.latitude.toString();
          _long = _locationData.longitude.toString();
        }
      } else if (_permissionGranted == location.PermissionStatus.granted) {
        print("Permission location granted.");
        _locationData = await new location.Location().getLocation();
        _lat = _locationData.latitude.toString();
        _long = _locationData.longitude.toString();
      }

      print("lat: " + _lat);
      print("long: " + _long);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: WillPopScope(
        onWillPop: onWillPop,
        child: GestureDetector(
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
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * ScreenUtil().setSp(.08)),
                        Center(
                          child: Image.asset("assets/images/lgicati.png",
                              width: ScreenUtil().setSp(200),
                              height: ScreenUtil().setSp(80)),
                        ),
                        SizedBox(height: ScreenUtil().setSp(10.sp)),
                        Text("Formulir Pendaftaran",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline1),
                        SizedBox(height: ScreenUtil().setSp(10.sp)),
                        Text("Selamat Datang di ICATI",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline2),
                        SizedBox(height: ScreenUtil().setSp(15)),
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // autovalidate: _baseData.autoValidate,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setSp(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: ScreenUtil().setSp(10)),
                                RegisterWidgets()
                                    .displayRegName(context, _regNameCont),
                                SizedBox(height: ScreenUtil().setSp(10)),
                                RegisterWidgets().displayRegNameMandarin(
                                    context, _regNameMandarinCont),
                                SizedBox(height: ScreenUtil().setSp(10)),
                                // RegisterWidgets().displayRegGender(context,
                                //     _currentGender, _selectGender, gender),
                                // SizedBox(height: ScreenUtil().setSp(10)),
                                // RegisterWidgets().displayRegReligion(context,
                                //     _currentReligion, _selectReligion, religion),
                                // SizedBox(height: ScreenUtil().setSp(10)),
                                // RegisterWidgets()
                                //     .displayAlamat(context, _regAlamatCont),
                                // SizedBox(height: ScreenUtil().setSp(10)),
                                RegisterWidgets().displayRegNegara(context,
                                    _currentNegara, _selectNegara, _dataNegara),

                                SizedBox(height: ScreenUtil().setSp(10)),
                                _currentNegara == "100"
                                    ? RegisterWidgets().displayRegProvince(
                                        context,
                                        _currentProvince,
                                        _selectProvince,
                                        _dataProvince)
                                    : SizedBox(),
                                _currentNegara == "100"
                                    ? SizedBox(height: ScreenUtil().setSp(10))
                                    : SizedBox(),
                                _currentNegara == "100"
                                    ? RegisterWidgets().displayRegCity(context,
                                        _currentCity, _selectCity, _dataCity)
                                    : SizedBox(),
                                _currentNegara == "100"
                                    ? SizedBox(height: ScreenUtil().setSp(10))
                                    : SizedBox(),
                                // RegisterWidgets().displayRegBlood(
                                //     context, _currentBlood, _selectBlood),
                                // SizedBox(height: ScreenUtil().setSp(10)),
                                // RegisterWidgets()
                                //     .displayTmpLahir(context, _regTmpLahirCont),
                                // SizedBox(height: ScreenUtil().setSp(10)),
                                // RegisterWidgets().displayRegBirthDay(
                                //     context, _regBirthDayCont),
                                // SizedBox(height: ScreenUtil().setSp(10)),
                                RegisterWidgets()
                                    .displayUniv(context, _regUnivCont),
                                SizedBox(height: ScreenUtil().setSp(10)),
                                RegisterWidgets()
                                    .displayThnMasuk(context, _regThnMasukCont),
                                SizedBox(height: ScreenUtil().setSp(10)),
                                RegisterWidgets().displayRegEmail(
                                    context, _regEmailCont, widget.email),
                                SizedBox(height: ScreenUtil().setSp(10)),
                                RegisterWidgets().displayRegPassword(
                                    context,
                                    _regPasswordCont,
                                    _baseData.passwordVisible,
                                    _passwordVisibility),
                                SizedBox(height: ScreenUtil().setSp(10)),
                                RegisterWidgets().displayRegRePass(
                                    context,
                                    _regPasswordCont,
                                    _regRePasswordCont,
                                    _baseData.rePasswordVisible,
                                    _rePasswordVisibility),
                                SizedBox(height: ScreenUtil().setSp(10)),
                                RegisterWidgets().displayRegReference(
                                    context, _regRefCont, widget.refcode),
                                SizedBox(height: ScreenUtil().setSp(10)),
                                !_baseData.isSaving
                                    ? Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: ElevatedButton(
                                                onPressed: save,
                                                style: ElevatedButton.styleFrom(
                                                    primary: Theme.of(context)
                                                        .buttonColor,
                                                    padding: EdgeInsets.all(
                                                        ScreenUtil().setSp(15)),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    )),
                                                child: Text("DAFTAR",
                                                    style: TextStyle(
                                                        color: Colors.white))),
                                          ),
                                        ],
                                      )
                                    : BaseView().displayLoadingScreen(context,
                                        color: Theme.of(context).buttonColor),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void save() {
    setState(() {
      _baseData.isSaving = true;
      FocusScope.of(context).requestFocus(FocusNode());
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Member member = Member(
          // mAlamat: _regAlamatCont.text,
          // mTemLahir: _regTmpLahirCont.text,
          // mGender: _currentGender,
          // mReligion: _currentReligion,
          // mBlood: _currentBlood,
          // birthDate: _regBirthDayCont.text,
          mEmail: _regEmailCont.text,
          mName: _regNameCont.text,
          mNameMandarin: _regNameMandarinCont.text,
          mNameUniv: _regUnivCont.text,
          mThnMasuk: _regThnMasukCont.text,
          negaraid: _currentNegara,
          provinsiId: _currentProvince ?? "0",
          kabupatenId: _currentCity ?? "0",
          mPassword: _regPasswordCont.text,
          referenceNumber: _regRefCont.text,
          emailVerification: widget.emailVerification,
          mAppleId: widget.appleId,
          mGoogleId: widget.googleId,
          mTwitterId: widget.twitterId,
          mFbId: widget.fbId,
          lat: _lat,
          long: _long,
          deviceId: _deviceId);

      _registerPresenter.register(member);

      print("ini register member " +
          jsonEncode(member.toRegisterMap()).toString());
    } else {
      setState(() {
        _baseData.autoValidate = true;
        _baseData.isSaving = false;
      });
    }
  }

  void _selectGender(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentGender = value;
      print("current gender select " + _currentGender);
    });
  }

  void _selectReligion(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentReligion = value;
      print("current religion select " + _currentReligion);
    });
  }

  Future<bool> onWillPop() {
    // DateTime now = DateTime.now();
    if (widget.refcode != null) {
      // BaseFunction().displayToast(widget.refcode.toString());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MenuBar(currentPage: 0),
          ),
          (Route<dynamic> predicate) => false);
      return Future.value(true);
    } else {
      return Future.value(true);
    }
  }

  void _selectNegara(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentNegara = value;
      print("current provinsi select " + _currentNegara);
      if (_currentNegara != null) {
        if (_currentNegara == "100") {
          print("proses mengambil data kabupaten");
          this._currentProvince = null;
          this._currentCity = null;
          _registerPresenter.getProvince();
        } else {
          this._currentProvince = null;
          this._currentCity = null;
          _dataProvince = null;
          _dataCity = null;
        }
      } else {
        // this._currentProvince = null;
        // this._currentCity = null;
        _dataProvince = null;
        _dataCity = null;
      }
    });
  }

  void _selectProvince(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentProvince = value;
      print("current provinsi select " + _currentProvince);
      if (_currentProvince != null) {
        print("proses mengambil data kabupaten");
        this._currentCity = null;
        _registerPresenter.getCity(_currentProvince);
      }
    });
  }

  void _selectCity(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentCity = value;
      print("current kabupaten select " + _currentCity);
    });
  }

  void _selectBlood(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentBlood = value;
      print("current blood select " + _currentBlood);
    });
  }

  void _passwordVisibility() {
    if (this.mounted) {
      setState(() {
        this._baseData.passwordVisible = !_baseData.passwordVisible;
      });
    }
  }

  void _rePasswordVisibility() {
    if (this.mounted) {
      setState(() {
        this._baseData.rePasswordVisible = !_baseData.rePasswordVisible;
      });
    }
  }

  @override
  onFailRegister(Map data) {
    if (this.mounted) {
      setState(() {
        _baseData.isSaving = false;
      });
      BaseFunction().displayToast(data['errorMessage']);
    }
  }

  @override
  onSuccessRegister(Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        List dataMember = data['message'];
        prefs.setBool("IS_LOGIN", true);
        prefs.setString("member", jsonEncode(dataMember));
        print("ini get member " + prefs.getString("member").toString());
        OneSignal.shared.sendTags({
          "mId": dataMember[0]['mId'].toString(),
          "deviceId": prefs.getString("deviceid").toString()
        }).then((value) {});
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MenuBar(currentPage: 0),
          ),
          (Route<dynamic> predicate) => false);
    }
    //-----proses login --------
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // _loginRequest.email = _regEmailCont.text;
    // _loginRequest.password = _regPasswordCont.text;
    // _loginRequest.deviceId = prefs.getString("deviceid");
    // _loginRequest.lat = _lat;
    // _loginRequest.long = _long;
    // print("data login");
    // print(_loginRequest.toLoginByPasswordMap());
    // _registerPresenter.loginByPassword(_loginRequest);
    //-----selesai proses login---------

    // Navigator.of(context).pushReplacement(MaterialPageRoute(
    //     builder: (_) => VerifikasiEmail(
    //           dataLink: [data],
    //         )));

    // Navigator.of(context).pushReplacement(MaterialPageRoute(
    //   builder: (context) => SuccessRegister(
    //       mEmail: _regEmailCont.text, mPassword: _regPasswordCont.text),
    //   settings: RouteSettings(name: "Succes register"),
    // ));

    // Navigator.popAndPushNamed(context, VerifikasiEmail(dataLink: [data],isLogin: true, key: Register,));
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (this.mounted) {
    //   setState(() {
    //     List dataMember = data['message'];
    //     prefs.setBool("IS_LOGIN", true);
    //     prefs.setString("member", jsonEncode(dataMember));
    //     print("ini get member " + prefs.getString("member").toString());
    //     OneSignal.shared.sendTags({
    //       "mId": dataMember[0]['mId'].toString(),
    //       "deviceId": prefs.getString("deviceid").toString()
    //     }).then((value) {});
    //   });
    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => MenuBar(currentPage: 0),
    //       ),
    //       (Route<dynamic> predicate) => false);
    // }
  }

  @override
  onFailProvince(Map data) {
    if (this.mounted) {
      setState(() {
        _dataProvince = data['errorMessage'];
      });
    }
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onFailNegara(Map data) {
    // TODO: implement onFailNegara
    throw UnimplementedError();
  }

  @override
  onSuccessNegara(Map data) {
    if (this.mounted) {
      setState(() {
        _dataNegara = data['message'];
        _dataProvince = [];
        _dataCity = [];
        if (_dataNegara != null) {
          _currentNegara = _dataNegara
              .where(
                  (element) => element['negaraName'].toString() == "INDONESIA")
              .first['negaraId']
              .toString();
          // int a = 0;
          // _currentNegara = a.toString();
          print("ini provinsiId " + _currentNegara);
        }
        if (_currentNegara == "100") {
          print("proses mengambil data kabupaten");
          _registerPresenter.getProvince();
        } else {
          _dataProvince = [];
          _dataCity = [];
        }
      });
    }
  }

  @override
  onSuccessProvince(Map data) {
    if (this.mounted) {
      setState(() {
        _dataProvince = data['message'];
        if (_dataProvince != null) {
          // _currentProvince = _dataProvince
          //     .where((element) =>
          //         element['provinsiName'].toString() == "SELURUH INDONESIA")
          //     .first['provinsiId']
          //     .toString();
          int a = 0;
          _currentProvince = a.toString();
          print("ini provinsiId " + _currentProvince);
        }
        if (_currentProvince != null) {
          print("proses mengambil data kabupaten");
          _registerPresenter.getCity(_currentProvince);
        }
      });
    }
  }

  @override
  onFailCity(Map data) {
    if (this.mounted) {
      setState(() {
        _dataCity = data['errorMessage'];
      });
    }
  }

  @override
  onSuccessCity(Map data) {
    if (this.mounted) {
      setState(() {
        // data['message'].map((e) {
        //   // e['kabupatenId'].toString()!="0"? _dataCityNew.add(e):null;
        //   if(e['kabupatenId'].toString()!="2000"){
        //     _dataCity.addAll(e);
        //   }
        // });

        _dataCity = data['message'];
        // _dataCityNew = [];
        // int index = 0;
        // for(int idx = 0; idx<_dataCity.length; idx++){
        //   if(data['message'][idx]['kabupatenId'].toString() != "0"){
        //     _dataCityNew[index]['kabupatenId'] = _dataCity[idx]['kabupatenId'];
        //     _dataCityNew[index]['kabupatenName'] = _dataCity[idx]['kabupatenName'];
        //     index++;
        //   }
        // }
        // _dataCity = _dataCityNew;
        // _dataCity = data['message'];
        print("ini kota " + _dataCityNew.toString());
      });
    }
  }

  @override
  onFailCheckRegister(Map data) {}

  @override
  onSuccessCheckRegister(Map data) {}

  @override
  onSuccessLoginApple(Map data) {}

  @override
  onFailLoginApple(Map data) {}

  @override
  onFailLoginByPassword(Map data) {
    // if (this.mounted) {
    //   setState(() {
    //     baseData.isSaving = false;
    //   });
    //   BaseFunction().displayToast(data['errorMessage']);
    // }
  }

  @override
  onSuccessLoginByPassword(Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        List dataMember = data['message'];
        prefs.setBool("IS_LOGIN", true);
        prefs.setString("member", jsonEncode(dataMember));
        print("ini get member " + prefs.getString("member").toString());
        OneSignal.shared.sendTags({
          "mId": dataMember[0]['mId'].toString(),
          "deviceId": prefs.getString("deviceid").toString()
        }).then((value) {});
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MenuBar(currentPage: 0),
          ),
          (Route<dynamic> predicate) => false);
    }
  }
}
