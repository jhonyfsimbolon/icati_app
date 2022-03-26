import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/organisasi/pattern/OrganisasiView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class OrganisasiPresenter extends BasePresenter<OrganisasiView> {
  Map data;

  Future getGridOrganisasi() async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.getOrganisasiList();
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

  Future getOrganisasiDetail(String organizationId) async {
    checkViewAttached();
    print("organisasi id di presenter " + organizationId.toString());
    var response =
        await appDataManager.apiHelper.posOrganisasiDetail(organizationId);
    print(response.body);
    try {
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessOrganisasiDetail(data) : null;
      } else {
        isViewAttached ? getView().onFailOrganisasiDetail(data) : null;
      }
    } catch (e) {
      print(e);
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
