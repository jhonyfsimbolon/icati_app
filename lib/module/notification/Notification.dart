import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/notification/pattern/NotificationList.dart';
import 'package:icati_app/module/notification/pattern/NotificationPresenter.dart';
import 'package:icati_app/module/notification/pattern/NotificationView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationMain extends StatefulWidget {
  @override
  _NotificationMainState createState() => _NotificationMainState();
}

class _NotificationMainState extends State<NotificationMain>
    implements NotificationView {
  NotificationPresenter _notificationPresenter;
  SharedPreferences prefs;
  List dataNotification, dataProfile;
  BaseData baseData = BaseData();
  Member _member = Member();
  int notificationCount = 0;

  @override
  void initState() {
    baseData.isFailed = false;
    baseData.isLogin = false;
    super.initState();
    _notificationPresenter = new NotificationPresenter();
    _notificationPresenter.attachView(this);
    getCredential();
  }

  void getCredential() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        baseData.isLogin =
            prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
        final member = prefs.getString("member");
        final List data = jsonDecode(member);
        _member.mId = data[0]['mId'].toString();
        _member.deviceId = prefs.getString("deviceid").toString();
      });
      await _notificationPresenter.getNotification(_member.mId);
    }
  }

  Future<Null> onRefresh() async {
    setState(() {
      dataNotification = null;
    });
    await _notificationPresenter.getNotification(_member.mId);
  }

  Future<Null> updateList() async {
    await _notificationPresenter.getNotification(_member.mId);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle appBarTextStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, notificationCount);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Notification", style: appBarTextStyle),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(notificationCount),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            PopupMenuButton<int>(
              onSelected: (result) {
                if (result == 1) {
                  if (!baseData.isFailed) {
                    _notificationPresenter
                        .getReadAllNotification(_member.mId.toString());
                  }
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      // Icon(FontAwesomeIcons.eye, size: 15, color: Colors.black),
                      // SizedBox(width: 5),
                      Text(
                        "Tandai semua dibaca",
                        style: GoogleFonts.roboto(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
              icon: Icon(Icons.more_vert),
              offset: Offset(0, 0),
            )
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: RefreshIndicator(
              onRefresh: onRefresh,
              color: Colors.black,
              child: NotificationList(
                data: dataNotification,
                member: _member,
                isFailed: baseData.isFailed,
                errorMessage: baseData.errorMessage,
                onRefresh: updateList,
                onReadNotification:
                    _notificationPresenter.getReadItemNotification,
              )),
        ),
      ),
    );
  }

  @override
  onSuccessNotification(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isFailed = false;
        dataNotification = data['message'];
      });
    }
  }

  @override
  onFailNotification(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isFailed = true;
        baseData.errorMessage = data['errorMessage'];
      });
    }
  }

  @override
  onSuccessReadAllNotification(Map data) {
    onRefresh();
    BaseFunction().displayToastLong(data['message']);
  }

  @override
  onFailReadAllNotification(Map data) {
    BaseFunction().displayToastLong(data['errorMessage']);
  }

  @override
  onSuccessReadItemNotification(Map data) {}

  @override
  onFailReadItemNotification(Map data) {}
}
