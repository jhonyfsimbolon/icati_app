import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/kerjasama/pattern/KerjaSamaView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class KerjaSamaPresenter extends BasePresenter<KerjaSamaView> {
  Map data;

  Future getGridKerjaSama() async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.getGridKerjaSama();
    try {
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessKerjaSama(data) : null;
      } else {
        isViewAttached ? getView().onFailKerjaSama(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
