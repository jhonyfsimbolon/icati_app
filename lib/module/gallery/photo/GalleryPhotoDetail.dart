import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/gallery/photo/pattern/GalleryPhotoPresenter.dart';
import 'package:icati_app/module/gallery/photo/pattern/GalleryPhotoView.dart';
import 'package:icati_app/module/gallery/photo/pattern/galleryPhotoWidgets.dart';

class GalleryPhotoDetail extends StatefulWidget {
  final String albumId, albumName;

  GalleryPhotoDetail({this.albumId, this.albumName});

  @override
  _GalleryPhotoDetailState createState() => _GalleryPhotoDetailState();
}

class _GalleryPhotoDetailState extends State<GalleryPhotoDetail>
    implements GalleryPhotoView {
  GalleryPhotoPresenter _galleryPhotoPresenter;

  List _dataGalleryDetail;

  @override
  void initState() {
    _galleryPhotoPresenter = new GalleryPhotoPresenter();
    _galleryPhotoPresenter.attachView(this);
    _galleryPhotoPresenter.getGalleryPhotoDetail(widget.albumId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: false,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Color.fromRGBO(159, 28, 42, 1),
                  Color.fromRGBO(159, 28, 42, 1),
                ])),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Text("DETAIL GALERI FOTO",
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1)),
                      SizedBox(height: 5),
                      Text(widget.albumName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline2.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              letterSpacing: 0.5))
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setSp(30)),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: ScreenUtil().setSp(18)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30)),
                      color: Colors.white,
                    ),
                    child: Container(
                      child: _dataGalleryDetail != null
                          ? GalleryPhotoWidgets().displayPhotoGalleryDetail(
                              context,
                              _dataGalleryDetail,
                              widget.albumId,
                              _onRefresh)
                          : BaseView().displayLoadingScreen(context,
                              color: Theme.of(context).buttonColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Future<Null> _onRefresh() async {
    _galleryPhotoPresenter.getGalleryPhotoDetail(widget.albumId);
  }

  @override
  onFailGalleryPhoto(Map data) {}

  @override
  onFailGalleryPhotoDetail(Map data) {
    if (this.mounted) {
      setState(() {
        _dataGalleryDetail = data['errorMessage'];
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
        _dataGalleryDetail = data['message'];
      });
    }
  }
}
