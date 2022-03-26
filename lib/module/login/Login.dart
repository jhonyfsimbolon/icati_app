import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart' as location;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/forgotpass/ForgotPassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/LoadingScreen.dart';
import 'package:icati_app/model/LoginRequest.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/login/pattern/LoginPresenter.dart';
import 'package:icati_app/module/login/pattern/LoginView.dart';
import 'package:icati_app/module/login/pattern/LoginWidgets.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
import 'package:twitter_login/twitter_login.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> implements LoginView {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  static final _formKey = new GlobalKey<FormState>();

  LoginPresenter _loginPresenter;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _emailHpWaCont = TextEditingController();
  TextEditingController _passwordCont = TextEditingController();
  final FocusNode _emailHpWaNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  BaseData baseData = BaseData(isLogin: false, isSaving: false);
  LoginRequest _loginRequest = LoginRequest();
  Member member = Member();
  bool _passwordVisible = false;
  AuthorizationCredentialAppleID _appleAuthorizationCredentialID;

  // static final TwitterLogin twitterLogin = new TwitterLogin(
  //   consumerKey: 'Dtkvhe6TvKFAQWt0DhObuLruf',
  //   consumerSecret: 'h5Yqi4JjEYpFedEjl3TiP6nGSNIuiRBr0p5VWw8NVbZVZj3Qja',
  // );

  @override
  void initState() {
    _loginPresenter = new LoginPresenter();
    _loginPresenter.attachView(this);
    _getCurrentLocation();
    _getCredential();
    super.initState();
  }

  _getCredential() async {
    if (!mounted) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    baseData.isLogin =
        prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
    if (baseData.isLogin == false) {
      print("credential");
      setState(() {
        member.deviceId = prefs.getString("deviceid");
      });
    }
  }

  _getCurrentLocation() async {
    if (!mounted) return;
    bool _serviceEnabled;
    _serviceEnabled = await location.Location().serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.Location().requestService();
      if (!_serviceEnabled) {
        print("Location service disabled.");
        member.lat = "";
        member.long = "";
      } else {
        await _getPermissionLocation();
      }
    } else {
      await _getPermissionLocation();
    }
  }

  _getPermissionLocation() async {
    if (mounted) {
      location.PermissionStatus _permissionGranted;
      location.LocationData _locationData;
      _permissionGranted = await location.Location().hasPermission();
      print("Permission location hasPermission?");
      if (_permissionGranted == location.PermissionStatus.denied) {
        _permissionGranted = await location.Location().requestPermission();
        if (_permissionGranted != location.PermissionStatus.granted) {
          print("Permission location denied.");
          member.lat = "";
          member.long = "";
        } else {
          print("Permission location granted 2nd time.");
          _locationData = await new location.Location().getLocation();
          member.lat = _locationData.latitude.toString();
          member.long = _locationData.longitude.toString();
        }
      } else if (_permissionGranted == location.PermissionStatus.granted) {
        print("Permission location granted.");
        _locationData = await new location.Location().getLocation();
        member.lat = _locationData.latitude.toString();
        member.long = _locationData.longitude.toString();
      }

      print("lat: " + member.lat);
      print("long: " + member.long);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: GestureDetector(
        onTap:
            //  () {},
            () {
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
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * ScreenUtil().setSp(.08)),
                      Center(
                        child: Image.asset("assets/images/lgicati.png",
                            width: ScreenUtil().setSp(200),
                            height: ScreenUtil().setSp(80)),
                      ),
                      SizedBox(height: ScreenUtil().setSp(10)),
                      Text("MASUK",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline1),
                      SizedBox(height: ScreenUtil().setSp(10)),
                      Text("Selamat Datang di ICATI",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline2),
                      SizedBox(height: ScreenUtil().setSp(20)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(20.w)),
                        child: Column(
                          children: [
                            Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                children: <Widget>[
                                  LoginWidgets().displayLoginEmailHpWa(
                                      context,
                                      _emailHpWaCont,
                                      _emailHpWaNode,
                                      _passwordNode),
                                  SizedBox(height: ScreenUtil().setSp(10)),
                                  LoginWidgets().displayLoginPassword(
                                      context,
                                      _passwordCont,
                                      _passwordNode,
                                      _passwordVisible,
                                      _passwordVisibility),
                                ],
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setSp(10)),
                            !baseData.isSaving
                                ? Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed:
                                              //  () {},
                                              _login,
                                          style: ElevatedButton.styleFrom(
                                              primary:
                                                  Theme.of(context).buttonColor,
                                              padding: EdgeInsets.all(
                                                  ScreenUtil().setSp(15)),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              )),
                                          child: Text("MASUK",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button),
                                        ),
                                      ),
                                    ],
                                  )
                                : BaseView().displayLoadingScreen(context,
                                    color: Theme.of(context).buttonColor),
                            SizedBox(height: ScreenUtil().setSp(7)),
                            GestureDetector(
                              onTap:
                                  // () {},
                                  () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ForgotPassword(),
                                  settings:
                                      RouteSettings(name: "Lupa Kata Sandi"),
                                ));
                              },
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Text("Lupa Kata Sandi?",
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setSp(20)),
                            Platform.isAndroid
                                ? Column(
                                    children: [
                                      LoginWidgets().displayLoginDivider(
                                          context, "Masuk Menggunakan Akun"),
                                      // SizedBox(height: ScreenUtil().setSp(3.sp)),
                                      LoginWidgets().displayLoginByAccount(
                                          context,
                                          _logInByGoogle,
                                          _logInByFb,
                                          signInWithApple,
                                          _logInByTwitter),
                                      SizedBox(height: ScreenUtil().setSp(5)),
                                    ],
                                  )
                                : Container(),
                            LoginWidgets().displayLoginDivider(
                                context, "Masuk Menggunakan OTP"),
                            // SizedBox(height: ScreenUtil().setSp(3.sp)),
                            LoginWidgets().displayLoginByOtp(context),
                            SizedBox(height: ScreenUtil().setSp(20)),
                            LoginWidgets().displayRegister(context)
                          ],
                        ),
                      )
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

  _logInByGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount _account;
    try {
      await _googleSignIn.signOut();
      _account = await _googleSignIn.signIn();
      if (_account == null) return null;
      String idToken = (await _account.authentication).idToken;
      print("masuk google");
      final AuthCredential _credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: (await _account.authentication).accessToken,
      );
      UserCredential res = await _auth.signInWithCredential(_credential);
      if (res.user != null) {
        setState(() {
          print("sign google");
          print(_account.email);
          print(idToken);
          try {
            LoadingScreen.showLoadingDialog(context, _keyLoader);
            _loginRequest.email = _account.email;
            _loginRequest.deviceId = member.deviceId;
            _loginRequest.lat = member.lat == null ? "" : member.lat;
            _loginRequest.long = member.long == null ? "" : member.long;
            _loginRequest.name = _account.displayName;
            _loginRequest.googleId = _account.id;
            print("email google " + _loginRequest.email);
            print("nama google " + _loginRequest.name);

            print(_loginRequest.toLoginByGoogleMap());
            _loginPresenter.loginByGoogle(_loginRequest);
          } catch (error) {
            print("error");
          }
        });
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  _logInByFb() async {
    final LoginResult facebookLoginResult = await FacebookAuth.instance.login();
    // var facebookLogin = new FacebookLogin();
    // var facebookLoginResult =
    //     await facebookLogin.logIn(['email', 'public_profile']);

    print(facebookLoginResult.status.toString());

    try {
      print("masuk fb");
      // FacebookAccessToken facebookAccessToken = facebookLoginResult.accessToken;
      final AccessToken facebookAccessToken = facebookLoginResult.accessToken;
      print("token " + facebookAccessToken.token.toString());
      final AuthCredential _credential =
          FacebookAuthProvider.credential(facebookAccessToken.token);
      UserCredential res = await _auth.signInWithCredential(_credential);
      if (res.user != null) {
        setState(() {
          print("sign fb");
          print(res.user.providerData[0].displayName);
          print(res.user.providerData[0].email);
          print(res.user.providerData[0].uid);
          try {
            LoadingScreen.showLoadingDialog(context, _keyLoader);
            _loginRequest.email = res.user.providerData[0].email == null ||
                    res.user.providerData[0].email.isEmpty
                ? ""
                : res.user.providerData[0].email;
            _loginRequest.deviceId = member.deviceId;
            _loginRequest.lat = member.lat;
            _loginRequest.long = member.long;
            _loginRequest.name = res.user.providerData[0].displayName;
            _loginRequest.fbId = res.user.providerData[0].uid;
            print("email fb " + _loginRequest.email);
            print("nama fb " + _loginRequest.name);
            print(_loginRequest.toLoginByFbMap());
            _loginPresenter.loginByFb(_loginRequest);
          } catch (error) {
            print("error");
          }
        });
      }
    } catch (e) {
      print("error e " + e.toString());
      return null;
    }
    await _auth.signOut();
  }

  // _logInByApple() async {
  //   print("masuk apple");
  //   AuthorizationCredentialAppleID _appleAuthorizationCredentialID;
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   // To prevent replay attacks with the credential returned from Apple, we
  //   // include a nonce in the credential request. When signing in in with
  //   // Firebase, the nonce in the id token returned by Apple, is expected to
  //   // match the sha256 hash of `rawNonce`.
  //   final rawNonce = _generateNonce();
  //   final nonce = _sha256ofString(rawNonce);
  //   if (auth.currentUser != null) {
  //     try {
  //       auth.signOut();
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == "requires-recent-login") {
  //         print(
  //             'The user must reauthenticate before this operation can be executed.');
  //       }
  //     }
  //   }
  //   // Request credential for the currently signed in Apple account.
  //   try {
  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //       nonce: nonce,
  //     );
  //
  //     // Create an `OAuthCredential` from the credential returned by Apple.
  //     final oauthCredential = OAuthProvider("apple.com").credential(
  //       idToken: appleCredential.identityToken,
  //       rawNonce: rawNonce,
  //     );
  //
  //     // Sign in the user with Firebase. If the nonce we generated earlier does
  //     // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  //     UserCredential result =
  //         await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  //     //82mza6kbnu@privaterelay.appleid.com
  //     //001730.09db1c67c932429dad0fe62e0d89e689.0651
  //     if (result != null) {
  //       print("sign apple");
  //       try {
  //         LoadingScreen.showLoadingDialog(context, _keyLoader);
  //         setState(() {
  //           _appleAuthorizationCredentialID = appleCredential;
  //         });
  //         _loginRequest.email = appleCredential.email != null ? appleCredential.email : result.user.email;
  //         _loginRequest.appleIdentifier = appleCredential.userIdentifier;
  //         _loginRequest.deviceId = member.deviceId;
  //         _loginRequest.lat = member.lat;
  //         _loginRequest.long = member.long;
  //         //_loginRequest.name = appleCredential.givenName + " " + appleCredential.familyName;
  //         if(result.user.displayName != null){
  //           _loginRequest.name = result.user.displayName.toString();
  //         } else if (appleCredential.givenName != null || appleCredential.familyName != null) {
  //           _loginRequest.name = appleCredential.givenName.toString() + " " + appleCredential.familyName.toString();
  //         } else {
  //           _loginRequest.name = _loginRequest.email.toString();
  //         }
  //         print(_loginRequest.toLoginAppleMap());
  //         _loginPresenter.loginByApple(_loginRequest);
  //
  //       } catch (error) {
  //         Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  //         print("error");
  //       }
  //     }
  //     return result;
  //   } on SignInWithAppleAuthorizationException catch (e) {
  //     switch (e.code) {
  //       case AuthorizationErrorCode.canceled:
  //         print("Sign In Apple is Canceled");
  //         break;
  //       case AuthorizationErrorCode.failed:
  //         print("Sign In Apple is Failed");
  //         break;
  //       case AuthorizationErrorCode.invalidResponse:
  //         print("Sign In Apple is Invalid Response");
  //         break;
  //       case AuthorizationErrorCode.notHandled:
  //         print("Sign In Apple is not handled");
  //         break;
  //       case AuthorizationErrorCode.unknown:
  //         print("Sign In Apple is unknown");
  //         break;
  //       default:
  //         print("Sign In Apple is error not found");
  //         break;
  //     }
  //   } on Exception catch (e) {
  //     print("Error catch");
  //     print(e);
  //   }
  // }

  Future<UserCredential> signInWithApple() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseAuth auth = FirebaseAuth.instance;
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);
    if (auth.currentUser != null) {
      try {
        auth.signOut();
      } on FirebaseAuthException catch (e) {
        if (e.code == "requires-recent-login") {
          print(
              'The user must reauthenticate before this operation can be executed.');
        }
      }
    }
    // Request credential for the currently signed in Apple account.
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      UserCredential result =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      //82mza6kbnu@privaterelay.appleid.com
      //001730.09db1c67c932429dad0fe62e0d89e689.0651
      if (result != null) {
        print("sign apple");
        // try {
        LoadingScreen.showLoadingDialog(context, _keyLoader);
        setState(() {
          _appleAuthorizationCredentialID = appleCredential;
          //Save User Email
          if (appleCredential.email != null) {
            prefs.setString("emailApple", appleCredential.email);
          } else if (result.user.email != null) {
            prefs.setString("emailApple", result.user.email);
          }
          // Save User Name
          if (result.user.displayName != null) {
            prefs.setString("nameApple", result.user.displayName.toString());
          } else if (appleCredential.givenName != null ||
              appleCredential.familyName != null) {
            prefs.setString(
                "nameApple",
                appleCredential.givenName.toString() +
                    " " +
                    appleCredential.familyName.toString());
          } else {
            prefs.setString("nameApple", _loginRequest.email.toString());
          }
          // Save Apple Id
          if (appleCredential.userIdentifier != null) {
            prefs.setString("idApple", appleCredential.userIdentifier);
          }
          _loginRequest.email = prefs.getString("emailApple");
          _loginRequest.name = prefs.getString("nameApple");
          _loginRequest.appleIdentifier = prefs.getString("idApple");
          _loginRequest.deviceId = member.deviceId;
          _loginRequest.lat = member.lat;
          _loginRequest.long = member.long;

          if (_loginRequest.name == null) {
            _loginRequest.name = "";
          }
          if (_loginRequest.email == null) {
            _loginRequest.email = "";
          }
        });
        print(_loginRequest.toLoginAppleMap());
        _loginPresenter.loginByApple(_loginRequest);
        // } catch (error) {
        //   print("error");
        // }
      }
      return result;
    } on SignInWithAppleAuthorizationException catch (e) {
      switch (e.code) {
        case AuthorizationErrorCode.canceled:
          print("Sign In Apple is Canceled");
          break;
        case AuthorizationErrorCode.failed:
          print("Sign In Apple is Failed");
          break;
        case AuthorizationErrorCode.invalidResponse:
          print("Sign In Apple is Invalid Response");
          break;
        case AuthorizationErrorCode.notHandled:
          print("Sign In Apple is not handled");
          break;
        case AuthorizationErrorCode.unknown:
          print("Sign In Apple is unknown");
          break;
        default:
          print("Sign In Apple is error not found");
          break;
      }
    } on Exception catch (e) {
      print("Error catch");
      print(e);
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String _generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _passwordVisibility() {
    if (this.mounted) {
      setState(() {
        this._passwordVisible = !_passwordVisible;
      });
    }
  }

  void _login() {
    setState(() {
      baseData.isSaving = true;
      FocusScope.of(context).requestFocus(FocusNode());
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _loginRequest.email = _emailHpWaCont.text;
      _loginRequest.password = _passwordCont.text;
      _loginRequest.deviceId = member.deviceId;
      _loginRequest.lat = member.lat;
      _loginRequest.long = member.long;

      print(_loginRequest.toLoginByPasswordMap());
      _loginPresenter.loginByPassword(_loginRequest);
    } else {
      setState(() {
        baseData.isSaving = false;
      });
    }
  }

  void _logInByTwitter() async {
    // final TwitterLoginResult result = await twitterLogin.authorize();
    // String newMessage;
    final twitterLogin = new TwitterLogin(
        apiKey: 'ZNcNG0QmNJwTuNHKVqqhKtGLi',
        apiSecretKey: 'Bm2zeECFH8rdKGDnZ0j6SjSnlNpWykBa70uAR1OHbduuht8KCy',
        redirectURI: 'https://icati-45490.firebaseapp.com/__/auth/handler');
    final result = await twitterLogin.loginV2();
    String newMessage = "";

    switch (result.status) {
      //   case TwitterLoginStatus.loggedIn:
      case TwitterLoginStatus.loggedIn:
        //     final AuthCredential credential = TwitterAuthProvider.credential(
        //       accessToken: result.session.token,
        //       secret: result.session.secret,
        //     );
        final AuthCredential credential = TwitterAuthProvider.credential(
            accessToken: result.authToken, secret: result.authTokenSecret);
        //     final auth = await _auth.signInWithCredential(credential);
        final auth = await _auth.signInWithCredential(credential);
        final user = auth.user;
        if (this.mounted) {
          setState(() {
            LoadingScreen.showLoadingDialog(context, _keyLoader);
            _loginRequest.name = user.providerData[0].displayName.toString();
            _loginRequest.email = user.providerData[0].email == null ||
                    user.providerData[0].email == ""
                ? ""
                : user.providerData[0].email;
            _loginRequest.twitterId = result.user.id.toString();
            _loginRequest.deviceId = member.deviceId.toString();
            _loginRequest.lat = member.lat.toString();
            _loginRequest.long = member.long.toString();
          });
        }
        _loginPresenter.loginByTwitter(_loginRequest);
        newMessage = 'Logged in! username: ${result.user.name}';
        break;
      case TwitterLoginStatus.cancelledByUser:
        newMessage = 'Login cancelled by user.';
        if (this.mounted) {
          setState(() {
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          });
        }
        break;
      case TwitterLoginStatus.error:
        newMessage = 'Login error: ${result.errorMessage}';
        if (this.mounted) {
          setState(() {
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          });
        }
        break;
    }
    setState(() {
      baseData.message = newMessage;
      // BaseFunction().displayToastLong(baseData.message);
    });
    // await twitterLogin.l;
  }

  @override
  onSuccessLoginByGoogle(Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (this.mounted) {
      setState(() {
        List dataMember = data['message'];
        prefs.setBool("IS_LOGIN", true);
        prefs.setString("member", jsonEncode(dataMember));
        print("ini get member " + prefs.getString("member").toString());
        OneSignal.shared.sendTags({
          "mId": dataMember[0]['mId'].toString(),
          "deviceId": prefs.getString("deviceid").toString()
        }).then((value) {});
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MenuBar(currentPage: 0),
          ),
          (Route<dynamic> predicate) => false);
    }
  }

  @override
  onSuccessLoginByFb(Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        List dataMember = data['message'];
        prefs.setBool("IS_LOGIN", true);
        prefs.setString("member", jsonEncode(dataMember));
        print("ini get member " + prefs.getString("member").toString());
        OneSignal.shared.sendTags({
          "mId": dataMember[0]['mId'].toString(),
          "deviceId": prefs.getString("deviceid").toString()
        }).then((value) {});
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MenuBar(currentPage: 0),
          ),
          (Route<dynamic> predicate) => false);
    }
  }

  @override
  onSuccessLoginByTwitter(Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("data twitter " + data['message'].toString());
    if (this.mounted) {
      setState(() {
        List dataMember = data['message'];
        prefs.setBool("IS_LOGIN", true);
        prefs.setString("member", jsonEncode(dataMember));
        print("ini get member " + prefs.getString("member").toString());
        OneSignal.shared.sendTags({
          "mId": dataMember[0]['mId'].toString(),
          "deviceId": prefs.getString("deviceid").toString()
        }).then((value) {});
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MenuBar(currentPage: 0),
          ),
          (Route<dynamic> predicate) => false);
    }
  }

  @override
  onFailLoginByTwitter(Map data) {
    if (this.mounted) {
      setState(() {
        BaseFunction().displayToast(data['errorMessage']);
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      });
    }
  }

  @override
  onFailLoginByPassword(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isSaving = false;
      });
      BaseFunction().displayToast(data['errorMessage']);
    }
  }

  @override
  onSuccessLoginByPassword(Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        List dataMember = data['message'];
        prefs.setBool("IS_LOGIN", true);
        prefs.setString("member", jsonEncode(dataMember));
        print("ini get member " + prefs.getString("member").toString());
        OneSignal.shared.sendTags({
          "mId": dataMember[0]['mId'].toString(),
          "deviceId": prefs.getString("deviceid").toString()
        }).then((value) {});
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MenuBar(currentPage: 0),
          ),
          (Route<dynamic> predicate) => false);
    }
  }

  @override
  onNetworkError() {
    BaseFunction()
        .displayToastLong("Connection failed, please try again later");
    if (this.mounted) {
      setState(() {
        baseData.isSaving = false;
      });
    }
  }

  @override
  onSuccessLoginByApple(Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        List dataMember = data['message'];
        prefs.setBool("IS_LOGIN", true);
        prefs.setString("member", jsonEncode(dataMember));
        print("ini get member " + prefs.getString("member").toString());
        OneSignal.shared.sendTags({
          "mId": dataMember[0]['mId'].toString(),
          "deviceId": prefs.getString("deviceid").toString()
        }).then((value) {});
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MenuBar(currentPage: 0),
          ),
          (Route<dynamic> predicate) => false);
    }
  }

  @override
  onFailLoginByGoogle(Map data) {
    if (this.mounted) {
      setState(() {
        BaseFunction().displayToast(data['errorMessage']);
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      });
    }
  }

  @override
  onFailLoginByFb(Map data) {
    if (this.mounted) {
      setState(() {
        BaseFunction().displayToast(data['errorMessage']);
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      });
    }
  }

  @override
  onFailLoginByApple(Map data) {
    if (this.mounted) {
      setState(() {
        BaseFunction().displayToast(data['errorMessage']);
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      });
    }
  }
}
