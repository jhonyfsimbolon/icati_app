import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/account/edit_email/pattern/EditEmailView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class EditEmailPresenter extends BasePresenter<EditEmailView> {
  Map data;

  Future sendVerifyEmailChange(String mId, String email) async {
    checkViewAttached();
    try {
      var response =
          await appDataManager.apiHelper.sendVerifyEmailChange(mId, email);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("verifyEmailChange", response.body);
        isViewAttached ? getView().onSuccessSendVerifyEmailChange(data) : null;
      } else {
        isViewAttached ? getView().onFailSendVerifyEmailChange(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future editEmail(String mId, String email) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.editEmail(mId, email);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessEditEmail(data) : null;
      } else {
        isViewAttached ? getView().onFailEditEmail(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
