import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/model/LoginRequest.dart';
import 'package:icati_app/module/login/login_otp_wa/pattern/LoginOtpWaView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class LoginOtpWaPresenter extends BasePresenter<LoginOtpWaView> {
  Map data;

  Future sendLoginOtpWa(String wa) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.sendLoginOtpWa(wa);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("otpWa", response.body);
        isViewAttached ? getView().onSuccessSendOtpWa(data) : null;
      } else {
        isViewAttached ? getView().onFailSendOtpWa(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future loginOtpWa(LoginRequest loginRequest) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.loginOtpWa(loginRequest);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessLoginOtpWa(data) : null;
      } else {
        isViewAttached ? getView().onFailLoginOtpWa(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
