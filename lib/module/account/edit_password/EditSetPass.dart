import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/account/edit_password/pattern/EditSetPassPresenter.dart';
import 'package:icati_app/module/account/edit_password/pattern/EditSetPassView.dart';
import 'package:icati_app/module/account/edit_password/pattern/EditSetPassWidgets.dart';

class EditSetPass extends StatefulWidget {
  final String _currentPass;

  EditSetPass(this._currentPass);

  @override
  _EditSetPassState createState() => _EditSetPassState();
}

class _EditSetPassState extends State<EditSetPass> implements EditSetPassView {
  EditSetPassPresenter _editSetPassPresenter;
  static final _formKey = new GlobalKey<FormState>();

  TextEditingController _currentPassCont = TextEditingController();
  TextEditingController _newPassCont = TextEditingController();
  TextEditingController _rePassCont = TextEditingController();

  final FocusNode _currentPassNode = FocusNode();
  final FocusNode _newPassNode = FocusNode();
  final FocusNode _rePassNode = FocusNode();

  bool _currentPassVisible = false,
      _newPassVisible = false,
      _rePassVisible = false;

  Member member = Member();
  BaseData baseData = BaseData(isSaving: false, isLogin: false);

  @override
  void initState() {
    _editSetPassPresenter = new EditSetPassPresenter();
    _editSetPassPresenter.attachView(this);
    super.initState();
    getCredential();
  }

  getCredential() async {
    if (!mounted) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    baseData.isLogin =
        prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
    if (baseData.isLogin == true) {
      final dataMember = prefs.getString("member");
      final List data = jsonDecode(dataMember);
      if (this.mounted) {
        setState(() {
          member.mId = data[0]['mId'].toString();
          print("ini mId " + member.mId);
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
            title: Text("UBAH/ATUR KATA SANDI",
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: <Widget>[
                  widget._currentPass.isNotEmpty
                      ? EditSetPassWidgets().displayEditSetCurrentPass(
                          context,
                          _currentPassCont,
                          _currentPassNode,
                          _newPassNode,
                          _currentPassVisible,
                          _currentPassVisibility)
                      : Container(),
                  SizedBox(height: widget._currentPass.isNotEmpty ? 20 : 0),
                  EditSetPassWidgets().displayEditSetNewPass(
                      context,
                      _newPassCont,
                      _newPassNode,
                      _rePassNode,
                      _newPassVisible,
                      _newPassVisibility),
                  SizedBox(height: 20),
                  EditSetPassWidgets().displayEditSetRePass(
                      context,
                      _newPassCont,
                      _rePassCont,
                      _rePassNode,
                      _rePassVisible,
                      _rePassVisibility),
                  SizedBox(height: 20),
                  !baseData.isSaving
                      ? Row(
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _savePass,
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
                          color: Theme.of(context).buttonColor)
                ],
              ),
            ),
          ),
        ));
  }

  _savePass() async {
    setState(() {
      baseData.isSaving = true;
      FocusScope.of(context).requestFocus(FocusNode());
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      member.mPassword = _currentPassCont.text;
      member.newPass = _newPassCont.text;
      member.confirmPass = _rePassCont.text;

      print("data password");
      print(member.mPassword);
      print(member.newPass);
      print(member.confirmPass);

      _editSetPassPresenter.editSetPass(member);
    } else {
      setState(() {
        baseData.isSaving = false;
      });
    }
  }

  void _currentPassVisibility() {
    if (this.mounted) {
      setState(() {
        this._currentPassVisible = !_currentPassVisible;
      });
    }
  }

  void _newPassVisibility() {
    if (this.mounted) {
      setState(() {
        this._newPassVisible = !_newPassVisible;
      });
    }
  }

  void _rePassVisibility() {
    if (this.mounted) {
      setState(() {
        this._rePassVisible = !_rePassVisible;
      });
    }
  }

  @override
  onFailEditSetPass(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isSaving = false;
      });
      BaseFunction().displayToast(data['errorMessage']);
    }
  }

  @override
  onSuccessEditSetPass(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isSaving = false;
      });
      BaseFunction().displayToast(data['message']);
      Navigator.pop(context);
    }
  }
}
