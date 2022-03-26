import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/home/pattern/HomeView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class HomePresenter extends BasePresenter<HomeView> {
  Map data;

  Future checkCompleteData(String mid) async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.checkCompleteData(mid);
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessCheckCompleteData(data) : null;
    } else {
      isViewAttached ? getView().onFailCheckCompleteData(data) : null;
    }
  }

  Future getOrganisasiList() async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.getOrganisasiListHome();
    try {
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessOrganisasi(data) : null;
      } else {
        isViewAttached ? getView().onFailOrganisasi(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

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

  Future getMemberCardList() async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.getMemberCardList();
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessMemberCard(data) : null;
    } else {
      isViewAttached ? getView().onFailMemberCard(data) : null;
    }
  }

  Future getHomeContent(String organisasiId) async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.homeContent(organisasiId);
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessHomeContent(data) : null;
    } else {
      isViewAttached ? getView().onFailHomeContent(data) : null;
    }
  }

  Future searchOrganisasiHome(String searchOrganisasi) async {
    checkViewAttached();
    var response =
        await appDataManager.apiHelper.searchOrganisasiHome(searchOrganisasi);
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessSearchOrganisasi(data) : null;
    } else {
      isViewAttached ? getView().onFailSearchOrganisasi(data) : null;
    }
  }

  Future getUnreadNotification(String mId) async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.getUnreadNotification(mId);
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessUnreadNotification(data) : null;
    } else {
      isViewAttached ? getView().onFailUnreadNotification(data) : null;
    }
  }

  Future getpundi() async {
    // checkViewAttached();
    // var response = await appDataManager.apiHelper.getPundi();
    // data = json.decode(response.body);
    // if (NetworkUtils.isReqSuccess(response)) {
    //   isViewAttached ? getView().onSuccessPundi(data) : null;
    // }
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

  Future getPopUp() async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.getPopUp();
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessPopUp(data) : null;
    } else {
      isViewAttached ? getView().onFailPopUp(data) : null;
    }
  }
}
