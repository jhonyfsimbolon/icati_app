import 'dart:convert';
import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/verifydata/verifyhp/pattern/VerifyHpView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class VerifyHpPresenter extends BasePresenter<VerifyHpView> {
  Map data;

  Future checkPhone(String mId, String hp) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.checkHp(mId, hp);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessCheckPhone(data) : null;
      } else {
        isViewAttached ? getView().onFailCheckPhone(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future phoneVerification(String mId, String hp) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.phoneVerification(mId, hp);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessPhoneVerification(data) : null;
      } else {
        isViewAttached ? getView().onFailPhoneVerification(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
