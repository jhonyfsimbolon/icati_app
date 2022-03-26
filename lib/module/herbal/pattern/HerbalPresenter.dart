import 'dart:convert';
import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/herbal/pattern/HerbalView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class HerbalPresenter extends BasePresenter<HerbalView> {
  Map data;

  Future getHerbalList(String page) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getHerbalList(page);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessHerbalList(data) : null;
      } else {
        isViewAttached ? getView().onFailHerbalList(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future herbalDetail(String herbalId) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.herbalDetail(herbalId);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessHerbalDetail(data) : null;
      } else {
        isViewAttached ? getView().onFailHerbalDetail(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
