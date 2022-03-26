import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/account/edit_email/pattern/EditEmailPresenter.dart';
import 'package:icati_app/module/account/edit_email/pattern/EditEmailView.dart';
import 'package:icati_app/module/account/edit_email/pattern/EditEmailWidgets.dart';

class EditEmail extends StatefulWidget {
  final String _currentEmail;

  EditEmail(this._currentEmail);

  @override
  _EditEmailState createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> implements EditEmailView {
  EditEmailPresenter _editEmailPresenter;
  static final _formKey = new GlobalKey<FormState>();

  TextEditingController _editEmailCont = TextEditingController();

  BaseData _baseData = BaseData(isSaving: false);
  Member _member = Member();

  @override
  void initState() {
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
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            titleSpacing: 0,
            title: Text("UBAH EMAIL",
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  EditEmailWidgets()
                      .displayCurrentEmail(context, widget._currentEmail),
                  SizedBox(height: 20),
                  EditEmailWidgets().displayEditEmail(context, _editEmailCont),
                  SizedBox(height: 20),
                  !_baseData.isSaving
                      ? Row(
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: _editEmail,
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).buttonColor,
                                      padding: const EdgeInsets.all(16.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                  child: Text("SIMPAN",
                                      style: TextStyle(color: Colors.white))),
                            ),
                          ],
                        )
                      : BaseView().displayLoadingScreen(context,
                          color: Theme.of(context).buttonColor)
                ],
              ),
            ),
          ),
        ));
  }

  _editEmail() async {
    setState(() {
      _baseData.isSaving = true;
      FocusScope.of(context).requestFocus(FocusNode());
    });
    if (_formKey.currentState.validate()) {
      _editEmailPresenter.sendVerifyEmailChange(
          _member.mId, _editEmailCont.text);
    } else {
      setState(() {
        _baseData.isSaving = false;
      });
    }
  }

  @override
  onFailSendVerifyEmailChange(Map data) {
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
  onSuccessSendVerifyEmailChange(Map data) {
    if (this.mounted) {
      setState(() {
        _baseData.isSaving = false;
        BaseFunction().displayToastLong(data['message']);

        Navigator.pop(context);
      });
    }
  }

  @override
  onFailEditEmail(Map data) {}

  @override
  onSuccessEditEmail(Map data) {}
}
