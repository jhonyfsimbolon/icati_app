import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/verifydata/verify_email/pattern/EmailVerifyView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class EmailVerifyPresenter extends BasePresenter<EmailVerifyView> {
  Map data;

  Future getEmailVerify(String mId) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getVerifyEmail(mId);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessEmailVerify(data) : null;
      } else {
        isViewAttached ? getView().onFailEmailVerify(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future completeEmail(String mId, String email) async {
    print("Submit email");
    print(mId);
    print(email);
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.checkEmail(mId, email);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessCompleteEmail(data) : null;
      } else {
        isViewAttached ? getView().onFailCompleteEmail(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future checkCompleteData(String mId) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.checkCompleteData(mId);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessCompleteData(data) : null;
      } else {
        isViewAttached ? getView().onFailCompleteData(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
