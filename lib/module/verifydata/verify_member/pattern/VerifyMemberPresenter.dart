import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/verifydata/verify_member/pattern/VerifyMemberView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class VerifyMemberPresenter extends BasePresenter<VerifyMemberView> {
  Map data;

  Future getProvince() async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getProvince();
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessProvince(data) : null;
      } else {
        isViewAttached ? getView().onFailProvince(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future getCity(String provinceId) async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.getCity(provinceId);
    try {
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessCity(data) : null;
      } else {
        isViewAttached ? getView().onFailCity(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future completeProfile(Member member) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.completeProfile(member);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessCompleteProfile(data) : null;
      } else {
        isViewAttached ? getView().onFailCompleteProfile(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
