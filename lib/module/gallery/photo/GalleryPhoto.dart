import 'package:flutter/material.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/gallery/photo/pattern/GalleryPhotoPresenter.dart';
import 'package:icati_app/module/gallery/photo/pattern/GalleryPhotoView.dart';
import 'package:icati_app/module/gallery/photo/pattern/galleryPhotoWidgets.dart';

class GalleryPhoto extends StatefulWidget {
  @override
  _GalleryPhotoState createState() => _GalleryPhotoState();
}

class _GalleryPhotoState extends State<GalleryPhoto>
    implements GalleryPhotoView {
  GalleryPhotoPresenter _galleryPhotoPresenter;

  List _dataPhoto;

  @override
  void initState() {
    _galleryPhotoPresenter = new GalleryPhotoPresenter();
    _galleryPhotoPresenter.attachView(this);
    _galleryPhotoPresenter.getGalleryPhotoList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          titleSpacing: -10,
          title: Text("Galeri Foto 照片库",
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .copyWith(color: Colors.black87)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: mainColor,
        body: _dataPhoto == null
            ? BaseView().displayLoadingScreen(context,
                color: Theme.of(context).buttonColor)
            : _dataPhoto.isEmpty
                ? BaseView().displayErrorMessage(
                    context, _onRefresh, "Data Galeri Foto tidak tersedia")
                : GalleryPhotoWidgets()
                    .displayPhotoList(context, _dataPhoto, _onRefresh));
  }

  Future<Null> _onRefresh() async {
    _galleryPhotoPresenter.getGalleryPhotoList();
  }

  @override
  onFailGalleryPhoto(Map data) {
    if (this.mounted) {
      setState(() {
        _dataPhoto = data['errorMessage'];
      });
    }
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessGalleryPhoto(Map data) {
    if (this.mounted) {
      setState(() {
        _dataPhoto = data['message'];
      });
    }
  }

  @override
  onFailGalleryPhotoDetail(Map data) {}

  @override
  onSuccessGalleryPhotoDetail(Map data) {}
}
