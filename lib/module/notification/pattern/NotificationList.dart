import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/menubar/PushNavigation.dart';

class NotificationList extends StatelessWidget {
  final List data;
  final bool isFailed;
  final String errorMessage;

  final Member member;
  final List dataLocation;
  final String shiftId;
  final Function onReadNotification;
  final Function onRefresh;

  NotificationList({
    this.data,
    this.isFailed,
    this.errorMessage,
    this.member,
    this.dataLocation,
    this.shiftId,
    this.onReadNotification,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      return ListView.separated(
        scrollDirection: Axis.vertical,
        itemCount: data.length,
        separatorBuilder: (context, i) {
          return Divider(height: 0);
        },
        itemBuilder: (context, i) {
          bool isRead;
          if (data[i]['notificationReadId'].toString().isEmpty) {
            isRead = false;
          } else {
            List readEmployeeId = jsonDecode(data[i]['notificationReadId']);
            if (readEmployeeId
                .where((element) => element == member.mId)
                .toList()
                .isNotEmpty) {
              isRead = true;
            } else {
              isRead = false;
            }
          }
          return Column(
            children: <Widget>[
              _showDate(data, i)
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(5, 129, 174, 1)),
                            child: Text(
                              BaseFunction().convertToDate(
                                data[i]['notificationSent'],
                                'd MMMM yyyy',
                              ),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "roboto"),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              Ink(
                color: isRead ? Colors.grey[300] : Colors.white,
                child: ListTile(
                  onTap: () async {
                    await onReadNotification(
                        member.mId, data[i]['notificationId'].toString());
                    onRefresh();
                    if (data[i]['notificationAppsPage'].toString().isNotEmpty &&
                        data[i]['notificationPage'] == 'y') {
                      List<String> notifData =
                          data[i]['notificationAppsPage'].toString().split(":");
                      print(notifData);
                      PushNavigation().pushNavigate(
                          context, notifData[0], notifData[1], member.mId);
                    }
                  },
                  contentPadding:
                      EdgeInsets.only(left: 16, right: 16, bottom: 5, top: 10),
                  title: Text(
                    data[i]['notificationTitle'],
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  dense: true,
                  selected: isRead,
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: HtmlWidget(
                      data[i]['notificationContent'],
                      textStyle: TextStyle(color: Colors.black, height: 1.5),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      if (isFailed) {
        return Stack(
          children: <Widget>[
            ListView(children: <Widget>[]),
            Center(
                child:
                    Text(errorMessage, style: TextStyle(color: Colors.grey))),
          ],
        );
      } else {
        return BaseView().displayLoadingScreen(context, color: Colors.blueGrey);
      }
    }
  }

  bool _showDate(List data, int index) {
    if (data.length > 1) {
      if (index == 0) {
        return true;
      }
      final String dateRecentIndex = BaseFunction()
          .convertToDate(data[index]['notificationSent'], 'd MMMM yyyy');
      final String datePrev = BaseFunction()
          .convertToDate(data[index - 1]['notificationSent'], 'd MMMM yyyy');
      if (dateRecentIndex == datePrev) {
        return false;
      }
      return true;
    }
    return true;
  }
}
