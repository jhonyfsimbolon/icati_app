import 'dart:convert';
import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/home/pattern/HomeView.dart';
import 'package:icati_app/module/login/login_otp_sms/pattern/loginSMSView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class LoginSMSPresenter extends BasePresenter<LoginSMSView> {
  Map data;

  Future loginSMS(String hp, String deviceId, String lat, String long) async {
    checkViewAttached();
    print(hp);
    print(deviceId);
    print(lat);
    print(long);
    // try {
    var response =
        await appDataManager.apiHelper.loginSMS(hp, deviceId, lat, long);
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessLoginSMS(data) : null;
    } else {
      isViewAttached ? getView().onFailLoginSMS(data) : null;
    }
    // } catch (e) {
    //   isViewAttached ? getView().onNetworkError() : null;
    // }
  }

  Future checkLoginSMS(String hp) async {
    checkViewAttached();
    // try {
    var response = await appDataManager.apiHelper.checkHPLoginSMS(hp);
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessCheckLoginSMS(data) : null;
    } else {
      isViewAttached ? getView().onFailCheckLoginSMS(data) : null;
    }
    // } catch (e) {
    //   isViewAttached ? getView().onNetworkError() : null;
    // }
  }
}
