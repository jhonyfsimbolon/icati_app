import 'dart:convert';
import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/stories/pattern/StoryView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class StoryPresenter extends BasePresenter<StoriesView> {
  Map data;

  Future getMember() async {
    print("GET MEMBER ");
    checkViewAttached();
    var response = await appDataManager.apiHelper.memberStories();
    data = json.decode(response.body);
    if (NetworkUtils.isReqSuccess(response)) {
      isViewAttached ? getView().onSuccessMember(data) : null;
      print("GET MEMBER WORK ");
    } else {
      isViewAttached ? getView().onFailMember(data) : null;
      print("GET MEMBER NOT ");
    }
  }

  // Future getEvent(String id) async {
  //   checkViewAttached();
  //   // var response = await appDataManager.apiHelper.getDetailEvent(id);
  //   data = json.decode(response.body);
  //   if (NetworkUtils.isReqSuccess(response)) {
  //     isViewAttached ? getView().onSuccessEvent(data) : null;
  //   } else {
  //     isViewAttached ? getView().onFailEvent(data) : null;
  //   }
  // }
}
