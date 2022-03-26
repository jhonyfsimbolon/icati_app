import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/gallery/video/pattern/GalleryVideoPresenter.dart';
import 'package:icati_app/module/gallery/video/pattern/GalleryVideoView.dart';
import 'package:icati_app/module/gallery/video/pattern/GalleryVideoWidgets.dart';

class GalleryVideo extends StatefulWidget {
  @override
  _GalleryVideoState createState() => _GalleryVideoState();
}

class _GalleryVideoState extends State<GalleryVideo>
    with TickerProviderStateMixin
    implements GalleryVideoView {
  GalleryVideoPresenter _galleryVideoPresenter;

  TabController _tabController;

  List _dataVideo;

  @override
  void initState() {
    _galleryVideoPresenter = GalleryVideoPresenter();
    _galleryVideoPresenter.attachView(this);
    _galleryVideoPresenter.getGalleryVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: Text("Galeri Video 视频库",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(color: Colors.black87)),
            backgroundColor: Colors.white,
            elevation: 0,
            titleSpacing: -10,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            bottom: (_dataVideo != null && _dataVideo.isNotEmpty) &&
                    _tabController != null
                ? PreferredSize(
                    preferredSize: Size.fromHeight(48),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                        isScrollable: true,
                        labelColor: Colors.red,
                        unselectedLabelColor: Colors.grey,
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: UnderlineTabIndicator(
                          borderSide:
                              BorderSide(width: 3.0, color: Colors.redAccent),
                        ),
                        labelStyle: GoogleFonts.roboto(
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 13,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: _dataVideo
                            .map(
                              (cat) => Tab(
                                  child: Text(cat['catName'],
                                      textAlign: TextAlign.center)),
                            )
                            .toList(),
                      ),
                    ),
                  )
                : PreferredSize(
                    child: Container(), preferredSize: Size.fromHeight(0))),
        backgroundColor: mainColor,
        body: _dataVideo == null
            ? BaseView().displayLoadingScreen(context, color: Colors.blueAccent)
            : _dataVideo.isEmpty
                ? BaseView().displayErrorMessage(
                    context, _onRefresh, "Tidak ada Data Video",
                    textColor: Colors.black87)
                : TabBarView(
                    controller: _tabController,
                    children: _dataVideo
                        .map(
                          (item) => RefreshIndicator(
                            onRefresh: _onRefresh,
                            child: GalleryVideoWidgets().displayVideoList(
                                context, item['videoList'], _onRefresh),
                          ),
                        )
                        .toList(),
                  ));
  }

  Future<Null> _onRefresh() async {
    setState(() {
      _dataVideo = null;
      _tabController = null;
    });
    _galleryVideoPresenter.getGalleryVideo();
  }

  @override
  onFailGalleryVideo(Map data) {
    if (this.mounted) {
      setState(() {
        _dataVideo = data['errorMessage'];
      });
    }
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessGalleryVideo(Map data) {
    if (this.mounted) {
      setState(() {
        _dataVideo = data['message'];

        if (_tabController != null) {
          _tabController = TabController(
              vsync: this,
              length: _dataVideo.length,
              initialIndex: _tabController.index);
          print("ini 1");
        } else {
          _tabController =
              new TabController(vsync: this, length: _dataVideo.length);
          print("ini 2");
        }
        print("ini data video " + _dataVideo.toString());
      });
    }
  }
}
