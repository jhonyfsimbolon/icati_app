import 'dart:convert';
import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/donasi/pattern/DonasiView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class DonasiPresenter extends BasePresenter<DonasiView> {
  Map data;

  Future getDonasiList({int page = 0}) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getDonasiList(page);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessDonasiList(data) : null;
      } else {
        isViewAttached ? getView().onFailDonasiList(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future getDonasiDetail(String donasiId) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getDonasiDetail(donasiId);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessDonasiDetail(data) : null;
      } else {
        isViewAttached ? getView().onFailDonasiDetail(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
