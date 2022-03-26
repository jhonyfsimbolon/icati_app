import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/forgotpass/pattern/ForgotPasswordPresenter.dart';
import 'package:icati_app/module/forgotpass/pattern/ForgotPasswordView.dart';
import 'package:icati_app/module/forgotpass/pattern/ForgotPasswordWidgets.dart';
import 'package:icati_app/module/login/Login.dart';

class ResetPassword extends StatefulWidget {
  String mId;

  ResetPassword({this.mId});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword>
    implements ForgotPasswordView {
  ForgotPasswordPresenter _forgotPasswordPresenter;
  static final _formKey = new GlobalKey<FormState>();
  TextEditingController _passwordCont = TextEditingController();
  TextEditingController _rePasswordCont = TextEditingController();

  BaseData _baseData = BaseData(
      isSaving: false, passwordVisible: false, rePasswordVisible: false);

  Member _member = Member();

  @override
  void initState() {
    _forgotPasswordPresenter = new ForgotPasswordPresenter();
    _forgotPasswordPresenter.attachView(this);
    _getCredential();
    super.initState();
  }

  _getCredential() async {
    if (!mounted) return;
    setState(() {
      _member.mId = widget.mId;
    });
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .08),
                    Center(
                      child: Image.asset("assets/images/icon_password.png",
                          width: 70, height: 70),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        Text("ATUR ULANG KATA SANDI",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .copyWith(letterSpacing: 1)),
                        SizedBox(height: 10),
                        Text("Silakan masukan kata sandi Anda yang baru",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(letterSpacing: 1))
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setSp(10)),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ForgotPasswordWidgets().displayInputPassword(
                                context,
                                _passwordCont,
                                _baseData.passwordVisible,
                                _passwordVisibility),
                            SizedBox(height: 10),
                            ForgotPasswordWidgets().displayInputRePass(
                                context,
                                _passwordCont,
                                _rePasswordCont,
                                _baseData.rePasswordVisible,
                                _rePasswordVisibility),
                            SizedBox(height: 20),
                            !_baseData.isSaving
                                ? Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary:
                                                  Theme.of(context).buttonColor,
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              )),
                                          onPressed: _save,
                                          child: Text("SIMPAN",
                                              style: TextStyle(
                                                  color: Colors.white)),
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
                  ],
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

      _forgotPasswordPresenter.resetPass(
          widget.mId, _passwordCont.text, _rePasswordCont.text);
    } else {
      setState(() {
        _baseData.isSaving = false;
      });
    }
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
  onFailForgotPassword(Map data) {}

  @override
  onFailResetPassword(Map data) {
    if (this.mounted) {
      setState(() {
        _baseData.isSaving = false;
      });
      BaseFunction().displayToastLong(data['errorMessage']);
    }
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessForgotPassword(Map data) {}

  @override
  onSuccessResetPassword(Map data) {
    if (this.mounted) {
      setState(() {
        _baseData.isSaving = false;
      });
      BaseFunction().displayToastLong(data['message']);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
        ModalRoute.withName("/"),
      );
    }
  }
}
