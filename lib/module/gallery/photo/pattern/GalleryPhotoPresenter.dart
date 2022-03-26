import 'dart:convert';

import 'package:icati_app/base/BasePresenter.dart';
import 'package:icati_app/module/gallery/photo/pattern/GalleryPhotoView.dart';
import 'package:icati_app/network/AppDataManager.dart';
import 'package:icati_app/utils/NetworkUtils.dart';

class GalleryPhotoPresenter extends BasePresenter<GalleryPhotoView> {
  Map data;

  Future getGalleryPhotoList() async {
    checkViewAttached();
    try {
      var response = await appDataManager.apiHelper.getGalleryPhoto();
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessGalleryPhoto(data) : null;
      } else {
        isViewAttached ? getView().onFailGalleryPhoto(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }

  Future getGalleryPhotoDetail(String albId) async {
    checkViewAttached();
    try {
      var response =
          await appDataManager.apiHelper.getGalleryPhotoDetail(albId);
      data = json.decode(response.body);
      if (NetworkUtils.isReqSuccess(response)) {
        isViewAttached ? getView().onSuccessGalleryPhotoDetail(data) : null;
      } else {
        isViewAttached ? getView().onFailGalleryPhotoDetail(data) : null;
      }
    } catch (e) {
      isViewAttached ? getView().onNetworkError() : null;
    }
  }
}
