import 'dart:convert';

import 'package:icati_app/module/verifydata/verifikasi_email/pattern/verifikasiOtpEmailView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/model/LoginRequest.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class VerifikasiOtpEmailPresenter
    extends BasePresenter<VerifikasiOtpEmailView> {
  Map data;

  Future sendOtpEmail(String email, String id) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.sendOtpEmail(email, id);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("otpEmail", response.body);
        isViewAttached ? getView().onSuccessSendOtpEmail(data) : null;
      } else {
        isViewAttached ? getView().onFailSendOtpEmail(data) : null;
      }
    } catch (e) {
      print("errrrrrrrooorrrr----- e" + e.toString());
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future resendOtpEmail(String email, String id) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.sendOtpEmail(email, id);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("otpEmail", response.body);
        isViewAttached ? getView().onSuccessResendLoginOtpEmail(data) : null;
      } else {
        isViewAttached ? getView().onSuccessResendLoginOtpEmail(data) : null;
      }
    } catch (e) {
      print("errrrrrrrooorrrr----- e" + e.toString());
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future updateStatusEmail(String email, String id) async {
    checkViewAttached();
    try {
      var response =
          await appDataManager.apiHelper.updateStatusEmail(email, id);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessUpdateStatusEmail(data) : null;
      } else {
        isViewAttached ? getView().onFailUpdateStatusEmail(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future sendLoginOtpEmail(String email) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.sendLoginOtpEmail(email);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("otpEmail", response.body);
        isViewAttached ? getView().onSuccessSendOtpEmail(data) : null;
      } else {
        isViewAttached ? getView().onFailSendOtpEmail(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future resendLoginOtpEmail(
      String email, String mId, String otp, String expTime) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper
          .resendLoginOtpEmail(email, mId, otp, expTime);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("otpEmail", response.body);
        isViewAttached ? getView().onSuccessResendLoginOtpEmail(data) : null;
      } else {
        isViewAttached ? getView().onFailResendLoginOtpEmail(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future loginOtpEmail(LoginRequest loginRequest) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.loginOtpEmail(loginRequest);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessLoginOtpEmail(data) : null;
      } else {
        isViewAttached ? getView().onFailLoginOtpEmail(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
