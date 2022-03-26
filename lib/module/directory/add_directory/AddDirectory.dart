import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/model/Directory.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/directory/add_directory/CategoryDirectory.dart';
import 'package:icati_app/module/directory/add_directory/pattern/AddDirectoryPresenter.dart';
import 'package:icati_app/module/directory/add_directory/pattern/AddDirectoryView.dart';
import 'package:icati_app/module/directory/add_directory/pattern/AddDirectoryWidgets.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDirectory extends StatefulWidget {
  @override
  _AddDirectoryState createState() => _AddDirectoryState();
}

class _AddDirectoryState extends State<AddDirectory>
    implements AddDirectoryView {
  AddDirectoryPresenter _addDirectoryPresenter;
  static final _formKey = new GlobalKey<FormState>();

  TextEditingController _directoryNameCont = TextEditingController();
  TextEditingController _directoryEmailCont = TextEditingController();
  TextEditingController _directoryPhoneCont = TextEditingController();
  TextEditingController _directoryOperationalCont = TextEditingController();
  TextEditingController _directoryWebCont = TextEditingController();
  String type;

  TextEditingController _directoryContactNameCont = TextEditingController();
  TextEditingController _directoryContactPhoneCont = TextEditingController();
  TextEditingController _directoryContactEmailCont = TextEditingController();

  TextEditingController _directoryAddressCont = TextEditingController();

  TextEditingController _directoryDiscountCont = TextEditingController();
  TextEditingController _directoryDiscountTermsCont = TextEditingController();

  TextEditingController _directoryFacebookCont = TextEditingController();
  TextEditingController _directoryWhatsAppCont = TextEditingController();
  TextEditingController _directoryInstagramCont = TextEditingController();
  TextEditingController _directoryLineCont = TextEditingController();
  TextEditingController _directoryYoutubeCont = TextEditingController();
  TextEditingController _directoryTelegramCont = TextEditingController();
  TextEditingController _directoryTwitterCont = TextEditingController();

  BaseData _baseData =
      BaseData(isSaving: false, isFailed: false, autoValidate: false);
  SharedPreferences _prefs;
  File _fileImage;
  int _fileLength;
  Member _member = Member();
  String _currentProvince, _currentCity, _currentCategory;
  List selectedCat = [];
  List _dataProvince, _dataCity, _dataCategory;

  @override
  void initState() {
    _addDirectoryPresenter = new AddDirectoryPresenter();
    _addDirectoryPresenter.attachView(this);
    _addDirectoryPresenter.getProvince();
    _addDirectoryPresenter.getCategoryOptionlist();
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
        _directoryContactNameCont.text = _member.mName;
        if (_member.mHp.substring(0, 2) == "62") {
          String newString =
              _member.mHp.replaceAll(_member.mHp.substring(0, 2), "0");
          _directoryContactPhoneCont.text = newString;
        } else {
          _directoryContactPhoneCont.text = _member.mHp;
        }
        _directoryContactEmailCont.text = _member.mEmail;

        //inisialisasi sosial media
        _directoryFacebookCont.text = 'https://www.facebook.com/';
        _directoryTwitterCont.text = 'https://www.twitter.com/';
        _directoryInstagramCont.text = 'https://www.instagram.com/';
        _directoryYoutubeCont.text = 'https://www.youtube.com/';
        //_directoryWhatsAppCont.text = 'https//:wwww.facebook.com/';
        // _directoryLineCont.text = 'https//:wwww.facebook.com/';
        //_directoryTelegramCont.text = 'https//:wwww.facebook.com/';
      });
    }
  }

  void moveToCategory() async {
    final information = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => CategoryDirectory(
                dataCat: _dataCategory,
                selectedCat: selectedCat,
              )),
    );
    if (information != null && information.toString().isNotEmpty) {
      if (this.mounted) {
        setState(() {
          if (information.length > 0) {
            selectedCat = information;
          }
          print("kategori dipilih " + selectedCat.toString());
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
                              ]),
                        ),
                        child: Center(
                          child: Image.asset("assets/images/logo_ts_red.png",
                              width: ScreenUtil().setSp(50.sp),
                              height: ScreenUtil().setSp(50)),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setSp(10.sp)),
                      Text("Formulir Pendaftaran Usaha (商业登记表)",
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
                                        BorderRadius.all(Radius.circular(10))),
                                child: Container(
                                  padding:
                                      EdgeInsets.all(ScreenUtil().setSp(10)),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color: Colors.black38, width: 1),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      Center(
                                          child: Text("DATA USAHA (数据业务)",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2)),
                                      SizedBox(height: ScreenUtil().setSp(20)),
                                      AddDirectoryWidgets()
                                          .displayDirectoryPhoto(
                                              context,
                                              _showChoiceDialog,
                                              _fileImage,
                                              _baseData.isFailed),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddDirectoryWidgets()
                                          .displayDirectoryName(
                                              context, _directoryNameCont),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      InkWell(
                                        onTap: () {
                                          moveToCategory();
                                        },
                                        child: IgnorePointer(
                                            ignoring: true,
                                            child: selectedCat.length > 0
                                                ? Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text.rich(
                                                          TextSpan(
                                                              text:
                                                                  "Kategori Direktori (目录类别)",
                                                              children: [
                                                                TextSpan(
                                                                    text: "",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red))
                                                              ]),
                                                          style: GoogleFonts
                                                              .roboto(),
                                                        ),
                                                        Wrap(
                                                          direction:
                                                              Axis.horizontal,
                                                          spacing: 5,
                                                          children:
                                                              List.generate(
                                                                  selectedCat
                                                                      .length,
                                                                  (index) =>
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.blue[50],
                                                                            border: Border.all(color: Colors.lightBlueAccent),
                                                                            borderRadius: BorderRadius.all(Radius.circular(30))),
                                                                        padding:
                                                                            EdgeInsets.all(8),
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                5),
                                                                        child: Text(
                                                                            selectedCat[index]['mCatName']
                                                                                .toString(),
                                                                            style: GoogleFonts.roboto(
                                                                                fontSize: 11,
                                                                                fontWeight: FontWeight.w300,
                                                                                color: Colors.black87)),
                                                                      )),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : AddDirectoryWidgets()
                                                    .displayDirectoryCategory(
                                                        context,
                                                        _currentCategory,
                                                        _selectCategory,
                                                        _dataCategory)),
                                      ),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddDirectoryWidgets()
                                          .displayDirectoryEmail(
                                              context, _directoryEmailCont),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddDirectoryWidgets()
                                          .displayDirectoryPhone(
                                              context, _directoryPhoneCont),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddDirectoryWidgets()
                                          .displayDirectoryOperational(context,
                                              _directoryOperationalCont),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddDirectoryWidgets()
                                          .displayDirectoryWebsite(
                                              context, _directoryWebCont),
                                      SizedBox(height: ScreenUtil().setSp(16)),
                                      AddDirectoryWidgets()
                                          .displayDirectoryTypeOption(
                                              context, _onTypeChanged, type),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setSp(10)),
                              Material(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Container(
                                  padding:
                                      EdgeInsets.all(ScreenUtil().setSp(10)),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color: Colors.black38, width: 1),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      Center(
                                        child: Text(
                                            "DATA PEMILIK USAHA (业务数据所有者)",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                            textAlign: TextAlign.center),
                                      ),
                                      SizedBox(height: ScreenUtil().setSp(20)),
                                      AddDirectoryWidgets()
                                          .displayDirectoryContactName(context,
                                              _directoryContactNameCont),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddDirectoryWidgets()
                                          .displayDirectoryContactPhone(context,
                                              _directoryContactPhoneCont),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddDirectoryWidgets()
                                          .displayDirectoryContactEmail(context,
                                              _directoryContactEmailCont),
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
                                        child: Text("ALAMAT USAHA (营业地址)",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2),
                                      ),
                                      SizedBox(height: ScreenUtil().setSp(20)),
                                      AddDirectoryWidgets()
                                          .displayDirectoryAddress(
                                              context, _directoryAddressCont),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddDirectoryWidgets()
                                          .displayDirectoryProvince(
                                              context,
                                              _currentProvince,
                                              _selectProvince,
                                              _dataProvince),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddDirectoryWidgets()
                                          .displayDirectoryCity(
                                              context,
                                              _currentCity,
                                              _selectCity,
                                              _dataCity),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setSp(10)),
                              Material(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Container(
                                  padding:
                                      EdgeInsets.all(ScreenUtil().setSp(10)),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color: Colors.black38, width: 1),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      Center(
                                        child: Text("INFORMASI DISKON (折扣信息)",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2),
                                      ),
                                      SizedBox(height: ScreenUtil().setSp(20)),
                                      AddDirectoryWidgets()
                                          .displayDirectoryDiscount(
                                              context, _directoryDiscountCont),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddDirectoryWidgets()
                                          .displayDirectoryDiscountTerms(
                                              context,
                                              _directoryDiscountTermsCont),
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
                                        child: Text("Sosial Media (媒体社交)",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2),
                                      ),
                                      SizedBox(height: ScreenUtil().setSp(20)),
                                      AddDirectoryWidgets()
                                          .displayDirectorySocialMedia(context,
                                              controller:
                                                  _directoryFacebookCont,
                                              labelText: "Facebook",
                                              prefixIcon:
                                                  FontAwesomeIcons.facebook),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddDirectoryWidgets()
                                          .displayDirectorySocialMedia(context,
                                              controller:
                                                  _directoryWhatsAppCont,
                                              labelText: "WhatsApp",
                                              prefixIcon:
                                                  FontAwesomeIcons.whatsapp),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddDirectoryWidgets()
                                          .displayDirectorySocialMedia(context,
                                              controller:
                                                  _directoryInstagramCont,
                                              labelText: "Instagram",
                                              prefixIcon:
                                                  FontAwesomeIcons.instagram),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddDirectoryWidgets()
                                          .displayDirectorySocialMedia(context,
                                              controller: _directoryLineCont,
                                              labelText: "Line",
                                              prefixIcon:
                                                  FontAwesomeIcons.line),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddDirectoryWidgets()
                                          .displayDirectorySocialMedia(context,
                                              controller: _directoryYoutubeCont,
                                              labelText: "Youtube",
                                              prefixIcon:
                                                  FontAwesomeIcons.youtube),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddDirectoryWidgets()
                                          .displayDirectorySocialMedia(context,
                                              controller:
                                                  _directoryTelegramCont,
                                              labelText: "Telegram",
                                              prefixIcon: FontAwesomeIcons
                                                  .telegramPlane),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      AddDirectoryWidgets()
                                          .displayDirectorySocialMedia(context,
                                              controller: _directoryTwitterCont,
                                              labelText: "Twitter",
                                              prefixIcon:
                                                  FontAwesomeIcons.twitter),
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
                                              onPressed: _addDirectory,
                                              style: ElevatedButton.styleFrom(
                                                primary: Theme.of(context)
                                                    .buttonColor,
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: Text("TAMBAH (添加)",
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

  void _addDirectory() async {
    setState(() {
      _baseData.isSaving = true;
      FocusScope.of(context).requestFocus(FocusNode());
    });
    if (_formKey.currentState.validate() && _fileImage != null) {
      _formKey.currentState.save();
      Directory _directory = Directory();
      _directory.pic = _fileImage;
      _directory.picLength = _fileLength;
      _directory.merchantName = _directoryNameCont.text;
      _directory.merchantHp = _directoryPhoneCont.text;
      _directory.merchantType = type;
      _directory.provinsiId = _currentProvince;
      _directory.kabupatenId = _currentCity;
      _directory.contactPerson = _directoryContactNameCont.text;
      _directory.contactPersonHp = _directoryContactPhoneCont.text;
      _directory.contactPersonEmail = _directoryContactEmailCont.text;
      _directory.address = _directoryAddressCont.text;
      // _directory.watermark = "";
      // _directory.merchantStatus = "";
      _directory.merchantEmail = _directoryEmailCont.text;
      _directory.merchantDesc = "";
      _directory.merchantSpecialNote = "";
      _directory.merchantDiscount = _directoryDiscountCont.text;
      _directory.merchantDiscountTerms = _directoryDiscountTermsCont.text;
      _directory.merchantWeb = _directoryWebCont.text;
      _directory.merchantOperational = _directoryOperationalCont.text;
      _directory.merchantLine = _directoryLineCont.text;
      _directory.merchantYoutube = _directoryYoutubeCont.text;
      _directory.merchantFacebook = _directoryFacebookCont.text;
      _directory.merchantWhatsApp = _directoryWhatsAppCont.text;
      _directory.merchantTwitter = _directoryTwitterCont.text;
      _directory.merchantInstagram = _directoryInstagramCont.text;
      _directory.merchantTelegram = _directoryTelegramCont.text;
      //_directory.merchantCategory = [int.parse(_currentCategory)];
      List<int> catParents = [];
      List<int> catIds = [];
      for (int i = 0; i < selectedCat.length; i++) {
        if (int.parse(selectedCat[i]['mCatParentId'].toString()) == 0) {
          catIds.add(int.parse(selectedCat[i]['mCatId'].toString()));
        } else {
          if (!catParents
              .contains(int.parse(selectedCat[i]['mCatParentId'].toString()))) {
            catParents
                .add(int.parse(selectedCat[i]['mCatParentId'].toString()));
            catIds.add(int.parse(selectedCat[i]['mCatParentId'].toString()));
          }
          catIds.add(int.parse(selectedCat[i]['mCatId'].toString()));
        }
      }
      _directory.merchantCategory = catIds;
      print("ini id kategori " + catIds.toString());
      print("data add job");
      print(_directory.toAddDirectory());
      _addDirectoryPresenter.addDirectory(_directory);
    } else {
      setState(() {
        _baseData.autoValidate = true;
        _baseData.isFailed = true;
        _baseData.isSaving = false;
      });
    }
  }

  void _onTypeChanged(value) {
    setState(() {
      type = value;
    });
    _formKey.currentState.validate();
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
        _currentCity = null;
      }
    });
    _addDirectoryPresenter.getCity(this._currentProvince);
  }

  void _selectCategory(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentCategory = value;
      print("current category select " + _currentCategory);
      bool validate = _formKey.currentState.validate();
    });
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            title: Text(
              "Pilih dari (从中选择):",
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
                    title: Text("Galeri (画廊)",
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
                    title: Text("Kamera (相机)",
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
        // if (_dataProvince != null) {
        //   // _currentProvince = _dataProvince
        //   //     .where((element) => element['provinsiName'].toString() == "RIAU")
        //   //     .first['provinsiId']
        //   //     .toString();
        //   // print("ini provinsiId " + _currentProvince);
        //
        //   if (this._currentProvince != null) {
        //     _addDirectoryPresenter.getCity(this._currentProvince);
        //   }
        // }
      });
    }
  }

  @override
  onFailAddDirectory(Map data) {
    if (this.mounted) {
      setState(() {
        _baseData.isSaving = false;
      });
      BaseFunction().displayToast(data['errorMessage']);
    }
  }

  @override
  onSuccessAddDirectory(Map data) {
    if (this.mounted) {
      setState(() {
        _baseData.isSaving = false;
      });
      BaseFunction().displayToast(data['message']);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MenuBar(currentPage: 3)),
          (Route<dynamic> predicate) => false);
    }
  }

  @override
  onFailCategoryOption(Map data) {}

  @override
  onSuccessCategoryOption(Map data) {
    if (this.mounted) {
      setState(() {
        _dataCategory = data['message'];
      });
    }
  }
}
