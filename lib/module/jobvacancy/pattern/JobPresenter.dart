import 'dart:convert';
import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/jobvacancy/pattern/JobView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class JobPresenter extends BasePresenter<JobView> {
  Map data;

  Future getJobDetail(String jobId) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getJobDetail(jobId);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessJobDetail(data) : null;
        print("job sukses");
      } else {
        isViewAttached ? getView().onFailJobDetail(data) : null;
        print("job gagal");
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  // Future getJobList(String page, String kabupatenId, int tabIndex) async {
  //   checkViewAttached();
  //   // try {
  //     var response = await appDataManager.apiHelper.getJobList(page, kabupatenId);
  //     data = json.decode(response.body);
  //     if (NetworkUtils.isReqSuccess(response)) {
  //       isViewAttached ? getView().onSuccessJobList(data, tabIndex) : null;
  //     } else {
  //       isViewAttached ? getView().onFailJobList(data, tabIndex) : null;
  //     }
  //   // } catch (e) {
  //   //   isViewAttached ? getView().onNetworkError() : null;
  //   // }
  // }

  Future getJobSearch(String keyword) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getJobSearch(keyword);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessJobSearch(data) : null;
      } else {
        isViewAttached ? getView().onFailJobSearch(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future getCategoryJob() async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getCategoryJob();
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessJobCategory(data) : null;
      } else {
        isViewAttached ? getView().onFailJobCategory(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future getJobListAll(String provinsiId, String cityId, String page) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getJobListAll(provinsiId,cityId, page);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessJobListAll(data) : null;
      } else {
        isViewAttached ? getView().onFailJobListAll(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  
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

}
