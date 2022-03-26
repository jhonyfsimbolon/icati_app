import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/gallery/video/pattern/GalleryVideoView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class GalleryVideoPresenter extends BasePresenter<GalleryVideoView> {
  Map data;

  Future getGalleryVideo() async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getGalleryVideo();
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessGalleryVideo(data) : null;
      } else {
        isViewAttached ? getView().onFailGalleryVideo(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
