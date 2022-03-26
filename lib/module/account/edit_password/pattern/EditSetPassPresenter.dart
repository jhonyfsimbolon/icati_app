import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/account/edit_password/pattern/EditSetPassView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class EditSetPassPresenter extends BasePresenter<EditSetPassView> {
  Map data;

  Future editSetPass(Member member) async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.editSetPassword(member);
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessEditSetPass(data) : null;
    } else {
      isViewAttached ? getView().onFailEditSetPass(data) : null;
    }
  }
}
