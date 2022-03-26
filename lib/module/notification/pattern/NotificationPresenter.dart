import 'dart:convert';
import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

import 'NotificationView.dart';

class NotificationPresenter extends BasePresenter<NotificationView> {
  Map dataNotification, data;

  Future getNotification(String mId) async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.notificationList(mId);
    dataNotification = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessNotification(dataNotification) : null;
    } else {
      isViewAttached ? getView().onFailNotification(dataNotification) : null;
    }
  }

  Future getReadAllNotification(String mId) async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.notificationReadAll(mId);
    dataNotification = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached
          ? getView().onSuccessReadAllNotification(dataNotification)
          : null;
    } else {
      isViewAttached
          ? getView().onFailReadAllNotification(dataNotification)
          : null;
    }
  }

  Future getReadItemNotification(String mId, String notificationId) async {
    checkViewAttached();
    var response = await appDataManager.apiHelper
        .notificationReadItem(mId, notificationId);
    dataNotification = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached
          ? getView().onSuccessReadItemNotification(dataNotification)
          : null;
    } else {
      isViewAttached
          ? getView().onFailReadItemNotification(dataNotification)
          : null;
    }
  }
}
