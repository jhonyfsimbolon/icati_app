import 'dart:convert';
import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/othermenu/pundi/pattern/PundiView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class PundiPresenter extends BasePresenter<PundiView> {
  Map data;

  Future getPundi() async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.getPundi();
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessPundi(data) : null;
    } else {
      isViewAttached ? getView().onFailPundi(data) : null;
    }
  }
}
