import 'dart:convert';
import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/agenda/pattern/AgendaView.dart';
import 'package:icati_app/module/directory/pattern/DirectoryView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class DirectoryPresenter extends BasePresenter<DirectoryView> {
  Map data;

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

  Future getDirectoryDetail(String directoryId) async {
    checkViewAttached();
    print("direktori id " + directoryId.toString());
    try {
      var response =
          await appDataManager.apiHelper.getDirectoryDetail(directoryId);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessDirectoryDetail(data) : null;
      } else {
        isViewAttached ? getView().onFailDirectoryDetail(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future getDirectoryCategory(String provinsiId, String kabupatenId) async {
    checkViewAttached();
    try {
      var response =
          await appDataManager.apiHelper.getDirectoryCategory(provinsiId, kabupatenId);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessDirectoryCategory(data) : null;
      } else {
        isViewAttached ? getView().onFailDirectoryCategory(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future getDirectorySubCat(
      String page, String catId, String subCatId, int tabIndex, String provinsiId, String kabupatenId) async {
    checkViewAttached();
    // try {
    var response = await appDataManager.apiHelper
        .getDirectorySubCat(page, catId, subCatId, provinsiId, kabupatenId);
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached
          ? getView().onSuccessDirectorySubCat(data, page, tabIndex)
          : null;
    } else {
      isViewAttached
          ? getView().onFailDirectorySubCat(data, page, tabIndex)
          : null;
    }
    // } catch (e) {
    //   isViewAttached ? getView().onNetworkError() : null;
    // }
  }

  Future getDirectorySearch(String keyword) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getDirectorySearch(keyword);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessDirectorySearch(data) : null;
      } else {
        isViewAttached ? getView().onFailDirectorySearch(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
