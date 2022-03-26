import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/module/herbal/HerbalDetailPhoto.dart';
import 'package:photo_view/photo_view.dart';

class HerbalDetailWidgets {
  Widget displayBoxPic(BuildContext context, List herbalImages) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return new Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.only(top: statusBarHeight),
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            herbalImages.length > 1
                ? SizedBox(
                    height: 350,
                    child: Swiper(
                      itemCount: herbalImages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HerbalDetailPhoto(
                                    herbalImages: herbalImages, index: index)));
                          },
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            placeholder: (context, i) {
                              return Image.asset(
                                  "assets/images/logo_ts_red.png",
                                  width: 200,
                                  height: 100);
                            },
                            errorWidget: (_, __, ___) {
                              return Image.asset(
                                  "assets/images/logo_ts_red.png",
                                  width: 200,
                                  height: 100);
                            },
                            imageUrl: herbalImages[index]['urlImage'],
                          ),
                        );
                      },
                      autoplay: true,
                      scrollDirection: Axis.horizontal,
                      pagination: new SwiperPagination(
                          alignment: Alignment.bottomCenter),
                      control:
                          new SwiperControl(iconNext: null, iconPrevious: null),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HerbalDetailPhoto(
                              herbalImages: herbalImages, index: 0)));
                    },
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      placeholder: (context, i) {
                        return Image.asset("assets/images/logo_ts_red.png",
                            width: 200, height: 100);
                      },
                      errorWidget: (_, __, ___) {
                        return Image.asset("assets/images/logo_ts_red.png",
                            width: 200, height: 100);
                      },
                      imageUrl: herbalImages[0]['urlImage'],
                    ),
                  ),
            // Container(
            //   margin: EdgeInsets.only(top: 10),
            //   height: 120,
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     scrollDirection: Axis.horizontal,
            //     itemCount: herbalImages.length,
            //     itemBuilder: (context, i) {
            //       return Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: GestureDetector(
            //           onTap: () {
            //             Navigator.of(context).push(MaterialPageRoute(
            //                 builder: (context) => HerbalDetailPhoto(
            //                     herbalImages: herbalImages, index: i)));
            //           },
            //           child: CachedNetworkImage(
            //               imageUrl: herbalImages[i]['urlImage'],
            //               width: 150,
            //               fit: BoxFit.cover),
            //         ),
            //       );
            //     },
            //   ),
            // )
          ]),
    );
  }

  Widget displayHerbalName(
      BuildContext context, String herbalName, String herbalStatus) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(herbalName,
              style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5)),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: herbalStatus == "Tersedia" ? Colors.green : Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(50)),
                border: Border.all(
                    color: herbalStatus == "Tersedia"
                        ? Colors.green
                        : Colors.red)),
            child: Text(herbalStatus,
                style: GoogleFonts.roboto(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
          )
        ],
      ),
    );
  }

  Widget displayHerbalDesc(
      BuildContext context, String herbalDecs, List herbalLink) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          HtmlWidget(herbalDecs,
              textStyle: GoogleFonts.roboto(
                  fontSize: 12, color: Colors.black87, letterSpacing: 0.5)),
          SizedBox(height: 30),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: herbalLink.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(left: 3, bottom: 5),
                  child: InkWell(
                    onTap: () {
                      BaseFunction().launchURL(herbalLink[i]);
                    },
                    child: Text(
                      herbalLink[i],
                      style: GoogleFonts.roboto(
                          fontSize: 12, letterSpacing: 0.5, color: Colors.blue),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget displayHerbalSwipePic(
      BuildContext context, List images, int indexTap) {
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
                    new CachedNetworkImageProvider(images[index]['urlImage']),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: 4.0,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: images[index]['imageId']),
              ),
            )
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
