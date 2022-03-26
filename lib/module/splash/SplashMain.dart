import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/module/login/Login.dart';
import 'package:icati_app/module/register/Register.dart';
import 'package:location/location.dart' as location;
import 'package:location/location.dart';
// import 'package:permission/permission.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/model/CheckingRequest.dart';
import 'package:icati_app/model/CheckingResponse.dart';
import 'package:icati_app/module/account/edit_email/EditEmailMessage.dart';
import 'package:icati_app/module/forgotpass/ResetPassword.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
import 'package:icati_app/module/splash/pattern/SplashPresenter.dart';
import 'package:icati_app/module/splash/pattern/SplashView.dart';
import 'package:icati_app/module/verifydata/verify_email/EmailVerify.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:uuid/uuid.dart';

class SplashMain extends StatefulWidget {
  @override
  _SplashMainState createState() => _SplashMainState();
}

class _SplashMainState extends State<SplashMain> implements SplashView {
  static final String PLAY_STORE_URL =
      "https://play.google.com/store/apps/details?id=com.icati.icati_app";
  static final String APP_STORE_URL =
      "https://apps.apple.com/us/app/icati-app/id1573697450";
  SplashPresenter splashPresenter;
  String lat = "",
      long = "",
      mId,
      deviceId = "",
      notificationCount = "",
      newNotification = "";
  dynamic page;
  SharedPreferences prefs;
  bool isLogin, isNotification = false;
  List members;

  @override
  void initState() {
    super.initState();
    splashPresenter = new SplashPresenter();
    splashPresenter.attachView(this);
    reqPermission();
    getCredential();
    getDeviceInfo();
    retrieveDynamicLink();
  }

  reqPermission() async {
    // if (Platform.isIOS) {
    //   var permissions = await Permission.getPermissionsStatus([
    //     PermissionName.Location,
    //     PermissionName.Camera,
    //     PermissionName.Storage,
    //     PermissionName.Phone
    //   ]);
    // } else if (Platform.isAndroid) {
    //   var permissions = await Permission.getPermissionsStatus([
    //     PermissionName.Location,
    //     PermissionName.Camera,
    //     PermissionName.Storage,
    //     PermissionName.Phone
    //   ]);
    //   var permissionNames = await Permission.requestPermissions([
    //     PermissionName.Location,
    //     PermissionName.Camera,
    //     PermissionName.Storage,
    //     PermissionName.Phone
    //   ]);
    // }
    getCurrentLocation();
  }

  // getCurrentLocation() async {
  //   var loc = await new Location().getLocation();
  //   if (!mounted) return;
  //   setState(() {
  //     lat = loc.latitude.toString();
  //     long = loc.longitude.toString();
  //   });
  //   await getIndex(lat, long);
  // }

  void getCredential() async {
    prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      initUniLinks();
      setState(() {
        isLogin =
            prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
      });
      // if (isLogin) {
      //   setState(() {
      //     page = MenuBar(currentPage: 0);
      //   });
      // } else {
      //   setState(() {
      //     page = Login();
      //   });
      // }
      page = MenuBar(currentPage: 0);
    }
  }

  Future<Null> initUniLinks() async {
    if (!mounted) return;
    print("unilinks splash");
    try {
      String initialLink = await getInitialLink();
      List dataLink = initialLink.split("/");
      print("isi link: " + dataLink.toString());
      if (dataLink != null) {
        if (dataLink[3] == "member" && dataLink[4] == "reset-password") {
          print("unilinks reset pass");
          setState(() {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      ResetPassword(mId: dataLink[5].toString())),
              (Route<dynamic> predicate) => false,
            );
          });
          // } else if (dataLink[3] == "member" &&
          //     dataLink[4] == "verifikasi-email") {
          //   print("unilinks verify email");
          //   print(dataLink[5].toString());
          //   setState(() {
          //     Navigator.of(context).pushAndRemoveUntil(
          //       MaterialPageRoute(
          //           builder: (context) =>
          //               EmailVerify(mId: dataLink[5].toString())),
          //       (Route<dynamic> predicate) => false,
          //     );
          //   });
        } else if (dataLink[3] == "member" &&
            dataLink[4] == "verifikasi-change-email") {
          print("unilinks verify email change ");
          print(dataLink[5].toString());
          setState(() {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      EditEmailMessage(mId: dataLink[5].toString())),
              (Route<dynamic> predicate) => false,
            );
          });
        } else {
          print("null dataLInk");
        }
      }
    } catch (e) {
      print(e);
      print("No link available");
    }
  }

  getDeviceInfo() async {
    print("call device info");
    var uuid = Uuid();
    prefs = await SharedPreferences.getInstance();
    String token = prefs.containsKey("token") ? prefs.getString("token") : "";
    print("token getDeviceInfo: " + token);
    DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
    // var imei = await ImeiPlugin.getImei();
    var imei = uuid.v4();
    CheckingRequest checkingRequest = CheckingRequest();
    if (prefs.containsKey("member")) {
      final List data = json.decode(prefs.getString("member"));
      checkingRequest.mId = data[0]['mId'];
      checkingRequest.mIdReference = data[0]['mIdReference'];
    } else {
      checkingRequest.mId = 0;
      checkingRequest.mIdReference = "";
    }

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await _deviceInfoPlugin.androidInfo;
      checkingRequest.deviceId = androidDeviceInfo.androidId;
      deviceId = checkingRequest.deviceId;
      print("Device id: ");
      print(deviceId);
      checkingRequest.deviceOsType = "Android";
      checkingRequest.deviceName =
          "${androidDeviceInfo.manufacturer} ${androidDeviceInfo.model}";
      checkingRequest.deviceManufacturer = androidDeviceInfo.manufacturer;
      checkingRequest.deviceModel = androidDeviceInfo.model;
      checkingRequest.deviceSdk = androidDeviceInfo.version.sdkInt.toString();
      checkingRequest.deviceProduct = androidDeviceInfo.product;
      checkingRequest.deviceOsVersion = androidDeviceInfo.version.release;
      checkingRequest.deviceBoard = androidDeviceInfo.board;
      checkingRequest.deviceBrand = androidDeviceInfo.brand;
      checkingRequest.deviceDisplay = androidDeviceInfo.display;
      checkingRequest.deviceHardware = androidDeviceInfo.hardware;
      checkingRequest.deviceHost = androidDeviceInfo.host;
      checkingRequest.deviceSerial = "";
      checkingRequest.deviceType = androidDeviceInfo.type;
      checkingRequest.deviceUser = "";
      checkingRequest.deviceImei = imei;
      checkingRequest.deviceLocationLat = lat != null ? lat : "";
      checkingRequest.deviceLocationLong = long != null ? long : "";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await _deviceInfoPlugin.iosInfo;
      checkingRequest.deviceOsType = "iOS";
      checkingRequest.deviceId = iosDeviceInfo.identifierForVendor;
      deviceId = checkingRequest.deviceId;
      checkingRequest.deviceName = iosDeviceInfo.name;
      checkingRequest.deviceManufacturer = "";
      checkingRequest.deviceModel = iosDeviceInfo.model;
      checkingRequest.deviceSdk = "";
      checkingRequest.deviceProduct = "";
      checkingRequest.deviceOsVersion = iosDeviceInfo.systemVersion;
      checkingRequest.deviceBoard = "";
      checkingRequest.deviceBrand = "";
      checkingRequest.deviceDisplay = "";
      checkingRequest.deviceHardware = "";
      checkingRequest.deviceHost = "";
      checkingRequest.deviceSerial = "";
      checkingRequest.deviceType = "";
      checkingRequest.deviceUser = "";
      checkingRequest.deviceImei = imei;
      checkingRequest.deviceLocationLat = lat != null ? lat : "";
      checkingRequest.deviceLocationLong = long != null ? long : "";
    }
    print("isLogin splash : $isLogin");
    print("isi mid $mId");
    print("lat: $lat");
    print("long: $long");
    //OneSignal.shared.sendTags({"deviceId": deviceId});
    splashPresenter.goToCheckToken(token, checkingRequest);
  }

  getCurrentLocation() async {
    if (!mounted) return;
    bool _serviceEnabled;
    _serviceEnabled = await location.Location().serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.Location().requestService();
      if (!_serviceEnabled) {
        print("Location service disabled.");
        lat = "";
        long = "";
      } else {
        await getPermissionLocation();
      }
    } else {
      await getPermissionLocation();
    }
  }

  getPermissionLocation() async {
    if (mounted) {
      location.PermissionStatus _permissionGranted;
      location.LocationData _locationData;
      _permissionGranted = await location.Location().hasPermission();
      print("Permission location hasPermission?");
      if (_permissionGranted == location.PermissionStatus.denied) {
        _permissionGranted = await location.Location().requestPermission();
        if (_permissionGranted != location.PermissionStatus.granted) {
          print("Permission location denied.");
          lat = "";
          long = "";
        } else {
          print("Permission location granted 2nd time.");
          _locationData = await new location.Location().getLocation();
          lat = _locationData.latitude.toString();
          long = _locationData.longitude.toString();
        }
      } else if (_permissionGranted == location.PermissionStatus.granted) {
        print("Permission location granted.");
        _locationData = await new location.Location().getLocation();
        lat = _locationData.latitude.toString();
        long = _locationData.longitude.toString();
      }

      print("lat: $lat");
      print("long: $long");

      getIndex(lat, long);
    }
  }

  Future<void> retrieveDynamicLink() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null && !isLogin) {
      // page = MenuBar(
      //   currentPage: 0,
      //   type: "dynamicLink",
      // );
      page = Register(
        name: "",
        email: "",
        googleId: "",
        fbId: "",
        appleId: "",
        twitterId: "",
        emailVerification: 'n',
        refcode: deepLink.queryParameters['ref'].toString(),
      );
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => Login()));
      print("ini deepLINK" + deepLink.toString());
    }
  }

  getIndex(String lat, String long) async {
    if (isLogin == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final memberPrefs = prefs.getString("member");
      final List data = jsonDecode(memberPrefs);
      String mid = data[0]['mId'].toString();
      if (this.mounted) {
        setState(() {
          mId = mid;
        });
      }
    }
    if (lat != null || long != null) {
      print("location index");
      print(lat);
      print(long);
      splashPresenter.getIndex(mId == null ? "" : mId, lat, long);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    print("ini shortSide " + shortestSide.toString());
    final bool useMobileLayout = shortestSide < 500;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment,
            children: [
              Container(
                // margin: EdgeInsets.only(top: 2),
                width: MediaQuery.of(context).size.width,
                // width: 201,
                // height: 301,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/sp1.png')
                      // DecorationImage(image: AssetImage('assets/images/splah.jpg')
                      ),
                ),

                // child: Image.asset(
                //     useMobileLayout
                //         ? "assets/images/splash-screen-2.jpg"
                //         : "assets/images/splash-screen-tablet.jpg",
                //     fit: BoxFit.fill)),
              ),
              // Container(
              //     child:
              //         Text("ICATI", style: GoogleFonts.roboto(fontSize: 18))),
              // Container(
              //   child:
              //       Text("印 尼 留 台 校 友 會 聯 合 總 會", style: GoogleFonts.roboto()),
              // )
            ],
          ),
        ));
  }

  @override
  saveToken(CheckingResponse checkingResponse) async {
    prefs = await SharedPreferences.getInstance();
    print("save token");
    prefs.setString("token", checkingResponse.token);
    prefs.setString("deviceid", deviceId);
    if (checkingResponse.status_member == "n") {
      OneSignal.shared.deleteTags(["mId", "deviceId"]);
      prefs.setBool("IS_LOGIN", false);
      prefs.remove('member');
      prefs.remove('miniId');
      page = MenuBar(currentPage: 0);
    }
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => page));
    print(checkingResponse.token);
    print(deviceId);
  }

  @override
  updateNewVersion(CheckingResponse checkingResponse) async {
    print('Update New Version...');
    print(checkingResponse.toMap());
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text("Update Versi Terbaru"),
                content: Text("Versi terbaru aplikasi ICATI "
                    "telah tersedia. Update sekarang di App Store!"),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      BaseFunction().launchURL(APP_STORE_URL);
                    },
                    child: Text("UPDATE SEKARANG"),
                  ),
                ],
              )
            : AlertDialog(
                title: Text("Update Versi Terbaru"),
                content: Text("Versi terbaru aplikasi ICATI "
                    "telah tersedia. Update sekarang di Play Store!"),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      BaseFunction().launchURL(PLAY_STORE_URL);
                    },
                    child: Text("UPDATE SEKARANG"),
                  ),
                ],
              );
      },
    );
  }

  @override
  onFailIndex(Map data) {}

  @override
  onSuccessIndex(Map data) {}

  @override
  onFailCheckNewNotification(Map data) {}

  @override
  onSuccessCheckNewNotification(Map data) {
    if (this.mounted) {
      setState(() {
        newNotification = data['message'];
      });
    }
  }
}
