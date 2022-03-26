import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/model/LoginRequest.dart';
import 'package:icati_app/module/login/pattern/LoginView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class LoginPresenter extends BasePresenter<LoginView> {
  Map data;

  Future loginByGoogle(LoginRequest loginRequest) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.loginByGoogle(loginRequest);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessLoginByGoogle(data) : null;
      } else {
        isViewAttached ? getView().onFailLoginByGoogle(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future loginByFb(LoginRequest loginRequest) async {
    checkViewAttached();
    // try {
    var response = await appDataManager.apiHelper.loginByFb(loginRequest);
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessLoginByFb(data) : null;
    } else {
      isViewAttached ? getView().onFailLoginByFb(data) : null;
    }
    // } catch (e) {
    //   isViewAttached ? getView().onNetworkError() : null;
    // }
  }

  Future loginByTwitter(LoginRequest loginRequest) async {
    checkViewAttached();
    print("Sign in twitter");
    print(loginRequest.name);
    print(loginRequest.email);
    print(loginRequest.twitterId);
    print(loginRequest.deviceId);
    print(loginRequest.lat);
    print(loginRequest.long);
    // try {
    var response = await appDataManager.apiHelper.loginByTwitter(loginRequest);
    data = json.decode(response.body);
    isViewAttached ? getView().onSuccessLoginByTwitter(data) : null;
    // } catch (e) {
    //   isViewAttached ? getView().onNetworkError() : null;
    // }
  }

  Future loginByPassword(LoginRequest loginRequest) async {
    checkViewAttached();
    try {
      var response =
          await appDataManager.apiHelper.loginByPassword(loginRequest);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessLoginByPassword(data) : null;
      } else {
        isViewAttached ? getView().onFailLoginByPassword(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future loginByApple(LoginRequest loginRequest) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.loginByApple(loginRequest);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessLoginByApple(data) : null;
      } else {
        isViewAttached ? getView().onFailLoginByApple(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
