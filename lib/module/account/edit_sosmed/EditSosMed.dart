import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/account/edit_sosmed/pattern/EditSosMedPresenter.dart';
import 'package:icati_app/module/account/edit_sosmed/pattern/EditSosMedView.dart';
import 'package:icati_app/module/account/edit_sosmed/pattern/EditSosMedWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditSosMed extends StatefulWidget {
  @override
  _EditSosMedState createState() => _EditSosMedState();
}

class _EditSosMedState extends State<EditSosMed> implements EditSosMedView {
  EditSosMedPresenter _editSosMedPresenter;
  final _formKey = GlobalKey<FormState>();

  BaseData _baseData = BaseData(
      isSaving: false,
      showCursor: false,
      isCheckedWa: false,
      isCheckedEmail: false);

  List _dataMedia;
  Member _member = Member();

  @override
  void initState() {
    super.initState();
    _editSosMedPresenter = new EditSosMedPresenter();
    _editSosMedPresenter.attachView(this);
    _getCredential();
  }

  _getCredential() async {
    if (!mounted) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _baseData.isLogin =
        prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
    if (_baseData.isLogin) {
      setState(() {
        final user = prefs.getString("member");
        final List data = jsonDecode(user);
        _member.mId = data[0]['mId'].toString();
      });
      _editSosMedPresenter.getSocialMedia(_member.mId);
    }
  }

  TextEditingController _fbCont = TextEditingController();
  TextEditingController _twitterCont = TextEditingController();
  TextEditingController _igCont = TextEditingController();
  TextEditingController _youtubeCont = TextEditingController();
  TextEditingController _linkedInCont = TextEditingController();
  TextEditingController _tikTokCont = TextEditingController();
  TextEditingController _webCont = TextEditingController();
  TextEditingController _bioCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          titleSpacing: 0,
          title: Text("UBAH SOSIAL MEDIA",
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Media Sosial",
                  style: Theme.of(context).textTheme.headline2,
                ),
                SizedBox(height: 10),
                EditSosMedWidgets().socialField(
                    context,
                    _fbCont,
                    "Facebook",
                    FontAwesomeIcons.facebook,
                    _baseData.showCursor,
                    _onTapField),
                SizedBox(height: 10),
                EditSosMedWidgets().socialField(
                    context,
                    _twitterCont,
                    "Twitter",
                    FontAwesomeIcons.twitter,
                    _baseData.showCursor,
                    _onTapField),
                SizedBox(height: 10),
                EditSosMedWidgets().socialField(
                    context,
                    _igCont,
                    "Instagram",
                    FontAwesomeIcons.instagram,
                    _baseData.showCursor,
                    _onTapField),
                SizedBox(height: 10),
                EditSosMedWidgets().socialField(
                    context,
                    _youtubeCont,
                    "Youtube",
                    FontAwesomeIcons.youtube,
                    _baseData.showCursor,
                    _onTapField),
                SizedBox(height: 10),
                EditSosMedWidgets().socialField(
                    context,
                    _linkedInCont,
                    "LinkedIn",
                    FontAwesomeIcons.linkedinIn,
                    _baseData.showCursor,
                    _onTapField),
                SizedBox(height: 10),
                EditSosMedWidgets().socialField(context, _tikTokCont, "Tik Tok",
                    FontAwesomeIcons.tiktok, _baseData.showCursor, _onTapField),
                SizedBox(height: 20),
                Text("Info Lain", style: Theme.of(context).textTheme.headline2),
                SizedBox(height: 10),
                EditSosMedWidgets().socialField(context, _webCont, "Website",
                    FontAwesomeIcons.globe, _baseData.showCursor, _onTapField),
                SizedBox(height: 10),
                EditSosMedWidgets().socialField(
                    context,
                    _bioCont,
                    "Bio",
                    FontAwesomeIcons.infoCircle,
                    _baseData.showCursor,
                    _onTapField),
                SizedBox(height: 20),
                Text(
                  "Pengaturan",
                  style: Theme.of(context).textTheme.headline2,
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _baseData.isCheckedWa,
                        onChanged: (bool) {
                          setState(() {
                            _baseData.isCheckedWa = bool;
                            print("is Checked Wa " +
                                _baseData.isCheckedWa.toString());
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text("Tampilkan WhatsApp Saya",
                          style: Theme.of(context).textTheme.bodyText2),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _baseData.isCheckedEmail,
                        onChanged: (bool) {
                          setState(() {
                            _baseData.isCheckedEmail = bool;
                            print("is Checked Email " +
                                _baseData.isCheckedEmail.toString());
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text("Tampilkan Email Saya",
                          style: Theme.of(context).textTheme.bodyText2),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                !_baseData.isSaving
                    ? Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).buttonColor,
                                  padding: const EdgeInsets.all(16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              onPressed: _save,
                              //color: Theme.of(context).buttonColor,
                              child: Text("SIMPAN",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    : BaseView().displayLoadingScreen(context,
                        color: Theme.of(context).buttonColor)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save() {
    String wa = "", email = "";
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _baseData.isSaving = true;
      });

      if (_baseData.isCheckedWa == true) {
        wa = 'y';
      } else {
        wa = 'n';
      }

      if (_baseData.isCheckedEmail == true) {
        email = 'y';
      } else {
        email = 'n';
      }

      _member.mId = _member.mId;
      _member.fb = _fbCont.text;
      _member.twitter = _twitterCont.text;
      _member.ig = _igCont.text;
      _member.youtube = _youtubeCont.text;
      _member.linkedIn = _linkedInCont.text;
      _member.tikTok = _tikTokCont.text;
      _member.website = _webCont.text;
      _member.bio = _bioCont.text;
      _member.waShow = wa;
      _member.emailShow = email;

      _editSosMedPresenter.editSocialMedia(_member);
      print("ini edit sosial media " +
          jsonEncode(_member.toEditSosMedMap()).toString());
    } else {
      setState(() {
        _baseData.isSaving = false;
      });
    }
  }

  void _onTapField() {
    setState(() {
      _baseData.showCursor = true;
      print("show cursor " + _baseData.showCursor.toString());
    });
  }

  @override
  onFailEditSosMed(Map data) {}

  @override
  onFailSosMed(Map data) {
    if (this.mounted) {
      setState(() {
        _dataMedia = data['errorMessage'];
      });
    }
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessEditSosMed(Map data) {
    if (this.mounted) {
      setState(() {
        BaseFunction().displayToast(data['message'].toString());
        Navigator.pop(context);
      });
    }
  }

  @override
  onSuccessSosMed(Map data) {
    if (this.mounted) {
      setState(() {
        _dataMedia = data['message'];

        if (_dataMedia != null) {
          _fbCont.text = _dataMedia[0]['mdataFacebook'];
          _twitterCont.text = _dataMedia[0]['mdataTwitter'];
          _igCont.text = _dataMedia[0]['mdataInstagram'];
          _youtubeCont.text = _dataMedia[0]['mdataYoutube'];
          _linkedInCont.text = _dataMedia[0]['mdataLinkedIn'];
          _tikTokCont.text = _dataMedia[0]['mdataTikTok'];
          _webCont.text = _dataMedia[0]['mdataWebsite'];
          _bioCont.text = _dataMedia[0]['mdataBio'];
          if (_dataMedia[0]['mdataWaShow'] == 'y') {
            _baseData.isCheckedWa = true;
          }
          if (_dataMedia[0]['mdataEmailShow'] == 'y') {
            _baseData.isCheckedEmail = true;
          }
        }
      });
    }
  }
}
