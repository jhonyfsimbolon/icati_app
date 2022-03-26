import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/kabarduka/pattern/KabarDukaView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class KabarDukaPresenter extends BasePresenter<KabarDukaView> {
  Map data;

  Future getKabarDukaList() async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getKabarDuka();
      data = json.decode(response.body);
      print(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessKabarDuka(data) : null;
        // print("get data duka success");
      } else {
        isViewAttached ? getView().onFailKabarDuka(data) : null;
        // print("get data duka gagal");
      }
    } catch (e) {
      // print(e);
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future getKabarDukaDetail(String kabardukaId) async {
    // checkViewAttached();
    try {
      var response =
          await appDataManager.apiHelper.getKabarDukaDetail(kabardukaId);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessKabarDukaDetail(data) : null;
      } else {
        isViewAttached ? getView().onFailKabarDukaDetail(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
