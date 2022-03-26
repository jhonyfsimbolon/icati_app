import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/relatedLink/pattern/RelatedLinkView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class RelatedLinkPresenter extends BasePresenter<RelatedLinkView> {
  Map data;

  Future getGridLinkGridView() async {
    checkViewAttached();
    var response = await appDataManager.apiHelper.getLinkTerkaitGridView();
    try {
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessRelatedLink(data) : null;
      } else {
        isViewAttached ? getView().onFailRelatedLink(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
