import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/othermenu/contact_us/pattern/ContactUsView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class ContactUsPresenter extends BasePresenter<ContactUsView> {
  Map data;

  Future getInfoContact() async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getInfoContact();
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessInfoContact(data) : null;
      } else {
        isViewAttached ? getView().onFailInfoContact(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future sendContactInfo(
      String name, String hp, String email, String message) async {
    checkViewAttached();
    var response = await appDataManager.apiHelper
        .sendContactInfo(name, hp, email, message);
    data = json.decode(response.body);
    try {
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessSendContact(data) : null;
      } else {
        isViewAttached ? getView().onFailSendContact(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
