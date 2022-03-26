import 'dart:convert';
import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/news/pattern/NewsView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class NewsPresenter extends BasePresenter<NewsView> {
  Map data;

  Future getNewsList(String page) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getNewsList(page);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessNewsList(data) : null;
      } else {
        isViewAttached ? getView().onFailNewsList(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future getNewsDetail(String newsId) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getNewsDetail(newsId);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessNewsDetail(data) : null;
      } else {
        isViewAttached ? getView().onFailNewsDetail(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future addCommentNews(
      String newsId, String name, String email, String message) async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper
          .addCommentNews(newsId, name, email, message);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessAddComment(data) : null;
      } else {
        isViewAttached ? getView().onFailAddComment(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
