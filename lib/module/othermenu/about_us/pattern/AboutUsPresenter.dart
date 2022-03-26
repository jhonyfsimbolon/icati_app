import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/othermenu/about_us/pattern/AboutUsView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class AboutUsPresenter extends BasePresenter<AboutUsView> {
  Map data;

  Future getAboutUs() async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getAboutUs();
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessAboutUs(data) : null;
      } else {
        isViewAttached ? getView().onFailAboutUs(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
