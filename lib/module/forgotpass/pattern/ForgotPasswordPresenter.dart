import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/forgotpass/pattern/ForgotPasswordView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class ForgotPasswordPresenter extends BasePresenter<ForgotPasswordView> {
  Map data;

  Future sendForgotPass(String emailForgot) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.sendForgotPass(emailForgot);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessForgotPassword(data) : null;
      } else {
        isViewAttached ? getView().onFailForgotPassword(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future resetPass(String mId, String password, String rePassword) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper
          .resetPassword(mId, password, rePassword);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessResetPassword(data) : null;
      } else {
        isViewAttached ? getView().onFailResetPassword(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
