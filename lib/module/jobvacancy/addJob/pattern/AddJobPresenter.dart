import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/model/Job.dart';
import 'package:icati_app/module/jobvacancy/addJob/pattern/AddJobView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class AddJobPresenter extends BasePresenter<AddJobView> {
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

  Future getJobField() async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.getJobField();
    try {
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessJobField(data) : null;
      } else {
        isViewAttached ? getView().onFailJobField(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future addJob(Job job) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.addJob(job);
      print(response.toString());
      response.stream.transform(utf8.decoder).listen((value) async {
        print(value);
        data = await json.decode(value);
        print("masuk sini add job");
        if (NetworkUtils.isReqSuccessBody(value)) {
          isViewAttached ? getView().onSuccessAddJob(data) : null;
        } else {
          isViewAttached ? getView().onFailAddJob(data) : null;
        }
      });
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
