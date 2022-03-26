import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/forgotpass/pattern/ForgotPasswordPresenter.dart';
import 'package:icati_app/module/forgotpass/pattern/ForgotPasswordView.dart';
import 'package:icati_app/module/forgotpass/pattern/ForgotPasswordWidgets.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>
    implements ForgotPasswordView {
  ForgotPasswordPresenter _forgotPasswordPresenter;
  static final _formKey = new GlobalKey<FormState>();
  TextEditingController _emailCont = TextEditingController();

  BaseData _baseData = BaseData(isSaving: false);

  @override
  void initState() {
    _forgotPasswordPresenter = new ForgotPasswordPresenter();
    _forgotPasswordPresenter.attachView(this);
    super.initState();
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
                        Text("LUPA KATA SANDI",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .copyWith(letterSpacing: 1)),
                        SizedBox(height: 10),
                        Text(
                            "Kami akan mengirim link ubah kata sandi ke email Anda",
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
                            ForgotPasswordWidgets()
                                .displaySendEmail(context, _emailCont),
                            SizedBox(height: 5),
                            Text("*Masukan email yang terkait dengan akun Anda",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 11)),
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
                                          onPressed: _send,
                                          child: Text("KIRIM LINK",
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

  void _send() {
    setState(() {
      _baseData.isSaving = true;
      FocusScope.of(context).requestFocus(FocusNode());
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _forgotPasswordPresenter.sendForgotPass(_emailCont.text);
    } else {
      setState(() {
        _baseData.isSaving = false;
      });
    }
  }

  @override
  onFailForgotPassword(Map data) {
    if (this.mounted) {
      setState(() {
        _baseData.isSaving = false;
      });
      BaseFunction().displayToastLong(data['errorMessage']);
    }
  }

  @override
  onFailResetPassword(Map data) {}

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessForgotPassword(Map data) {
    if (this.mounted) {
      BaseFunction().displayToastLong(data['message']);
      Navigator.of(context).pop();
    }
  }

  @override
  onSuccessResetPassword(Map data) {}
}
