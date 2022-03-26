import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/model/Directory.dart';
import 'package:icati_app/module/directory/add_directory/pattern/AddDirectoryView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class AddDirectoryPresenter extends BasePresenter<AddDirectoryView> {
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

  Future getCategoryOptionlist() async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getCategoryOptionList();
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessCategoryOption(data) : null;
      } else {
        isViewAttached ? getView().onFailCategoryOption(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future addDirectory(Directory directory) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.addDirectory(directory);
      print(response.toString());
      response.stream.transform(utf8.decoder).listen((value) async {
        print(value);
        data = await json.decode(value);
        print("masuk sini add directory");
        if (NetworkUtils.isReqSuccessBody(value)) {
          isViewAttached ? getView().onSuccessAddDirectory(data) : null;
        } else {
          isViewAttached ? getView().onFailAddDirectory(data) : null;
        }
      });
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
