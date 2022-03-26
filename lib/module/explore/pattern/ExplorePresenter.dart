import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/explore/pattern/ExploreView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class ExplorePresenter extends BasePresenter<ExploreView> {
  Map data;

  Future getNegara() async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getNegaraReg();
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessNegara(data) : null;
      } else {
        isViewAttached ? getView().onFailNegara(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future getProvince() async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.getProvince();
    try {
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessProvince(data) : null;
        print("getProvince OKE");
      } else {
        isViewAttached ? getView().onFailProvince(data) : null;
        print("getProvince GAGAL");
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
      print(e);
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

  Future searchExplore(String search, String type) async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.searchExplore(search, type);
    print("search explore" + response.body.toString());
    try {
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessSearchExplore(data) : null;
        print("searchExplore OKE");
      } else {
        isViewAttached ? getView().onFailSearchExplore(data) : null;
        print("searchExplore OKE");
      }
    } catch (e) {
      print(e);
    }
  }
}
