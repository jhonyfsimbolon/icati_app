import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/module/gallery/photo/GalleryPhotoDetail.dart';
import 'package:icati_app/module/gallery/photo/pattern/DetailPhoto.dart';
import 'package:photo_view/photo_view.dart';

class GalleryPhotoWidgets {
  Widget displayPhotoList(
      BuildContext context, List _dataPhotoList, Function _onRefresh) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _dataPhotoList == null ? 0 : _dataPhotoList.length,
        itemBuilder: (context, i) {
          return new Container(
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(width: 0.0, color: Colors.white)),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GalleryPhotoDetail(
                      albumId: _dataPhotoList[i]["albId"].toString(),
                      albumName: _dataPhotoList[i]["albName"],
                    ),
                    settings: RouteSettings(name: "Detail Galeri Foto"),
                  ));
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                              top: 10,
                              left: 10,
                              right: 10,
                              bottom: 10,
                            ),
                            width: 130, //500,
                            height: 130, //350,
                            child: FittedBox(
                              child: Container(
                                width: 100, //500,
                                height: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: _dataPhotoList[i]['albPic'],
                                    placeholder: (context, i) {
                                      return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.asset(
                                            "assets/images/logo_ts_red.png"),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                              width: 175, //500,
                              height: 125,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 0.0, right: 10.0, top: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            BaseFunction().convertToDate(
                                                _dataPhotoList[i]
                                                    ['albAddedDate'],
                                                "d MMMM y"),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    color: Colors.black45,
                                                    fontSize: 11),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    child: Text(_dataPhotoList[i]['albName'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .copyWith(
                                                fontSize: 12.5,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                      width: 300,
                                      margin: EdgeInsets.only(
                                          left: 0.0, bottom: 0.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(Icons.photo, size: 15),
                                          SizedBox(width: 3),
                                          Expanded(
                                            child: Text(
                                              _dataPhotoList[i]['jumlahPhoto']
                                                      .toString() +
                                                  " Foto",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                          ),
                                        ],
                                      )),
                                  SizedBox(height: 4),
                                ],
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget displayPhotoGalleryDetail(BuildContext context,
      List _dataGalleryDetail, String albumId, Function _onRefresh) {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
            itemCount: _dataGalleryDetail.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: GestureDetector(
                  onTap: () {
                    var route = new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new DetailPhoto(albumId: albumId, index: index),
                    );
                    Navigator.of(context).push(route);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: CachedNetworkImage(
                      imageUrl: _dataGalleryDetail[index]['pho'],
                      imageBuilder: (context, imageProvider) => Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, i) {
                        return Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/logo_ts_red.png'),
                                fit: BoxFit.contain),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) => Container(
                        width: 155,
                        height: 155,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/logo_ts_red.png'),
                              fit: BoxFit.contain),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget displaySwipePic(BuildContext context, List images, int indexTap) {
    print("ini images" + images.toString());
    return Swiper(
      index: indexTap,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PhotoView(
                imageProvider:
                    new CachedNetworkImageProvider(images[index]['pho']),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: 4.0,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: images[index]['phoId']),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20),
                child: Text(
                  images[index]['phoCaption'],
                  style: Theme.of(context).textTheme.headline2.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        );
      },
      autoplay: false,
      itemCount: images.length,
      scrollDirection: Axis.horizontal,
      loop: false,
      pagination: new SwiperPagination(
        alignment: Alignment.bottomCenter,
        builder: new DotSwiperPaginationBuilder(
            color: Colors.grey, activeColor: Color(0xff38547C)),
      ),
    );
  }
}
