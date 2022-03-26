import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/account/pattern/AccountView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class AccountPresenter extends BasePresenter<AccountView> {
  Map data;

  Future getProfile(String mid) async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.getProfile(mid);
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessProfile(data) : null;
    } else {
      isViewAttached ? getView().onFailProfile(data) : null;
    }
  }

  Future getWaKeyword(String mId) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getWaKeyword(mId);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessWaKeyword(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
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

  Future getMemberCardList() async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getMemberCardList();
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessMemberCard(data) : null;
      } else {
        isViewAttached ? getView().onFailMemberCard(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future resendVerifyEmail(String mId) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.reSendVerifyEmail(mId);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessResendVerifyEmail(data) : null;
      } else {
        isViewAttached ? getView().onFailResendVerifyEmail(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
