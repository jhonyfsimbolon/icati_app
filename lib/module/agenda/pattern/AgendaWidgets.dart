import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icati_app/module/agenda/AgendaDetail.dart';

class AgendaWidgets {
  Widget displayCategory(BuildContext context, List dataAgenda,
      Function tapCategory, int indexTap) {
    return Container(
      height: 70,
      // margin: EdgeInsets.only(top: 16.0, bottom: 20.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dataAgenda == null ? 0 : dataAgenda.length,
        itemBuilder: (context, i) {
          return Row(
            children: <Widget>[
              i == 0 ? SizedBox(width: 16.0) : Container(),
              GestureDetector(
                onTap: () {
                  tapCategory(i);
                },
                child: agendaCat(context, i, dataAgenda, indexTap),
              ),
              SizedBox(width: 16.0),
            ],
          );
        },
      ),
    );
  }

  Widget agendaCat(BuildContext context, int i, List dataAgenda, int indexTap) {
    return Container(
      child: new FittedBox(
        child: Material(
          color: Colors.white,
          elevation: 0.0,
          borderRadius: BorderRadius.circular(10.0),
          child: Column(
            children: <Widget>[
              i == indexTap
                  ? Container(
                      child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        dataAgenda[i]['kabupatenName'],
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ))
                  : Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          dataAgenda[i]['kabupatenName'],
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayAgendaList(BuildContext context, List dataAgenda) {
    return ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: dataAgenda == null ? 0 : dataAgenda.length,
      itemBuilder: (context, i) {
        return new Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(5.0),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AgendaDetail(id: dataAgenda[i]["akId"].toString()),
                  settings: RouteSettings(name: "Detail Agenda"),
                ));
              },
              child: new Container(
                padding: new EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FittedBox(
                      child: Container(
                        width: 100, //500,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: dataAgenda[i]["akPic"] == null
                                ? ""
                                : dataAgenda[i]["akPic"],
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 10.0),
                              child: Text(
                                dataAgenda[i]["akTitle"].toString(),
                                style: GoogleFonts.roboto(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              margin: EdgeInsets.only(left: 10.0),
                              padding: EdgeInsets.all(2),
                              child: Text(
                                dataAgenda[i]["akDate"].toString(),
                                style: GoogleFonts.roboto(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget displayBoxPic(BuildContext context, String image, String caption) {
    return GestureDetector(
      onTap: () {},
      child: new Container(
        color: Colors.white,
        padding: EdgeInsets.all(10.0),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FittedBox(
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: image,
                      placeholder: (context, i) {
                        return Image.asset("assets/images/logo_ts_red.png");
                      },
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(
                    caption,
                    style: TextStyle(
                      color: Colors.black45,
                      //fontWeight: FontWeight.bold,
                      fontFamily: 'expressway',
                      fontSize: 11.0,
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  Widget displayBoxDate(BuildContext context, String title, int addedon,
      String kabupaten, String provinsi, String akDate, int hidetime) {
    return GestureDetector(
      onTap: () {},
      child: new Container(
        color: Colors.white,
        padding: EdgeInsets.all(10.0),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                  width: 300,
                  child: Row(
                    children: <Widget>[
                      //new Icon(Icons.location_on),
                      //SizedBox(width: 5.0),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'expressway',
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(bottom: 7.0),
                  width: 300,
                  child: Row(
                    children: <Widget>[
                      new Icon(Icons.calendar_today, size: 14.0),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          akDate,
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'expressway',
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(bottom: 7.0),
                  width: 300,
                  child: Row(
                    children: <Widget>[
                      new Icon(Icons.location_on, size: 14.0),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          kabupaten,
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'expressway',
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                    ],
                  )),
            ]),
      ),
    );
  }

  Widget displayBoxInfo(BuildContext context, String akDesc) {
    return GestureDetector(
      onTap: () {},
      child: new Container(
        color: Colors.white,
        padding: EdgeInsets.all(10.0),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  width: 300,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          akDesc,
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'expressway',
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  )),
            ]),
      ),
    );
  }

  Widget displayMaps(
      BuildContext context,
      double lat,
      double long,
      Completer<GoogleMapController> _controller,
      int akId,
      String akLat,
      String akLong) {
    double akLatMap = 0;
    double akLongMap = 0;
    if (akLat == "" || akLat == null || akLong == "" || akLong == null) {
      return Container();
    } else {
      akLatMap = double.parse(akLat);
      akLongMap = double.parse(akLong);

      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
//    height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          height: 400.0,
//    color: Colors.white,
//    padding: EdgeInsets.all(10.0),
          child: lat == null || long == null
              ? Container(
                  child: Center(child: Text("Tidak ada data")),
                )
              : GoogleMap(
                  scrollGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                    new Factory<OneSequenceGestureRecognizer>(
                      () => new EagerGestureRecognizer(),
                    ),
                  ].toSet(),
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          lat != null || long != null ? lat : 0.506566,
                          lat != null || long != null ? long : 101.437790),
                      zoom: 12),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: {
                    Marker(
                      markerId: MarkerId(akId.toString()),
                      position: LatLng(
                          lat != null || long != null ? lat : 0.506566,
                          lat != null || long != null ? long : 101.437790),
                      infoWindow: InfoWindow(title: 'Lokasi Saat ini'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    ),
                    Marker(
                      markerId: MarkerId('Lokasi Kegiatan'),
                      position: LatLng(akLatMap, akLongMap),
                      infoWindow:
                          InfoWindow(title: 'Lokasi Kegiatan', snippet: ""),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueOrange,
                      ),
                    ),
                  },
                ),
        ),
      );
    }
  }
}
