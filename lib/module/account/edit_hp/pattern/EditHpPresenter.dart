import 'dart:convert';
import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/account/edit_hp/pattern/EditHpView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class EditHpPresenter extends BasePresenter<EditHpView> {
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

  Future editHp(String mId, String newPhone) async {
    checkViewAttached();
    print("data edit hp ");
    print(mId);
    print(newPhone);
    var response = await appDataManager.apiHelper.editHp(mId, newPhone);
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessEditHp(data) : null;
    } else {
      isViewAttached ? getView().onFailEditHp(data) : null;
    }
  }
}
