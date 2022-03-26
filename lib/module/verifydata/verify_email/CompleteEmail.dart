import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/verifydata/verify_email/pattern/EmailVerifyPresenter.dart';
import 'package:icati_app/module/verifydata/verify_email/pattern/EmailVerifyView.dart';
import 'package:icati_app/module/verifydata/verify_email/pattern/EmailVerifyWidgets.dart';

class CompleteEmail extends StatefulWidget {
  List dataComplete;

  CompleteEmail({this.dataComplete});

  @override
  _CompleteEmailState createState() => _CompleteEmailState();
}

class _CompleteEmailState extends State<CompleteEmail>
    with WidgetsBindingObserver
    implements EmailVerifyView {
  EmailVerifyPresenter _emailVerifyPresenter;
  final GlobalKey<State> keyLoader = new GlobalKey<State>();
  static final _formKey = new GlobalKey<FormState>();

  TextEditingController emailCont = TextEditingController();
  final FocusNode emailNode = FocusNode();

  BaseData _baseData = BaseData();
  Member _member = Member();

  Duration count;
  Duration interval = Duration(seconds: 1);
  Timer timer;
  String verificationId = "", resendToken = "";
  bool kirim_link = false;

  @override
  void initState() {
    _emailVerifyPresenter = new EmailVerifyPresenter();
    _emailVerifyPresenter.attachView(this);
    getCredential();
    _baseData.isSaving = false;
    _baseData.resendOTP = false;
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("===========masuk sini=========");
    print(state.toString());
    if (state == AppLifecycleState.resumed) {
      print("APP IS RESUMED 1");
      _emailVerifyPresenter.getEmailVerify(_member.mId);
    }
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
        _member.mEmail = data[0]['mEmail'].toString();

        if (widget.dataComplete[0]['email'].isNotEmpty) {
          emailCont.text = widget.dataComplete[0]['email'];
        }
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .08),
                      Center(
                        child: Image.asset("assets/images/icon_email.png",
                            width: 70, height: 70),
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 20, right: 20)),
                          widget.dataComplete[0]['email'].isEmpty
                              ? Text("PENDAFTARAN EMAIL",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(letterSpacing: 1))
                              : widget.dataComplete[0]['emailStatus'] == "n"
                                  ? Text("VERIFIKASI EMAIL ANDA",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .copyWith(letterSpacing: 1))
                                  : Container(),
                          SizedBox(height: 10),
                          widget.dataComplete[0]['email'].isEmpty
                              ? Text(
                                  "Kami akan mengirim link verifikasi ke email Anda "
                                  "setelah pendaftaran berhasil",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(letterSpacing: 1))
                              : widget.dataComplete[0]['emailStatus'] == "n" &&
                                      kirim_link == false
                                  ? Text(
                                      "Silahkan periksa email anda. "
                                      'Jika belum memiliki email Verifikasi, silahkan untuk mengirim ulang.'
                                      '\n Dengan cara menekan tomol di bawah ini.',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(letterSpacing: 1))
                                  : Container()
                          // : widget.dataComplete[0]['emailStatus'] == "n"
                          //     ? Text(
                          //         "Link verifikasi akan dikirim ke email Anda",
                          //         textAlign: TextAlign.center,
                          //         style: Theme.of(context)
                          //             .textTheme
                          //             .headline2
                          //             .copyWith(letterSpacing: 1))
                          //     : Container()
                        ],
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(10)),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              EmailVerifyWidgets()
                                  .displayEmailInput(context, emailCont),
                              SizedBox(height: 5),
                              widget.dataComplete[0]['email'].isNotEmpty
                                  ? Text(
                                      "*Anda dapat mengubah email jika "
                                      "ada kesalahan email",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 11))
                                  : Container(),
                              SizedBox(height: 20),
                              !_baseData.isSaving
                                  ? Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: _sendEmail,
                                            style: ElevatedButton.styleFrom(
                                                primary: Theme.of(context)
                                                    .buttonColor,
                                                padding: EdgeInsets.all(
                                                    ScreenUtil().setSp(15)),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                )),
                                            child: Text("KIRIM LINK VERIFIKASI",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .button),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  _sendEmail() async {
    setState(() {
      _baseData.isSaving = true;
      FocusScope.of(context).requestFocus(FocusNode());
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _emailVerifyPresenter.completeEmail(_member.mId, emailCont.text);
    } else {
      setState(() {
        _baseData.isSaving = false;
      });
    }
  }

  @override
  onNetworkError() {
    BaseFunction()
        .displayToastLong("Connection failed, please try again later");
  }

  onSuccessCompleteEmail(Map data) {
    if (this.mounted) {
      setState(() {
        _baseData.isSaving = false;
        // if(widget.dataComplete[0]['hp'] == 'n'){
        //   Navigator.pushAndRemoveUntil(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => VerifyHp(dataComplete: widget.dataComplete), settings: RouteSettings(name: 'Verifikasi HP')
        //       ),
        //           (Route<dynamic> predicate) => false);
        // } else if (widget.dataComplete[0]['wa'] == 'n') {
        //   Navigator.pushAndRemoveUntil(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => VerifyWa(), settings: RouteSettings(name: 'Verifikasi WA')
        //       ),
        //           (Route<dynamic> predicate) => false);
        // }else {
        //   Navigator.pushAndRemoveUntil(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => MenuBar(currentPage: 0), settings: RouteSettings(name: 'Home')
        //       ),
        //           (Route<dynamic> predicate) => false);
        // }
      });
      BaseFunction().displayToastLong(data['message']);
    }
  }

  onFailCompleteEmail(Map data) {
    if (this.mounted) {
      setState(() {
        _baseData.isSaving = false;
      });
      BaseFunction().displayToastLong(data['errorMessage']);
    }
  }

  @override
  onSuccessCompleteData(Map data) {}

  @override
  onFailCompleteData(Map data) {}

  @override
  onSuccessEmailVerify(Map data) async {
    if (this.mounted) {
      setState(() {
        _baseData.isFailed = false;
        _baseData.message = data['message'];
        print("sukses");
      });
      BaseFunction().displayToastLong(_baseData.message.toString());

      if (_baseData.message.toString() == "Email telah terverifikasi") {
        await Future.delayed(Duration(seconds: 1));
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MenuBar(currentPage: 0)),
          (Route<dynamic> predicate) => false,
        );
      }
    }
  }

  @override
  onFailEmailVerify(Map data) async {
    if (this.mounted) {
      setState(() {
        _baseData.isFailed = true;
        _baseData.message = data['errorMessage'];
        print("fail");
      });

      BaseFunction().displayToastLong(_baseData.message.toString());
      // await Future.delayed(Duration(seconds: 1));
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (context) => MenuBar(currentPage: 0)),
      //   (Route<dynamic> predicate) => false,
      // );
    }
  }
}
