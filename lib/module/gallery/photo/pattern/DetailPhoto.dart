import 'package:flutter/material.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/gallery/photo/pattern/GalleryPhotoPresenter.dart';
import 'package:icati_app/module/gallery/photo/pattern/GalleryPhotoView.dart';
import 'package:icati_app/module/gallery/photo/pattern/galleryPhotoWidgets.dart';

class DetailPhoto extends StatefulWidget {
  final String albumId;
  final int index;

  DetailPhoto({this.albumId, this.index});

  @override
  _DetailPhotoState createState() => _DetailPhotoState();
}

class _DetailPhotoState extends State<DetailPhoto> implements GalleryPhotoView {
  GalleryPhotoPresenter _galleryPhotoPresenter;
  List _dataDetailPhoto;

  @override
  void initState() {
    _galleryPhotoPresenter = new GalleryPhotoPresenter();
    _galleryPhotoPresenter.attachView(this);
    _galleryPhotoPresenter.getGalleryPhotoDetail(widget.albumId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle appBarTextStyle = TextStyle(fontSize: 18.0, color: Colors.white);
    return new Scaffold(
        backgroundColor: Colors.black45,
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 8.0),
              Text(
                "Galeri Foto",
                style: appBarTextStyle,
              ),
            ],
          ),
        ),
        body: _dataDetailPhoto != null
            ? GalleryPhotoWidgets()
                .displaySwipePic(context, _dataDetailPhoto, widget.index)
            : BaseView().displayLoadingScreen(context,
                color: Theme.of(context).buttonColor));
  }

  @override
  onFailGalleryPhoto(Map data) {}

  @override
  onFailGalleryPhotoDetail(Map data) {
    if (this.mounted) {
      setState(() {
        _dataDetailPhoto = data['errorMessage'];
      });
    }
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessGalleryPhoto(Map data) {}

  @override
  onSuccessGalleryPhotoDetail(Map data) {
    if (this.mounted) {
      setState(() {
        _dataDetailPhoto = data['message'];
        print("ini foto slide " + _dataDetailPhoto.toString());
      });
    }
  }
}
