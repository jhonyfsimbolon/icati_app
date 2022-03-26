import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/model/Job.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/jobvacancy/addJob/pattern/AddJobPresenter.dart';
import 'package:icati_app/module/jobvacancy/addJob/pattern/AddJobView.dart';
import 'package:icati_app/module/jobvacancy/addJob/pattern/AddJobWidgets.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddJobVacancy extends StatefulWidget {
  @override
  _AddJobVacancyState createState() => _AddJobVacancyState();
}

class _AddJobVacancyState extends State<AddJobVacancy> implements AddJobView {
  AddJobPresenter _addJobPresenter;
  static final _formKey = new GlobalKey<FormState>();

  TextEditingController _companyNameCont = TextEditingController();
  TextEditingController _jobPositionCont = TextEditingController();
  TextEditingController _jobInfoCont = TextEditingController();
  TextEditingController _dateStartCont = TextEditingController();
  TextEditingController _dateEndCont = TextEditingController();
  TextEditingController _responsibleNameCont = TextEditingController();
  TextEditingController _responsibleHpCont = TextEditingController();
  TextEditingController _responsibleEmailCont = TextEditingController();

  BaseData _baseData =
      BaseData(isSaving: false, isFailed: false, autoValidate: false);
  SharedPreferences _prefs;

  File _fileImage;
  int _fileLength;

  String _currentProvince, _currentCity, _currentJobField;

  List _dataProvince, _dataCity, _dataJobField;

  Member _member = Member();
  Job _job = Job();

  @override
  void initState() {
    _addJobPresenter = new AddJobPresenter();
    _addJobPresenter.attachView(this);
    _addJobPresenter.getProvince();
    _addJobPresenter.getJobField();
    _getCredential();
    super.initState();
  }

  _getCredential() async {
    if (!mounted) return;
    _prefs = await SharedPreferences.getInstance();
    _baseData.isLogin =
        _prefs.containsKey("IS_LOGIN") ? _prefs.getBool("IS_LOGIN") : false;
    if (_baseData.isLogin) {
      setState(() {
        final user = _prefs.getString("member");
        final List data = jsonDecode(user);
        _member.mName = data[0]['mName'].toString();
        _member.mHp = data[0]['mHp'].toString();
        _member.mEmail = data[0]['mEmail'].toString();

        //inisialisai data penanggung jawab
        _responsibleNameCont.text = _member.mName;
        if (_member.mHp.substring(0, 2) == "62") {
          String newString =
              _member.mHp.replaceAll(_member.mHp.substring(0, 2), "0");
          _responsibleHpCont.text = newString;
        } else {
          _responsibleHpCont.text = _member.mHp;
        }
        _responsibleEmailCont.text = _member.mEmail;
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
                    children: <Widget>[
                      SizedBox(height: height * ScreenUtil().setSp(.08)),
                      Container(
                        width: ScreenUtil().setSp(70),
                        height: ScreenUtil().setSp(70),
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xffCCC9DC).withOpacity(0.5),
                                  Color(0xff0094C6).withOpacity(0.5)
                                ])),
                        child: Center(
                          child: Image.asset("assets/images/logo_ts_red.png",
                              width: ScreenUtil().setSp(50.sp),
                              height: ScreenUtil().setSp(50)),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setSp(10.sp)),
                      Text("Formulir Pendaftaran Lowongan Kerja",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline1),
                      SizedBox(height: ScreenUtil().setSp(15)),
                      Form(
                        key: _formKey,
                        // autovalidate: _baseData.autoValidate,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setSp(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: ScreenUtil().setSp(5)),
                              Material(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Container(
                                  padding:
                                      EdgeInsets.all(ScreenUtil().setSp(10)),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Colors.black38, width: 1)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      Center(
                                        child: Text("DATA PERUSAHAAN",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2),
                                      ),
                                      SizedBox(height: ScreenUtil().setSp(20)),
                                      AddJobWidgets().displayJobCompanyPhoto(
                                          context,
                                          _showChoiceDialog,
                                          _fileImage,
                                          _baseData.isFailed),
                                      SizedBox(height: ScreenUtil().setSp(15)),
                                      AddJobWidgets().displayJobCompanyName(
                                          context, _companyNameCont),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setSp(10)),
                              Material(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Container(
                                  padding:
                                      EdgeInsets.all(ScreenUtil().setSp(10)),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Colors.black38, width: 1)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      Center(
                                        child: Text("DATA LOWONGAN KERJA",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2),
                                      ),
                                      SizedBox(height: ScreenUtil().setSp(20)),
                                      AddJobWidgets().displayJobProvince(
                                          context,
                                          _currentProvince,
                                          _selectProvince,
                                          _dataProvince),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddJobWidgets().displayJobCity(context,
                                          _currentCity, _selectCity, _dataCity),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddJobWidgets().displayJobNamePosition(
                                          context, _jobPositionCont),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddJobWidgets().displayJobFiled(
                                          context,
                                          _currentJobField,
                                          _selectJobField,
                                          _dataJobField),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddJobWidgets().displayJobInfo(
                                          context, _jobInfoCont),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddJobWidgets().displayJobStartShow(
                                          context, _dateStartCont),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddJobWidgets().displayJobEndShow(
                                          context, _dateEndCont)
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setSp(10)),
                              Material(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Container(
                                  padding:
                                      EdgeInsets.all(ScreenUtil().setSp(10)),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Colors.black38, width: 1)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      Center(
                                        child: Text(
                                            "DATA PENANGGUNG JAWAB LOWONGAN KERJA",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                            textAlign: TextAlign.center),
                                      ),
                                      SizedBox(height: ScreenUtil().setSp(20)),
                                      AddJobWidgets().displayJobResponsibleName(
                                          context, _responsibleNameCont),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddJobWidgets().displayJobResponsibleHp(
                                          context, _responsibleHpCont),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddJobWidgets()
                                          .displayJobResponsibleEmail(
                                              context, _responsibleEmailCont),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setSp(10)),
                              !_baseData.isSaving
                                  ? Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: ElevatedButton(
                                              onPressed: _addJob,
                                              style: ElevatedButton.styleFrom(
                                                  primary: Theme.of(context)
                                                      .buttonColor,
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  )),
                                              child: Text("TAMBAH",
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                        ),
                                      ],
                                    )
                                  : BaseView().displayLoadingScreen(context,
                                      color: Theme.of(context).buttonColor),
                              SizedBox(height: ScreenUtil().setSp(10)),
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

  void _addJob() async {
    setState(() {
      _baseData.isSaving = true;
      FocusScope.of(context).requestFocus(FocusNode());
    });
    if (_formKey.currentState.validate() && _fileImage != null) {
      _formKey.currentState.save();

      _job.pic = _fileImage;
      _job.picLength = _fileLength;
      _job.companyName = _companyNameCont.text;
      _job.provinsiId = _currentProvince;
      _job.penempatan = _currentCity;
      _job.title = _jobPositionCont.text;
      _job.bidang = _currentJobField;
      _job.desc = _jobInfoCont.text;
      _job.dateTime = _dateStartCont.text;
      _job.dateTimeEnd = _dateEndCont.text;
      _job.cpName = _responsibleNameCont.text;
      _job.cpHp = _responsibleHpCont.text;
      _job.cpEmail = _responsibleEmailCont.text;

      print("data add job");
      print(_job.toAddJobMap());
      _addJobPresenter.addJob(_job);
    } else {
      setState(() {
        _baseData.autoValidate = true;
        _baseData.isFailed = true;
        _baseData.isSaving = false;
      });
    }
  }

  void _selectCity(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentCity = value;
      print("current kabupaten select " + _currentCity);
    });
  }

  void _selectProvince(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentProvince = value;
      print("current provinsi select " + _currentProvince);
      if (_currentProvince != null) {
        this._currentCity = null;
        _addJobPresenter.getCity(_currentProvince);
      }
    });
  }

  void _selectJobField(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentJobField = value;
      print("current job field select " + _currentJobField);
    });
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            title: Text(
              "Pilih dari :",
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(color: Colors.black),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.image),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20.0),
                    onTap: () {
                      uploadImage(context, ImageSource.gallery);
                    },
                    title: Text("Galeri",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontSize: 12.5, color: Colors.black)),
                  ),
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.camera),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20.0),
                    onTap: () {
                      uploadImage(context, ImageSource.camera);
                    },
                    title: Text("Kamera",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontSize: 12.5, color: Colors.black)),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future uploadImage(BuildContext context, ImageSource source) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();

    if (statuses[Permission.camera] == PermissionStatus.granted &&
        statuses[Permission.storage] == PermissionStatus.granted) {
      var imageFile = await ImagePicker()
          .getImage(source: source, maxHeight: 480, maxWidth: 640);

      var _image =
          await FlutterExifRotation.rotateAndSaveImage(path: imageFile.path);

      final length = await _image.length();
      setState(() {
        _fileImage = _image;
        _fileLength = length;
      });
      Navigator.of(context).pop();
    } else if (statuses[Permission.camera] != PermissionStatus.granted &&
        statuses[Permission.storage] != PermissionStatus.granted) {
      BaseFunction().displayToast('Akses kamera dan penyimpanan diperlukan');
      Navigator.of(context).pop();
    } else if (statuses[Permission.camera] != PermissionStatus.granted) {
      BaseFunction().displayToast('Akses kamera diperlukan untuk fitur ini');
      Navigator.of(context).pop();
    } else if (statuses[Permission.storage] != PermissionStatus.granted) {
      BaseFunction().displayToast('Akses penyimpanan diperlukan');
      Navigator.of(context).pop();
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
          _currentProvince = "0";
          // _currentProvince = _dataProvince
          //     .where((element) => element['provinsiName'].toString() == "RIAU")
          //     .first['provinsiId']
          //     .toString();
          print("ini provinsiId " + _currentProvince);

          if (_currentProvince != null) {
            _addJobPresenter.getCity(_currentProvince);
          }
        }
      });
    }
  }

  @override
  onFailJobField(Map data) {
    if (this.mounted) {
      setState(() {
        _dataJobField = data['errorMessage'];
        print("ini bidang " + _dataJobField.toString());
      });
    }
  }

  @override
  onSuccessJobField(Map data) {
    if (this.mounted) {
      setState(() {
        _dataJobField = data['message'];
        print("ini bidang " + _dataJobField.toString());
      });
    }
  }

  @override
  onFailAddJob(Map data) {
    if (this.mounted) {
      setState(() {
        _baseData.isSaving = false;
      });
      BaseFunction().displayToast(data['errorMessage']);
    }
  }

  @override
  onSuccessAddJob(Map data) {
    if (this.mounted) {
      setState(() {
        _baseData.isSaving = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MenuBar(currentPage: 4)),
          (Route<dynamic> predicate) => false);
    }
  }
}
