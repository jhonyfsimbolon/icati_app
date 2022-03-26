import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/account/edit_profile/pattern/EditProfilePresenter.dart';
import 'package:icati_app/module/account/edit_profile/pattern/EditProfileView.dart';
import 'package:icati_app/module/account/edit_profile/pattern/EditProfileWidgets.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:icati_app/base/BaseView.dart';

class EditProfile extends StatefulWidget {
  final List dataProfile;

  EditProfile(this.dataProfile);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> implements EditProfileView {
  EditProfilePresenter _editProfilePresenter;
  static final _formKey = new GlobalKey<FormState>();

  // TextEditingController _editJobCont = TextEditingController();
  TextEditingController _editTmpLahirCont = TextEditingController();
  TextEditingController _editAlamatCont = TextEditingController();
  TextEditingController _editNameCont = TextEditingController();
  TextEditingController _editBirthDayCont = TextEditingController();
  TextEditingController _editCodeReference = TextEditingController();
  TextEditingController _editNameMandarinCont = TextEditingController();
  TextEditingController _editUnivCont = TextEditingController();
  TextEditingController _editThnMasukCont = TextEditingController();

  File _fileImage;
  int _fileLength;
  String _oldPicture = "",
      _currentGender,
      _currentReligion,
      _currentBlood,
      _currentProvince,
      _currentCity,
      _currentNegara,
      _currentJob;
  BaseData _baseData =
      BaseData(isSaving: false, isLogin: false, autoValidate: false);
  Member _member = Member();
  List _dataProvince, _dataCity, _dataJob, _dataNegara;

  @override
  void initState() {
    _editProfilePresenter = EditProfilePresenter();
    _editProfilePresenter.attachView(this);
    super.initState();
    getCredential();
    print("ini profile " + widget.dataProfile.toString());

    //initial data edit profile
    // _currentJob = widget.dataProfile[0]['mJob'].toString();
    _editTmpLahirCont.text = widget.dataProfile[0]['mPlaceBirth'];
    _editAlamatCont.text = widget.dataProfile[0]['mAddress'];
    _editNameCont.text = widget.dataProfile[0]['mName'];
    _editCodeReference.text = widget.dataProfile[0]['refCode'];
    _currentGender = widget.dataProfile[0]['mGender'];
    widget.dataProfile[0]['mDir'] == "" || widget.dataProfile[0]['mPic'] == ""
        ? _oldPicture =
            "http://www.icati.or.id/assets/images/account_picture_default.png"
        : _oldPicture = widget.dataProfile[0]['urlSource'] +
            "/" +
            widget.dataProfile[0]['mDir'] +
            "/" +
            widget.dataProfile[0]['mPic'];
    _currentBlood = widget.dataProfile[0]['mBlood'] == null
        ? "U"
        : widget.dataProfile[0]['mBlood'];
    _editBirthDayCont.text = widget.dataProfile[0]['mDob'];
    _currentReligion = widget.dataProfile[0]['mReligion'];
    _editUnivCont.text = widget.dataProfile[0]['mUniversityName'];
    _editThnMasukCont.text =
        widget.dataProfile[0]['mUniversityYear'].toString();
    _editNameMandarinCont.text = widget.dataProfile[0]['mMandarinName'];
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
        _currentProvince = widget.dataProfile[0]['provinsiId'].toString();
        _currentCity = widget.dataProfile[0]['kabupatenId'].toString();
        _currentJob = widget.dataProfile[0]['mJob'].toString();
        _currentNegara = widget.dataProfile[0]['negaraid'].toString();
      });
      _editProfilePresenter.getNegara();
      _editProfilePresenter.getJobType();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          titleSpacing: 0,
          title: Text("UBAH PROFIL",
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
        child: Form(
          key: _formKey,
          // autovalidate: _baseData.autoValidate,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                EditProfileWidgets().displayEditPhoto(
                    context, _showChoiceDialog, _fileImage, _oldPicture),
                SizedBox(height: 20),
                EditProfileWidgets().displayEditName(context, _editNameCont),
                SizedBox(height: 20),
                EditProfileWidgets()
                    .displayEditNameMandarin(context, _editNameMandarinCont),
                SizedBox(height: 20),
                EditProfileWidgets()
                    .displayEditGender(context, _currentGender, _selectGender),
                SizedBox(height: 20),
                EditProfileWidgets().displayEditReligion(
                    context, _currentReligion, _selectReligion),
                SizedBox(height: 20),
                EditProfileWidgets()
                    .displayEditAlamat(context, _editAlamatCont),
                SizedBox(height: 20),
                EditProfileWidgets().displayEditNegara(
                    context, _currentNegara, _selectNegara, _dataNegara),
                SizedBox(height: 20),
                _currentNegara == "100"
                    ? EditProfileWidgets().displayEditProvince(context,
                        _currentProvince, _selectProvince, _dataProvince)
                    : SizedBox(),
                _currentNegara == "100" ? SizedBox(height: 20) : SizedBox(),
                _currentNegara == "100"
                    ? EditProfileWidgets().displayEditCity(
                        context, _currentCity, _selectCity, _dataCity)
                    : SizedBox(),
                _currentNegara == "100" ? SizedBox(height: 20) : SizedBox(),
                EditProfileWidgets()
                    .displayEditBlood(context, _currentBlood, _selectBlood),
                SizedBox(height: 20),
                EditProfileWidgets()
                    .displayTmpLahir(context, _editTmpLahirCont),
                SizedBox(height: 20),
                EditProfileWidgets()
                    .displayBirthDay(context, _editBirthDayCont),
                SizedBox(height: 20),
                EditProfileWidgets().displayEditUniv(context, _editUnivCont),
                SizedBox(height: 20),
                EditProfileWidgets()
                    .displayEditThnMasuk(context, _editThnMasukCont),
                SizedBox(height: 20),
                EditProfileWidgets()
                    .displayEditJob(context, _currentJob, _selectJob, _dataJob),
                SizedBox(height: 20),
                !_baseData.isSaving
                    ? Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveProfile,
                              style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).buttonColor,
                                  padding: const EdgeInsets.all(16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              child: Text("SIMPAN",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    : BaseView().displayLoadingScreen(context,
                        color: Theme.of(context).buttonColor),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _saveProfile() async {
    setState(() {
      _baseData.isSaving = true;
      FocusScope.of(context).requestFocus(FocusNode());
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _member.mId = _member.mId;
      _member.mName = _editNameCont.text;
      _member.mNameMandarin = _editNameMandarinCont.text;
      _member.mGender = _currentGender == null ? "" : _currentGender;
      _member.birthDate = _editBirthDayCont.text;
      _member.mBlood = _currentBlood;
      _member.mReligion = _currentReligion == null ? "" : _currentReligion;
      _member.negaraid = _currentNegara;
      _member.provinsiId = _currentProvince ?? "0";
      _member.kabupatenId = _currentCity ?? "0";
      _member.mNameUniv = _editUnivCont.text;
      _member.mThnMasuk = _editThnMasukCont.text;
      _member.pic = _fileImage;
      _member.picLength = _fileLength;
      _member.referenceNumber = _editCodeReference.text;
      _member.mJob = _currentJob;
      _member.mAlamat = _editAlamatCont.text;
      _member.mTemLahir = _editTmpLahirCont.text;

      print("data edit profile");
      print(_member.toEditProfileMap());
      _editProfilePresenter.editProfile(_member);
    } else {
      setState(() {
        _baseData.isSaving = false;
        _baseData.autoValidate = true;
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

  void _selectNegara(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentNegara = value;
      // print("current negara select " + _currentNegara + ", provinsi " +_currentProvince.toString()+", kabupaten "+_currentCity);
      if (_currentNegara != null) {
        if (_currentNegara == "100") {
          print("proses mengambil data provinsi");
          // this._currentProvince = null;
          // this._currentCity = null;
          _editProfilePresenter.getProvince();
        } else {
          this._currentProvince = "0";
          this._currentCity = "0";
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
      this._currentCity = null;
      this._currentProvince = value;
      print("current provinsi select " + _currentProvince);
      if (_currentProvince != null) {
        print("proses mengambil data kabupaten");
        _editProfilePresenter.getCity(_currentProvince ?? "0");
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

  void _selectJob(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentJob = value;
      print("current job select " + _currentJob);
    });
  }

  void _selectReligion(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentReligion = value;
      print("current religion select " + _currentReligion);
    });
  }

  void _selectBlood(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentBlood = value;
      print("current blood select " + _currentBlood);
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
  onFailEditProfile(Map data) {
    if (this.mounted) {
      setState(() {
        _baseData.isSaving = false;
      });
      BaseFunction().displayToast(data['errorMessage']);
    }
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessEditProfile(Map data) {
    if (this.mounted) {
      // Navigator.pop(context, "sukses");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MenuBar(currentPage: 4)),
          (Route<dynamic> predicate) => false);
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
  onSuccessProvince(Map data) {
    if (this.mounted) {
      setState(() {
        _dataProvince = data['message'];
        if (_dataProvince != null) {
          print("ini provinsiId " + _currentProvince);
        }
        if (_currentProvince != null) {
          _editProfilePresenter.getCity(_currentProvince ?? "0");
        }
      });
    }
    // if (this.mounted) {
    //   setState(() {
    //     _dataProvince = data['message'];
    //     if (_dataProvince != null) {
    //       // _currentProvince = _dataProvince
    //       //     .where((element) =>
    //       //         element['provinsiName'].toString() == "SELURUH INDONESIA")
    //       //     .first['provinsiId']
    //       //     .toString();
    //       int a = 0;
    //       _currentProvince = a.toString();
    //       print("ini provinsiId " + _currentProvince);
    //     }
    //     if (_currentProvince != null) {
    //       print("proses mengambil data kabupaten");
    //       _editProfilePresenter.getCity(_currentProvince);
    //     }
    //   });
    // }
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
        _dataCity = data['message'];
        // if (_dataCity != null) {
        //   _editProfilePresenter.getCity(_currentProvince);
        // }
      });
    }
  }

  @override
  onFailJobType(Map data) {
    // TODO: implement onFailJobType
    throw UnimplementedError();
  }

  @override
  onSuccessJobType(Map data) {
    // TODO: implement onSuccessJobType
    if (this.mounted) {
      setState(() {
        _dataJob = data['message'];
      });
    }
  }

  @override
  onFailNegara(Map data) {
    if (this.mounted) {
      setState(() {
        _dataNegara = data['errorMessage'];
      });
    }
  }

  @override
  onSuccessNegara(Map data) {
    if (this.mounted) {
      setState(() {
        _dataNegara = data['message'];
        _dataProvince = [];
        _dataCity = [];
        if (_dataNegara != null) {
          // _currentNegara = _dataNegara
          //     .where(
          //         (element) => element['negaraName'].toString() == "INDONESIA")
          //     .first['negaraId']
          //     .toString();
          // int a = 0;
          // _currentNegara = a.toString();
          print("ini negaraId " + _currentNegara);
        }
        if (_currentNegara == "100") {
          print("proses mengambil data kabupaten");
          _editProfilePresenter.getProvince();
        } else {
          _dataProvince = [];
          _dataCity = [];
        }
      });
    }
  }
}
