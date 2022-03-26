import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
import 'package:icati_app/module/verifydata/verify_email/pattern/EmailVerifyPresenter.dart';
import 'package:icati_app/module/verifydata/verify_email/pattern/EmailVerifyView.dart';
import 'package:icati_app/module/verifydata/verify_email/pattern/EmailVerifyWidgets.dart';

class EmailVerify extends StatefulWidget {
  final String mId;

  EmailVerify({this.mId});

  @override
  _EmailVerifyState createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> implements EmailVerifyView {
  EmailVerifyPresenter _emailVerifyPresenter;

  BaseData _baseData = BaseData(isLogin: false, isFailed: false, message: "");
  Member _member = Member();

  @override
  void initState() {
    _emailVerifyPresenter = EmailVerifyPresenter();
    _emailVerifyPresenter.attachView(this);
    super.initState();
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
            onFailEmailVerify({
              "success": false,
              "errorMessage": "Email Anda tidak sama dengan akun Anda saat ini"
            });
          } else {
            _emailVerifyPresenter.getEmailVerify(widget.mId);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _baseData.message.isEmpty
            ? BaseView().displayLoadingScreen(context,
                color: Theme.of(context).buttonColor)
            : _baseData.isFailed
                ? EmailVerifyWidgets()
                    .displayEmailFailed(context, _baseData.message)
                : EmailVerifyWidgets()
                    .displayEmailSuccess(context, _baseData.message));
  }

  @override
  onFailEmailVerify(Map data) async {
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
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessEmailVerify(Map data) async {
    if (this.mounted) {
      setState(() {
        _baseData.isFailed = false;
        _baseData.message = data['message'];
        print("sukses");
      });
      await Future.delayed(Duration(seconds: 5));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MenuBar(currentPage: 0)),
        (Route<dynamic> predicate) => false,
      );
    }
  }

  @override
  onSuccessCompleteData(Map data) {}

  @override
  onFailCompleteData(Map data) {}

  onSuccessCompleteEmail(Map data) {}

  onFailCompleteEmail(Map data) {}
}
