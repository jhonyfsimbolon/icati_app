import 'dart:convert';
import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/model/LoginRequest.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/register/pattern/RegisterView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class RegisterPresenter extends BasePresenter<RegisterView> {
  Map data;

  Future loginByPassword(LoginRequest loginRequest) async {
    checkViewAttached();
    try {
      var response =
          await appDataManager.apiHelper.loginByPassword(loginRequest);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessLoginByPassword(data) : null;
      } else {
        isViewAttached ? getView().onFailLoginByPassword(data) : null;
      }
    } catch (e) {
      print("error login" + e.toString());
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

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

  Future register(Member member) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.register(member);
      data = json.decode(response.body);
      print(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        print("berhasil" + response.body);
        isViewAttached ? getView().onSuccessRegister(data) : null;
      } else {
        print("error");
        isViewAttached ? getView().onFailRegister(data) : null;
      }
    } catch (e) {
      print("error login" + e.toString());
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future checkRegister(Member member) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.checkRegister(member);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessCheckRegister(data) : null;
      } else {
        isViewAttached ? getView().onFailCheckRegister(data) : null;
      }
    } catch (e) {
      print("error------" + e.toString());
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future loginByApple(LoginRequest loginRequest) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.loginByApple(loginRequest);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessLoginApple(data) : null;
      } else {
        isViewAttached ? getView().onFailLoginApple(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
