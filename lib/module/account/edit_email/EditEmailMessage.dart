import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/account/edit_email/pattern/EditEmailPresenter.dart';
import 'package:icati_app/module/account/edit_email/pattern/EditEmailView.dart';
import 'package:icati_app/module/account/edit_email/pattern/EditEmailWidgets.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';

class EditEmailMessage extends StatefulWidget {
  final String mId;

  EditEmailMessage({this.mId});

  @override
  _EditEmailMessageState createState() => _EditEmailMessageState();
}

class _EditEmailMessageState extends State<EditEmailMessage>
    implements EditEmailView {
  EditEmailPresenter _editEmailPresenter;

  BaseData _baseData = BaseData(isLogin: false, isFailed: false, message: "");
  Member _member = Member();

  @override
  void initState() {
    print("masuk edit email message");
    super.initState();
    _editEmailPresenter = EditEmailPresenter();
    _editEmailPresenter.attachView(this);
    _getCredential();
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
          print("ini mId " + _member.mId);
          print("ini widget mId " + widget.mId);

          if (widget.mId != _member.mId) {
            onFailEditEmail({
              "success": false,
              "errorMessage": "Email Anda tidak sama dengan akun Anda saat ini"
            });
          } else {
            if (prefs.containsKey("verifyEmailChange")) {
              final _dataVerifyEmail = prefs.getString("verifyEmailChange");
              final Map _dataVerify = jsonDecode(_dataVerifyEmail);
              List _dataEmail = _dataVerify['verify'];
              print("ini data email " + _dataEmail.toString());
              _editEmailPresenter.editEmail(widget.mId, _dataEmail[0]['email']);
            } else {
              onFailEditEmail({
                "success": false,
                "errorMessage": "Link sudah tidak berlaku"
              });
            }
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _baseData.message.isEmpty
            ? BaseView().displayLoadingScreen(context, color: Colors.black)
            : _baseData.isFailed
                ? EditEmailWidgets()
                    .displayEmailEditFailed(context, _baseData.message)
                : EditEmailWidgets()
                    .displayEmailEditSuccess(context, _baseData.message));
  }

  @override
  onFailEditEmail(Map data) async {
    if (this.mounted) {
      setState(() {
        _baseData.isFailed = true;
        _baseData.message = data['errorMessage'];
        print("fail");
      });
      await Future.delayed(Duration(seconds: 5));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MenuBar(currentPage: 0)),
        (Route<dynamic> predicate) => false,
      );
    }
  }

  @override
  onFailSendVerifyEmailChange(Map data) {}

  @override
  onNetworkError() {
    // ignore: todo
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessEditEmail(Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        _baseData.isFailed = false;
        _baseData.message = data['message'];
        print("sukses");
        prefs.remove('verifyEmailChange');
      });
      await Future.delayed(Duration(seconds: 5));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MenuBar(currentPage: 0)),
        (Route<dynamic> predicate) => false,
      );
    }
  }

  @override
  onSuccessSendVerifyEmailChange(Map data) {}
}
