import 'dart:convert';
import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/agenda/pattern/AgendaView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class AgendaPresenter extends BasePresenter<AgendaView> {
  Map data;

  Future getAgendaList(String page) async {
    checkViewAttached();
    // try {
    var response = await appDataManager.apiHelper.getAgendaList(page);
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessAgendaList(data) : null;
    } else {
      isViewAttached ? getView().onFailAgendaList(data) : null;
    }
    // } catch (e) {
    //   isViewAttached ? getView().onNetworkError() : null;
    // }
  }

  Future getAgendaListMore(
      String kabupatenId, String page, int tabIndex) async {
    checkViewAttached();
    try {
      var response =
          await appDataManager.apiHelper.getAgendaListMore(kabupatenId, page);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached
            ? getView().onSuccessAgendaListMore(data, tabIndex)
            : null;
      } else {
        isViewAttached ? getView().onFailAgendaListMore(data, tabIndex) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future getAgendaDetail(String agendaId) async {
    checkViewAttached();
    print("agenda id " + agendaId.toString());
    try {
      var response = await appDataManager.apiHelper.getAgendaDetail(agendaId);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessAgendaDetail(data) : null;
      } else {
        isViewAttached ? getView().onFailAgendaDetail(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
