import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/verifydata/verify_wa/pattern/VerifyWaView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class VerifyWaPresenter extends BasePresenter<VerifyWaView> {
  Map data;

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

  Future checkWaExist(String mId) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.checkWaExist(mId);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessCheckWaExist(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
