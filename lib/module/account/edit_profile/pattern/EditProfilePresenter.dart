import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/account/edit_profile/pattern/EditProfileView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class EditProfilePresenter extends BasePresenter<EditProfileView> {
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
    try {
      var response = await appDataManager.apiHelper.getProvinceReg();
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

  Future getJobType() async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getJobType();
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessJobType(data) : null;
      } else {
        isViewAttached ? getView().onFailJobType(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  // Future getJobTtype()

  Future getCity(String provinceId) async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.getCityReg(provinceId);
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

  Future editProfile(Member member) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.editProfile(member);
      print(response.toString());
      response.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .listen((value) async {
        print(value);
        if (value['success'] == true) {
          isViewAttached ? getView().onSuccessEditProfile(value) : null;
        } else {
          isViewAttached ? getView().onFailEditProfile(value) : null;
        }
      });
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
