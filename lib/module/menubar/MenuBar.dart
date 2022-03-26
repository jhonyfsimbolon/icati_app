import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icati_app/module/account/edit_profile/EditProfile.dart';
import 'package:icati_app/module/menubar/menuBurger.dart';
import 'package:icati_app/module/register/Register.dart';
import 'package:icati_app/module/verifydata/verifikasi_email/verifikasi_otp_email.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/module/chat/ChatList.dart';
import 'package:icati_app/module/directory/DirectoryCategory.dart';
import 'package:icati_app/module/explore/Explore.dart';
// import 'package:icati_app/module/jobvacancy/JobList.dart';
import 'package:icati_app/module/menubar/PushNavigation.dart';
// import 'package:icati_app/module/verifydata/verify_member/VerifyMember.dart';
import 'package:icati_app/network/SocketHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/account/Account.dart';
import 'package:icati_app/module/home/Home.dart';
import 'package:icati_app/module/login/Login.dart';
import 'package:icati_app/module/menubar/pattern/MenuBarPresenter.dart';
import 'package:icati_app/module/menubar/pattern/MenuBarView.dart';
// import 'package:icati_app/module/verifydata/verify_email/CompleteEmail.dart';
// import 'package:icati_app/module/verifydata/verify_wa/VerifyWa.dart';
import 'package:icati_app/module/verifydata/verifyhp/VerifyHp.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MenuBar extends StatefulWidget {
  String type = "0";
  MenuBar({this.currentPage, this.indexTab, this.type});

  final int indexTab;
  final int currentPage;

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver
    implements MenuBarView {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController controller;
  static final int TAB_LENGTH = 6;
  int currentPage = 0, unreadNotification = 0;
  MyTabs myHandler;
  BaseData _baseData = BaseData(isLogin: false);
  DateTime currentBackPressTime;
  String title = "",
      page = "",
      notificationCount = "",
      newNotification = "",
      totalUnreadMessage = "";
  Member _member = Member();
  List dataComplete;
  List dataPofile;

  IO.Socket _socket;

  MenuBarPresenter menuBarPresenter;

  static final int EXPLORE = 1;
  static final int CHAT = 2;
  static final int ACCOUNT = 4;

  final List<MyTabs> tabs = [
    new MyTabs(title: "Beranda"),
    new MyTabs(title: "Explore"),
    new MyTabs(title: "Chat"),
    new MyTabs(title: "Direktori"),
    new MyTabs(title: "Akun"),
    new MyTabs(title: "Menu"),
  ];

  @override
  void initState() {
    menuBarPresenter = new MenuBarPresenter();
    menuBarPresenter.attachView(this);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getCredential();
    if (widget.currentPage == null) {
      setState(() {
        currentPage = 0;
      });
    } else {
      setState(() {
        currentPage = widget.currentPage;
      });
    }
    controller = TabController(
        vsync: this, length: TAB_LENGTH, initialIndex: currentPage);
    controller.addListener(_handleTitleSelected);
    myHandler = tabs[currentPage];
  }

  void getCredential() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        _baseData.isLogin =
            prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
        if (_baseData.isLogin) {
          final member = prefs.getString("member");
          final List data = jsonDecode(member);
          _member.mId = data[0]['mId'].toString();
          _member.deviceId = prefs.getString("deviceid").toString();
          _member.kabupatenId = data[0]['kabupatenId'].toString();
          dataPofile = jsonDecode(member);
          menuBarPresenter.getChatNotif(_member.mId, _member.kabupatenId);

          _socket =
              SocketHelper().connectServer(_member.kabupatenId, _member.mId);
          _socket.connect();
          _socket.onConnect((data) => print("connected to socket"));

          _socket.on("receive_message", (data) {
            print("receive message users ");
            if (this.mounted) {
              setState(() {
                menuBarPresenter.getChatNotif(_member.mId, _member.kabupatenId);
              });
            }
          });

          _socket.on("receive_msg", (data) {
            print("receive_msg ");
            if (this.mounted) {
              setState(() {
                menuBarPresenter.getChatNotif(_member.mId, _member.kabupatenId);
              });
            }
          });
        } else {
          // retrieveDynamicLink();
        }
      });
    }
    initOneSignal();
    if (_baseData.isLogin) {
      menuBarPresenter.checkCompleteData(_member.mId);
      menuBarPresenter.checkNewNotification(_member.mId);
    }
  }

  initOneSignal() async {
    print("initing onesignal menubar");
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent notification) async {
      print(
          "OneSignal notification is received ${notification.jsonRepresentation()}");
      //menuBarPresenter.getNewNotification(notificationCount);
    });
    OneSignal.shared.setNotificationOpenedHandler(_handleNotificationOpened);
  }

  void _handleNotificationOpened(OSNotificationOpenedResult result) async {
    print('OneSignal notification is tapped !');
    Map data = result.notification.additionalData;
    String category = result.notification.category;
    print("onesignal category " + category.toString());
    print(result.notification.jsonRepresentation());
    PushNavigation().pushNavigate(
        context, data['page'].toString(), data['id'].toString(), _member.mId);
  }

  onRefresh() {
    print("onRefresh menu bar");
    if (this.mounted) {
      menuBarPresenter.getChatNotif(_member.mId, _member.kabupatenId);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("APP IS RESUMED");
      if (_baseData.isLogin == true) {
        menuBarPresenter.checkCompleteData(_member.mId);
        //
        //menuBarPresenter.memberStatus(mId, deviceId);
      } else {
        retrieveDynamicLink();
      }
    }
  }

  Future<void> retrieveDynamicLink() async {
    // final PendingDynamicLinkData data =
    //     await FirebaseDynamicLinks.instance.getInitialLink();
    // final Uri deepLink = data?.link;

    // if (deepLink != null) {
    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (context) => MenuBar(currentPage: 4)),
    //       (Route<dynamic> predicate) => false);
    //   print("ini deepLINK" + deepLink.toString());
    // }

    FirebaseDynamicLinks.instance.onLink
        .listen(((PendingDynamicLinkData dynamicLink) async {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Register(
                name: "",
                email: "",
                googleId: "",
                fbId: "",
                appleId: "",
                twitterId: "",
                emailVerification: 'n',
                refcode: dynamicLink.link.queryParameters['ref'].toString(),
              )));
    }));
  }

  void _handleTitleSelected() {
    myHandler = tabs[controller.index];
  }

  void handleBottomBarChanged(int currentIndex) async {
    print("currentIndex: " + currentIndex.toString());
    if ((currentIndex == ACCOUNT ||
            currentIndex == EXPLORE ||
            currentIndex == CHAT) &&
        !_baseData.isLogin) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Login()));
    } else {
      setState(() {
        currentPage = currentIndex;
        controller.animateTo(currentIndex);
      });
    }
    if (_baseData.isLogin) {
      await Future.delayed(Duration(milliseconds: 500));
      menuBarPresenter.checkCompleteData(_member.mId);
    }
  }

  confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Container(
          color: Colors.black.withOpacity(0.6),
          child: AlertDialog(
            contentPadding: EdgeInsets.all(3),
            title: Text("Lengkapi Data",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 18)),
            content: Padding(
              padding: const EdgeInsets.only(
                  top: 3, right: 16.0, left: 16, bottom: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "Data anda belum lengkap, apakah ingin melengkapi data? ",
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(fontWeight: FontWeight.w300)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: ScreenUtil().setSp(35),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                padding: EdgeInsets.all(ScreenUtil().setSp(5)),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "BATAL",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          height: ScreenUtil().setSp(35),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).buttonColor,
                                padding: EdgeInsets.all(ScreenUtil().setSp(5)),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditProfile(this.dataPofile),
                                  ));
                            },
                            // logout,
                            child: Text(
                              "YA",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                      fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mainColor,
      key: _scaffoldKey,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Color(0XFF38b5d7),
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     children: <Widget>[
      //       Image(
      //         image: Svg('assets/images/logo_ts_red.svg',
      //             color: Colors.white, size: Size(30,30)),
      //         //color: Colors.red,
      //       ),
      //       SizedBox(width: 8.0),
      //       Text(
      //         "icati Foundation Riau",
      //         style: GoogleFonts.roboto(
      //             fontSize: 14,
      //             fontWeight: FontWeight.w400,
      //             color: Colors.white),
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     _baseData.isLogin
      //         ? IconButton(
      //             icon: Stack(
      //               children: [
      //                 Align(
      //                   alignment: Alignment.center,
      //                   child: Icon(
      //                     unreadNotification != 0
      //                         ? Icons.notifications
      //                         : Icons.notifications_none,
      //                     color: Colors.white,
      //                   ),
      //                 ),
      //                 unreadNotification != 0
      //                     ? Align(
      //                         alignment: Alignment.topRight,
      //                         child: Container(
      //                           decoration: BoxDecoration(
      //                               shape: BoxShape.circle, color: Colors.red),
      //                           padding: EdgeInsets.all(
      //                               unreadNotification < 10 ? 4 : 2),
      //                           child: Text(unreadNotification.toString(),
      //                               style: GoogleFonts.roboto(fontSize: 10)),
      //                         ),
      //                       )
      //                     : Container(),
      //                 unreadNotification != 0
      //                     ? Align(
      //                         alignment: Alignment.topRight,
      //                         child: Container(
      //                           decoration: BoxDecoration(
      //                               shape: BoxShape.circle, color: Colors.red),
      //                           padding: EdgeInsets.all(
      //                               unreadNotification < 10 ? 4 : 2),
      //                           child: Text(unreadNotification.toString(),
      //                               style: GoogleFonts.roboto(fontSize: 10)),
      //                         ),
      //                       )
      //                     : Container()
      //               ],
      //             ),
      //             onPressed: () async {
      //               final information = await Navigator.of(context).push(
      //                 MaterialPageRoute(
      //                   builder: (context) => NotificationMain(),
      //                   settings: RouteSettings(name: "Notification List"),
      //                 ),
      //               );
      //               if (information != null) {
      //                 menuBarPresenter.checkNewNotification(_member.mId);
      //               }
      //             },
      //             tooltip: "Lihat Notifikasi",
      //           )
      //         : Container(),
      //   ],
      // ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          //index: currentPage,
          children: <Widget>[
            Home(
              dataComplete: dataComplete,
              handleBottomBarChanged: handleBottomBarChanged,
              type: widget.type,
            ),
            Explore(),
            ChatList(onRefresh: onRefresh),
            DirectoryCategory(),
            Account(dataComplete: dataComplete),
            MenuBurger(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: handleBottomBarChanged,
        currentIndex: currentPage,
        unselectedLabelStyle: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(fontWeight: FontWeight.w300),
        selectedLabelStyle: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(fontWeight: FontWeight.w300),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedItemColor: Theme.of(context).buttonColor,
        unselectedItemColor: Colors.black54,
        items: [
          BottomNavigationBarItem(
            icon: currentPage == 0
                ? Icon(Icons.home,
                    size: 25, color: Theme.of(context).buttonColor)
                : Icon(Icons.home, size: 25, color: Colors.black54),
            label: tabs[0].title,
          ),
          BottomNavigationBarItem(
            icon: currentPage == 1
                ? Icon(Icons.search,
                    size: 25, color: Theme.of(context).buttonColor)
                : Icon(Icons.search, size: 25, color: Colors.black54),
            label: tabs[1].title,
          ),
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.center,
              overflow: Overflow.visible,
              children: [
                currentPage == 2
                    ? Icon(FontAwesomeIcons.commentDots,
                        size: 25, color: Theme.of(context).buttonColor)
                    : Icon(FontAwesomeIcons.commentDots,
                        size: 25, color: Colors.black54),
                totalUnreadMessage.isNotEmpty &&
                        totalUnreadMessage != '0' &&
                        _baseData.isLogin
                    ? Positioned(
                        right: 0,
                        top: -4,
                        child: Container(
                          decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          constraints:
                              BoxConstraints(minWidth: 14, minHeight: 14),
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            totalUnreadMessage,
                            style: TextStyle(fontSize: 10, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            label: tabs[2].title,
          ),
          BottomNavigationBarItem(
            icon: currentPage == 3
                ? Icon(Icons.folder,
                    size: 25, color: Theme.of(context).buttonColor)
                : Icon(Icons.folder, size: 25, color: Colors.black54),
            label: tabs[3].title,
          ),
          BottomNavigationBarItem(
            icon: currentPage == 4
                ? Icon(Icons.person,
                    size: 25, color: Theme.of(context).buttonColor)
                : Icon(Icons.person, size: 25, color: Colors.black54),
            label: tabs[4].title,
          ),
          BottomNavigationBarItem(
            icon: currentPage == 5
                ? Icon(FontAwesomeIcons.bars,
                    size: 25, color: Theme.of(context).buttonColor)
                : Icon(FontAwesomeIcons.bars, size: 25, color: Colors.black54),
            label: tabs[5].title,
          ),
        ],
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      BaseFunction().displayToast("Tekan sekali lagi untuk keluar");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  onSuccessCheckCompleteData(Map data) {
    print(_member.mId.toString());
    print("COMPLETE DATA " + data['message'][0].toString());
    if (this.mounted) {
      setState(() {
        dataComplete = data['message'];
      });
    }
    if (data['message'][0]['status'] == 'n') {
      OneSignal.shared.deleteTags(["mId", "deviceId"]);
      menuBarPresenter.logout(_member.mId, _member.deviceId);
    } else if (data['message'][0]['email'].isEmpty ||
        data['message'][0]['emailStatus'] == 'n') {
      print("email belum ferivet email");
      print("data compltete data ------" + data['message'].toString());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => VerifikasiOtpEmail(
              dataComplete: data['message'],
              // type: "sendOtpEmail",
            ),
            // builder: (context) => CompleteEmail(dataComplete: data['message']),
          ),
          (Route<dynamic> predicate) => false);
    } else if (data['message'][0]['hp'] == 'n') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyHp(dataComplete: data['message']),
          ),
          (Route<dynamic> predicate) => false);
      // }
      //  else if (data['message'][0]['dataRequireComplete'] == 'n') {
      //   confirmLogout(context);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => EditProfile(this.dataPofile),
      //     ));
      // (Route<dynamic> predicate) => false);
      // } else if (data['message'][0]['wa'] == 'n') {
      //   Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => VerifyWa(),
      //       ),
      //       (Route<dynamic> predicate) => false);
    }
  }

  @override
  onFailCheckCompleteData(Map data) {
    menuBarPresenter.logout(_member.mId, _member.deviceId);
  }

  @override
  onSuccessLogout(Map data) async {
    // var facebookLogin = new FacebookLogin();
    // facebookLogin.logOut();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FacebookAuth.instance.logOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("IS_LOGIN", false);
    prefs.remove('member');
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => MenuBar(currentPage: 0)),
      (Route<dynamic> predicate) => false,
    );
  }

  @override
  onFailLogout(Map data) {
    // TODO: implement onFailLogout
  }

  @override
  onSuccessNewNotification(Map data) {
    if (this.mounted) {
      setState(() {
        unreadNotification = data['message'];
      });
    }
  }

  @override
  onFailNewNotification(Map data) {}

  @override
  onSuccessChatNotif(Map data) {
    if (this.mounted) {
      setState(() {
        totalUnreadMessage = data['message'].toString();
        print("ini total unread message " + totalUnreadMessage);
      });
    }
  }
}

class MyTabs {
  String title;

  MyTabs({this.title});
}
