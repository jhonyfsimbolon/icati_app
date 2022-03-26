import 'dart:convert';
import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/menubar/pattern/MenuBarView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class MenuBarPresenter extends BasePresenter<MenuBarView> {
  Map data;

  Future checkCompleteData(String mid) async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.checkCompleteData(mid);
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessCheckCompleteData(data) : null;
    } else {
      isViewAttached ? getView().onFailCheckCompleteData(data) : null;
    }
  }

  Future logout(String mId, String deviceId) async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.logout(mId, deviceId);
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessLogout(data) : null;
    } else {
      isViewAttached ? getView().onFailLogout(data) : null;
    }
  }

  Future checkNewNotification(String mid) async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.getNewNotification(mid);
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessNewNotification(data) : null;
    } else {
      isViewAttached ? getView().onFailNewNotification(data) : null;
    }
  }

  Future getChatNotif(String mId, String kabupatenId) async {
    checkViewAttached();
    var response =
        await appDataManager.apiHelper.getChatNotif(mId, kabupatenId);
    print("ini response " + response.toString());
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessChatNotif(data) : null;
    }
  }
}
