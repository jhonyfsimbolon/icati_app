import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart' as location;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/LoadingScreen.dart';
import 'package:icati_app/model/LoginRequest.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
import 'package:icati_app/module/register/Register.dart';
import 'package:icati_app/module/register/pattern/RegisterPresenter.dart';
import 'package:icati_app/module/register/pattern/RegisterView.dart';
import 'package:icati_app/module/register/pattern/RegisterWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';

class RegisterOption extends StatefulWidget {
  @override
  _RegisterOptionState createState() => _RegisterOptionState();
}

class _RegisterOptionState extends State<RegisterOption>
    implements RegisterView {
  RegisterPresenter _registerPresenter;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  LoginRequest _loginRequest = LoginRequest();

  BaseData _baseData = BaseData(message: "", isLogin: false);
  Member _member = Member();

  String typeRegister = "";

  @override
  void initState() {
    _registerPresenter = new RegisterPresenter();
    _registerPresenter.attachView(this);
    _getCurrentLocation();
    _getCredential();
    super.initState();
  }

  _getCredential() async {
    if (!mounted) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _baseData.isLogin =
        prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
    if (_baseData.isLogin == false) {
      print("credential");
      setState(() {
        _member.deviceId = prefs.getString("deviceid");
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
        _member.lat = "";
        _member.long = "";
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
          _member.lat = "";
          _member.long = "";
        } else {
          print("Permission location granted 2nd time.");
          _locationData = await new location.Location().getLocation();
          _member.lat = _locationData.latitude.toString();
          _member.long = _locationData.longitude.toString();
        }
      } else if (_permissionGranted == location.PermissionStatus.granted) {
        print("Permission location granted.");
        _locationData = await new location.Location().getLocation();
        _member.lat = _locationData.latitude.toString();
        _member.long = _locationData.longitude.toString();
      }

      print("lat: " + _member.lat);
      print("long: " + _member.long);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var widthButton;
    if (shortestSide < 300) {
      widthButton = (MediaQuery.of(context).size.width / 1.3);
      print("<300");
    } else if (shortestSide < 400) {
      print("<400");
      widthButton = (MediaQuery.of(context).size.width / 1.35);
    } else if (shortestSide < 500) {
      print("<500");
      widthButton = (MediaQuery.of(context).size.width / 1.25);
    } else if (shortestSide < 600) {
      print("<600");
      widthButton = (MediaQuery.of(context).size.width / 2.3);
    } else {
      print("else");
      widthButton = (MediaQuery.of(context).size.width / 2.5);
    }
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
                      Text("DAFTAR ANGGOTA",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline1),
                      SizedBox(height: ScreenUtil().setSp(10)),
                      Text("Selamat Datang di ICATI",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline2),
                      SizedBox(height: ScreenUtil().setSp(20)),
                      Container(
                        width: widthButton,
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(10)),
                        child: RegisterWidgets().displaySignInByAccount(
                            context,
                            _signInByGoogle,
                            _signInByFb,
                            _signInByApple,
                            _signInByTwitter,
                            _signInByEmail),
                      ),
                      SizedBox(height: ScreenUtil().setSp(5))
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

  _signInByGoogle() async {
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
      // print(idToken);
      UserCredential res = await _auth.signInWithCredential(_credential);
      if (res.user != null) {
        setState(() {
          print("sign google");
          typeRegister = "google";
          print(_account.email);
          print(idToken);
          try {
            _member.mEmail = _account.email;
            _member.mName = _account.displayName;
            _member.mGoogleId = _account.id;

            print("ini login di register google");
            print(_member.toCheckRegisterMap());
            _registerPresenter.checkRegister(_member);
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

  _signInByFb() async {
    print('-------1-----------');
    // var facebookLogin = new FacebookLogin();
    final LoginResult facebookLogin = await FacebookAuth.instance.login();
    print('-------2-----------');
    // var facebookLoginResult =
    //     await facebookLogin.logIn(['email', 'public_profile']);
    print('-------3-----------');
    // print(facebookLoginResult.status.toString());

    try {
      print("masuk fb");
      print('-------4-----------');
      final AccessToken facebookAccessToken = facebookLogin.accessToken;
      // FacebookAccessToken facebookAccessToken = facebookLoginResult.accessToken;
      print('-------5-----------');
      // print("token " + facebookAccessToken.token.toString());
      print('-------6-----------');
      final AuthCredential _credential =
          FacebookAuthProvider.credential(facebookAccessToken.token);
      print('-------7----------');
      // print('------------login with credenial----------');
      UserCredential res = await _auth.signInWithCredential(_credential);
      print('-------8-----------');
      print(res.user.providerData[0].displayName);
      if (res.user != null) {
        print('-------9-----------');
        setState(() {
          print("sign fb");
          typeRegister = "facebook";
          print(res.user.providerData[0].displayName);
          print(res.user.providerData[0].email);
          print(res.user.providerData[0].uid);
          try {
            print('-------10-----------');
            _member.mEmail = res.user.providerData[0].email == null ||
                    res.user.providerData[0].email.isEmpty
                ? ""
                : res.user.providerData[0].email;
            _member.mName = res.user.providerData[0].displayName;
            _member.mFbId = res.user.providerData[0].uid;

            print("ini login di register facebook");
            print(_member.toCheckRegisterMap());
            _registerPresenter.checkRegister(_member);
          } catch (error) {
            print('-------11-----------');
            print("error");
          }
        });
      } else {
        print('-------12-----------');
        print('-----user nuulll----');
      }
    } catch (e) {
      print('-------13-----------');
      print("error e " + e.toString());
      return null;
    }
    await _auth.signOut();
  }

  _signInByApple() async {
    print("masuk apple");
    AuthorizationCredentialAppleID _appleAuthorizationCredentialID;
    FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
          typeRegister = "apple";
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
          _loginRequest.deviceId = _member.deviceId;
          _loginRequest.lat = _member.lat;
          _loginRequest.long = _member.long;

          if (_loginRequest.name == null) {
            _loginRequest.name = "";
          }
          if (_loginRequest.email == null) {
            _loginRequest.email = "";
          }
        });
        print(_loginRequest.toLoginAppleMap());
        _registerPresenter.loginByApple(_loginRequest);
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

  _signInByTwitter() async {
    final twitterLogin = new TwitterLogin(
        apiKey: 'ZNcNG0QmNJwTuNHKVqqhKtGLi',
        apiSecretKey: 'Bm2zeECFH8rdKGDnZ0j6SjSnlNpWykBa70uAR1OHbduuht8KCy',
        redirectURI: 'https://icati-45490.firebaseapp.com/__/auth/handler');

    final result = await twitterLogin.loginV2();
    String newMessage = "";

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        final AuthCredential credential = TwitterAuthProvider.credential(
            accessToken: result.authToken, secret: result.authTokenSecret);
        final auth = await _auth.signInWithCredential(credential);
        final user = auth.user;
        if (this.mounted) {
          setState(() {
            typeRegister = "twitter";
            _member.mName = user.providerData[0].displayName.toString();
            _member.mEmail = user.providerData[0].email == null ||
                    user.providerData[0].email == ""
                ? ""
                : user.providerData[0].email;
            _member.mTwitterId = result.user.id.toString();

            print("ini login di register twitter " + _member.mEmail);
            if (_member.mEmail != null && _member.mEmail.isNotEmpty) {
              LoadingScreen.showLoadingDialog(context, _keyLoader);
              _registerPresenter.checkRegister(_member);
              newMessage = 'Logged in! username: ${result.user.screenName}';
            } else {
              BaseFunction().displayToast("Email akun twitter Anda tidak "
                  "ditemukan atau akun email Anda belum diverifikasi twitter");
            }
          });
        }
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
            //Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          });
        }
        break;
    }
    setState(() {
      _baseData.message = newMessage;
      BaseFunction().displayToastLong(_baseData.message);
    });
    // await twitterLogin.logOut();
  }

  void _signInByEmail() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Register(
            name: "",
            email: "",
            googleId: "",
            fbId: "",
            appleId: "",
            twitterId: "",
            emailVerification: 'n'),
        settings: RouteSettings(name: "Register")));
  }

  @override
  onFailCheckRegister(Map data) {
    if (this.mounted) {
      if (data['errorMessage'].isNotEmpty) {
        BaseFunction().displayToastLong(data['errorMessage']);
      } else {
        if (typeRegister == "google") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Register(
              name: _member.mName,
              email: _member.mEmail,
              googleId: _member.mGoogleId,
              fbId: "",
              appleId: "",
              twitterId: "",
              emailVerification: 'y',
            ),
            settings: RouteSettings(name: "Register"),
          ));
        } else if (typeRegister == "facebook") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Register(
                  name: _member.mName,
                  email: _member.mEmail,
                  googleId: "",
                  fbId: _member.mFbId,
                  appleId: "",
                  twitterId: "",
                  emailVerification: 'n'),
              settings: RouteSettings(name: "Register")));
        } else if (typeRegister == "twitter") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Register(
                  name: _member.mName,
                  email: _member.mEmail,
                  googleId: "",
                  fbId: "",
                  appleId: "",
                  twitterId: _member.mTwitterId,
                  emailVerification: 'n'),
              settings: RouteSettings(name: "Register")));
        } else if (typeRegister == "apple") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Register(
                  name: _member.mName,
                  email: _member.mEmail,
                  googleId: "",
                  fbId: "",
                  appleId: _member.mAppleId,
                  twitterId: "",
                  emailVerification: 'y'),
              settings: RouteSettings(name: "Register")));
        }
      }
    }
  }

  @override
  onFailCity(Map data) {}

  @override
  onFailProvince(Map data) {}

  @override
  onFailRegister(Map data) {}

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessCheckRegister(Map data) async {
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
  onSuccessCity(Map data) {}

  @override
  onSuccessProvince(Map data) {}

  @override
  onSuccessRegister(Map data) {}

  @override
  onSuccessLoginApple(Map data) async {
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
  onFailLoginApple(Map data) {
    if (this.mounted) {
      setState(() {
        BaseFunction().displayToast(data['errorMessage']);
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      });
    }
  }

  @override
  onFailLoginByPassword(Map data) {
    // TODO: implement onFailLoginByPassword
    throw UnimplementedError();
  }

  @override
  onSuccessLoginByPassword(Map data) {
    // TODO: implement onSuccessLoginByPassword
    throw UnimplementedError();
  }

  @override
  onFailNegara(Map data) {
    // TODO: implement onFailNegara
    throw UnimplementedError();
  }

  @override
  onSuccessNegara(Map data) {
    // TODO: implement onSuccessNegara
    throw UnimplementedError();
  }
}
