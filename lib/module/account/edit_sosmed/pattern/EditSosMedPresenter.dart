import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/account/edit_sosmed/pattern/EditSosMedView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class EditSosMedPresenter extends BasePresenter<EditSosMedView> {
  Map data;

  Future getSocialMedia(String mId) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getSosMed(mId);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessSosMed(data) : null;
      } else {
        isViewAttached ? getView().onFailSosMed(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future editSocialMedia(Member member) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.editSosMed(member);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessEditSosMed(data) : null;
      } else {
        isViewAttached ? getView().onFailEditSosMed(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
