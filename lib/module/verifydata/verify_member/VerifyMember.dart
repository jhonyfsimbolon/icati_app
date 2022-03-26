import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
import 'package:icati_app/module/register/pattern/RegisterWidgets.dart';
import 'package:icati_app/module/verifydata/verify_member/pattern/VerifyMemberPresenter.dart';
import 'package:icati_app/module/verifydata/verify_member/pattern/VerifyMemberView.dart';
import 'package:icati_app/module/verifydata/verify_wa/VerifyWa.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyMember extends StatefulWidget {
  List dataComplete;

  VerifyMember({this.dataComplete});

  @override
  _VerifyMemberState createState() => _VerifyMemberState();
}

class _VerifyMemberState extends State<VerifyMember>
    implements VerifyMemberView {
  VerifyMemberPresenter _verifyMemberPresenter;
  static final _formKey = new GlobalKey<FormState>();

  TextEditingController _regRefCont = TextEditingController();
  TextEditingController _regBirthDayCont = TextEditingController();

  BaseData _baseData = BaseData(isSaving: false);

  Member _member = Member();

  String _currentGender = "",
      _currentReligion = "",
      _currentBlood = "",
      _currentProvince,
      _currentCity;

  List _dataProvince, _dataCity;

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
    _verifyMemberPresenter = VerifyMemberPresenter();
    _verifyMemberPresenter.attachView(this);
    _verifyMemberPresenter.getProvince();
    _getCredential();
    super.initState();

    if (_currentGender == null) {
      _currentGender = gender[0]['genderId'].toString();
    }
    if (_currentReligion == null) {
      _currentReligion = religion[0]['religionId'].toString();
    }
  }

  _getCredential() async {
    if (!mounted) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _baseData.isLogin =
        prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
    if (_baseData.isLogin) {
      final dataMember = prefs.getString("member");
      final List data = jsonDecode(dataMember);
      if (this.mounted) {
        setState(() {
          _member.mId = data[0]['mId'].toString();
        });
      }
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
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .08),
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
                          child: Icon(Icons.person,
                              size: 50, color: Color(0xff0094C6)),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text("LENGKAPI DATA DIRI",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              .copyWith(letterSpacing: 1)),
                      SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 15),
                              RegisterWidgets().displayRegGender(context,
                                  _currentGender, _selectGender, gender),
                              SizedBox(height: 15),
                              RegisterWidgets().displayRegReligion(context,
                                  _currentReligion, _selectReligion, religion),
                              SizedBox(height: 15),
                              RegisterWidgets().displayRegProvince(
                                  context,
                                  _currentProvince,
                                  _selectProvince,
                                  _dataProvince),
                              SizedBox(height: 15),
                              RegisterWidgets().displayRegCity(context,
                                  _currentCity, _selectCity, _dataCity),
                              SizedBox(height: 15),
                              RegisterWidgets().displayRegBlood(
                                  context, _currentBlood, _selectBlood),
                              SizedBox(height: 15),
                              RegisterWidgets().displayRegBirthDay(
                                  context, _regBirthDayCont),
                              SizedBox(height: 15),
                              RegisterWidgets().displayRegReference(
                                  context, _regRefCont, ""),
                              SizedBox(height: 15),
                              !_baseData.isSaving
                                  ? Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: RaisedButton(
                                            onPressed: _save,
                                            padding: const EdgeInsets.all(15),
                                            color:
                                                Theme.of(context).buttonColor,
                                            child: Text("SIMPAN",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
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
    );
  }

  void _save() {
    setState(() {
      _baseData.isSaving = true;
      FocusScope.of(context).requestFocus(FocusNode());
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _member.mId = _member.mId;
      _member.mGender = _currentGender;
      _member.mReligion = _currentReligion;
      _member.provinsiId = _currentProvince;
      _member.kabupatenId = _currentCity;
      _member.mBlood = _currentBlood;
      _member.referenceNumber = _regRefCont.text;
      _member.birthDate = _regBirthDayCont.text;

      _verifyMemberPresenter.completeProfile(_member);

      print("ini lengkapi data member " +
          jsonEncode(_member.toCompleteProfileMap()).toString());
    } else {
      setState(() {
        _baseData.isSaving = false;
      });
    }
  }

  void _selectProvince(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentProvince = value;
      print("current provinsi select " + _currentProvince);
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

  @override
  onFailCity(Map data) {
    if (this.mounted) {
      setState(() {
        _dataCity = data['errorMessage'];
      });
    }
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
  onSuccessCity(Map data) {
    if (this.mounted) {
      setState(() {
        _dataCity = data['message'];
        print("ini kota " + _dataCity.toString());
      });
    }
  }

  @override
  onSuccessProvince(Map data) {
    if (this.mounted) {
      setState(() {
        _dataProvince = data['message'];
        if (_dataProvince != null) {
          _currentProvince = _dataProvince
              .where((element) => element['provinsiName'].toString() == "RIAU")
              .first['provinsiId']
              .toString();
          print("ini provinsiId " + _currentProvince);

          if (_currentProvince != null) {
            _verifyMemberPresenter.getCity(_currentProvince);
          }
        }
      });
    }
  }

  @override
  onFailCompleteProfile(Map data) {
    if (this.mounted) {
      BaseFunction().displayToastLong(data['errorMessage']);
    }
  }

  @override
  onSuccessCompleteProfile(Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        List dataMember = data['message'];
        prefs.setString("member", jsonEncode(dataMember));
        print("ini get member complete profile" +
            prefs.getString("member").toString());
      });
      if (widget.dataComplete[0]['wa'] == 'n') {
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => VerifyWa(),
        //         settings: RouteSettings(name: 'Verifikasi WhatsApp')),
        //     (Route<dynamic> predicate) => false);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => MenuBar(currentPage: 0),
                settings: RouteSettings(name: 'Login')),
            (Route<dynamic> predicate) => false);
      } else {
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
