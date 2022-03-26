import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/module/kabarduka/BeritaDukaPhoto.dart';
import 'package:icati_app/module/kabarduka/KabarDukaDetail.dart';

class KabarDukaWidgets {
  Widget displayKabardukaList(
      BuildContext context, List _dataKabardukaList, Function _onRefresh) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _dataKabardukaList == null ? 0 : _dataKabardukaList.length,
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
                    builder: (context) => KabarDukaDetail(
                      kabardukaId:
                          _dataKabardukaList[i]["kabardukaId"].toString(),
                      kabardukaNama:
                          _dataKabardukaList[i]["kabardukaName"].toString(),
                      //     " (" +
                      //     _dataKabardukaList[i]["kabardukaUmur"].toString() +
                      //     " Tahun)"
                    ),
                    settings: RouteSettings(name: "Detail Kabar Duka"),
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
                                    imageUrl: _dataKabardukaList[i]
                                        ['kabardukaThumUrl'],
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
                                            // BaseFunction().convertToDate(
                                            _dataKabardukaList[i]
                                                    ['kabardukaName'] +
                                                " (" +
                                                _dataKabardukaList[i]
                                                        ['kabardukaUmur']
                                                    .toString() +
                                                " Tahun)",
                                            // "d MM y"),
                                            // "tgl",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    width: 300,
                                    margin:
                                        EdgeInsets.only(left: 0.0, bottom: 0.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(FontAwesomeIcons.calendarDay,
                                            size: 12),
                                        SizedBox(width: 3),
                                        Expanded(
                                          child: Text(
                                              _dataKabardukaList[i]
                                                      ['kabardukaMeninggalDate']
                                                  .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(fontSize: 11)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Container(
                                      width: 300,
                                      margin: EdgeInsets.only(
                                          left: 0.0, bottom: 0.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.calendar,
                                              size: 12),
                                          SizedBox(width: 3),
                                          Expanded(
                                            child: Text(
                                              _dataKabardukaList[i]
                                                      ['kabardukaJenis'] +
                                                  "-" +
                                                  _dataKabardukaList[i][
                                                          'kabardukaAkhirDateTime']
                                                      .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(fontSize: 11),
                                            ),
                                          ),
                                        ],
                                      )),
                                  SizedBox(height: 4),
                                  Container(
                                      width: 300,
                                      margin: EdgeInsets.only(
                                          left: 0.0, bottom: 0.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.mapMarkerAlt,
                                              size: 12),
                                          SizedBox(width: 3),
                                          Expanded(
                                            child: Text(
                                              _dataKabardukaList[i]
                                                  ['kabardukaAsal'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(fontSize: 11),
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

  Widget displayPic(BuildContext context, List _dataKabardukaDetail) {
    return Container(
      // color: Colors.black,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BeritaDukaPhoto(
                      imageUrl: _dataKabardukaDetail[0]['kabardukaThumUrl']),
                ),
              );
            },
            child: CachedNetworkImage(
              imageUrl: _dataKabardukaDetail[0]['kabardukaThumUrl'],
              placeholder: (context, i) {
                return Image.asset("assets/images/logo_ts_red.png");
              },
            ),
          ),
        ],
      ),
    );
    // return GestureDetector(
    //   onTap: () {},
    //   child: new Container(
    //     color: Colors.white,
    //     margin: EdgeInsets.only(bottom: 10.0),
    //     padding: EdgeInsets.all(10.0),
    //     child: new Column(
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: <Widget>[
    //           Text(_dataKabardukaDetail[0]['kabardukaThumUrl']),
    //           // Image.network(n)
    //          child: CachedNetworkImage(
    //             fit: BoxFit.cover,
    //             imageUrl: _dataKabardukaDetail[0]['kabardukaThumUrl'],
    //             placeholder: (context, i) {
    //               return Image.asset("assets/images/logo_ts_red.png");
    //             },
    //           ),
    //         ]),
    //   ),
    // );
  }

  Widget displayContent(BuildContext context, List _dataKabardukaDetail) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _dataKabardukaDetail == null
                  ? 0
                  : _dataKabardukaDetail.length,
              itemBuilder: (context, i) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Padding(padding: )
                        Container(
                            padding: EdgeInsets.only(left: 20),
                            margin: EdgeInsets.only(bottom: 10),
                            child:
                                Icon(FontAwesomeIcons.calendarDay, size: 20)),
                        SizedBox(width: 3),
                        Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(
                              _dataKabardukaDetail[i]["kabardukaMeninggalDate"],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontSize: 14)),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                    Row(
                      children: [
                        // Padding(padding: )
                        Container(
                            padding: EdgeInsets.only(left: 20),
                            margin: EdgeInsets.only(bottom: 10),
                            child: Icon(FontAwesomeIcons.calendar, size: 20)),
                        SizedBox(width: 3),
                        Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(
                              _dataKabardukaDetail[i]['kabardukaJenis'] +
                                  "-" +
                                  _dataKabardukaDetail[i]
                                          ['kabardukaAkhirDateTime']
                                      .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontSize: 14)),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                    Row(
                      children: [
                        // Padding(padding: )
                        Container(
                            padding: EdgeInsets.only(left: 20),
                            margin: EdgeInsets.only(bottom: 10),
                            child:
                                Icon(FontAwesomeIcons.mapMarkerAlt, size: 20)),
                        SizedBox(width: 3),
                        Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(_dataKabardukaDetail[i]['kabardukaAsal'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontSize: 14)),
                        ),
                      ],
                    ),
                  ],
                );
              }),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child:
                Divider(thickness: 2, color: Color.fromRGBO(186, 186, 186, 1)),
          ),
        ],
      ),
    );
  }

  // Widget displayKabardukaDetail(BuildContext context, List _dataKabardukaDetail,
  //     String kabardukaId, Function _onRefresh) {
  //   return MediaQuery.removePadding(
  //     removeTop: true,
  //     context: context,
  //     child: RefreshIndicator(
  //       onRefresh: _onRefresh,
  //       child: StaggeredGridView.countBuilder(
  //           crossAxisCount: 2,
  //           staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
  //           itemCount: _dataKabardukaDetail.length,
  //           itemBuilder: (context, index) {
  //             return Container(
  //               margin: EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                   color: Colors.transparent,
  //                   borderRadius: BorderRadius.all(Radius.circular(15))),
  //               child: GestureDetector(
  //                 onTap: () {},
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.all(Radius.circular(15)),
  //                   child: CachedNetworkImage(
  //                     imageUrl: _dataKabardukaDetail[index]['kabardukaThumUrl'],
  //                     imageBuilder: (context, imageProvider) => Container(
  //                       width: 150,
  //                       height: 150,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.all(Radius.circular(10)),
  //                         image: DecorationImage(
  //                             image: imageProvider, fit: BoxFit.cover),
  //                       ),
  //                     ),
  //                     placeholder: (context, i) {
  //                       return Container(
  //                         width: 150,
  //                         height: 150,
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.all(Radius.circular(10)),
  //                           image: DecorationImage(
  //                               image:
  //                                   AssetImage('assets/images/logo_ts_red.png'),
  //                               fit: BoxFit.contain),
  //                         ),
  //                       );
  //                     },
  //                     errorWidget: (context, url, error) => Container(
  //                       width: 155,
  //                       height: 155,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.all(Radius.circular(10)),
  //                         image: DecorationImage(
  //                             image:
  //                                 AssetImage('assets/images/logo_ts_red.png'),
  //                             fit: BoxFit.contain),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }),
  //     ),
  //   );
  // }

//   Widget displaySwipePic(BuildContext context, List images, int indexTap) {
//     print("ini images" + images.toString());
//     return Swiper(
//       index: indexTap,
//       itemBuilder: (BuildContext context, int index) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Expanded(
//               child: PhotoView(
//                 imageProvider:
//                     new CachedNetworkImageProvider(images[index]['pho']),
//                 minScale: PhotoViewComputedScale.contained * 0.8,
//                 maxScale: 4.0,
//                 heroAttributes:
//                     PhotoViewHeroAttributes(tag: images[index]['phoId']),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.only(left: 20.0, right: 20),
//                 child: Text(
//                   images[index]['phoCaption'],
//                   style: Theme.of(context).textTheme.headline2.copyWith(
//                       color: Colors.white, fontWeight: FontWeight.w500),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//       autoplay: false,
//       itemCount: images.length,
//       scrollDirection: Axis.horizontal,
//       loop: false,
//       pagination: new SwiperPagination(
//         alignment: Alignment.bottomCenter,
//         builder: new DotSwiperPaginationBuilder(
//             color: Colors.grey, activeColor: Color(0xff38547C)),
//       ),
//     );
//   }
}
