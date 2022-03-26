import 'dart:convert';
import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/model/CheckingRequest.dart';
import 'package:icati_app/model/CheckingResponse.dart';
import 'package:icati_app/module/splash/pattern/SplashView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class SplashPresenter extends BasePresenter<SplashView> {
  Map data;

  Future goToCheckToken(String token, CheckingRequest checkingRequest) async {
    checkViewAttached();
    var response =
        await appDataManager.apiHelper.versionChecking(token, checkingRequest);
    print(response.body);
    CheckingResponse checkingResponse =
        CheckingResponse.fromJson(json.decode(response.body));
    print("token: " + checkingResponse.token);
    if (!checkingResponse.force_update) {
      //cek versi
      isViewAttached ? getView().saveToken(checkingResponse) : null;
      print("token berhasil");
    } else {
      isViewAttached ? getView().updateNewVersion(checkingResponse) : null;
      print("token gagal");
    }
  }

  Future getIndex(String mid, String locationLat, String locationLong) async {
    checkViewAttached();
    var response =
        await appDataManager.apiHelper.getIndex(mid, locationLat, locationLong);
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessIndex(data) : null;
      print("index berhasil");
    } else {
      isViewAttached ? getView().onFailIndex(data) : null;
    }
  }

  Future getNewNotification(String notificationCount) async {
    checkViewAttached();
    var response =
        await appDataManager.apiHelper.getNewNotification(notificationCount);
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessCheckNewNotification(data) : null;
    } else {
      isViewAttached ? getView().onFailCheckNewNotification(data) : null;
    }
  }
}
