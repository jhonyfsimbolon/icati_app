import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/module/jobvacancy/JobDetail.dart';

class JobWidgets {
  Widget displayBoxPicInfo(BuildContext context, List dataJob) {
    String addDate = BaseFunction()
        .convertToDate(dataJob[0]['lokerAddTimestamp'], 'EEEE, d MMMM yyyy');
    return new Container(
        color: Colors.white,
        padding: new EdgeInsets.only(
            left: 16.0, top: 10.0, right: 10.0, bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FittedBox(
              child: Container(
                width: 140, //500,
                height: 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: dataJob[0]['lokerPic'],
                    placeholder: (context, i) {
                      return Image.asset("assets/images/logo_ts_red.png");
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 300,
                        margin: EdgeInsets.only(bottom: 5.0, top: 10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                dataJob[0]['lokerName'],
                                style: GoogleFonts.roboto(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                            ),
                          ],
                        )),
                    Container(
                        width: 300,
                        margin: EdgeInsets.only(bottom: 5.0, top: 10.0),
                        child: Row(
                          children: <Widget>[
                            new Icon(Icons.supervisor_account, size: 14.0),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                dataJob[0]['bidangName'],
                                style: GoogleFonts.roboto(
                                    fontSize: 12.0, color: Colors.black87),
                              ),
                            ),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Icon(Icons.calendar_today, size: 14.0),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                dataJob[0]['lokerCombineDate'].toString(),
                                style: GoogleFonts.roboto(
                                    fontSize: 12.0, color: Colors.black87),
                              ),
                            ),
                          ],
                        )),
                    Container(
                        child: Row(
                      children: <Widget>[
                        new Icon(Icons.location_on, size: 14.0),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            dataJob[0]['kabupatenName'].toString() +
                                ", " +
                                dataJob[0]['provinsiName'],
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'expressway',
                              fontSize: 11.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        // Text(
                        //   dataJob[0]['provinsiName'].toString(),
                        //   style: TextStyle(
                        //     color: Colors.black87,
                        //     fontFamily: 'expressway',
                        //     fontSize: 11.0,
                        //   ),
                        //   //textAlign: TextAlign.left,
                        // ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget displayBoxInfo(BuildContext context, List dataJob) {
    return GestureDetector(
      onTap: () {},
      child: new Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 20.0, top: 10.0),
        padding: EdgeInsets.all(20.0),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                dataJob[0]['lokerName'].toString(),
                style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'expressway',
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 10.0, top: 20.0),
                  width: 300,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          dataJob[0]['lokerDesc'].toString(),
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'expressway',
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ],
                  )),
            ]),
      ),
    );
  }

  Widget displayListJobVacancy(BuildContext context, dataJob) {
    return ListView.builder(
      shrinkWrap: false,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: dataJob == null ? 0 : dataJob.length,
      itemBuilder: (context, i) {
        return new Container(
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: 0.0, color: Colors.white)),
          ),
          child: InkWell(
            onTap: () {
              var route = new MaterialPageRoute(
                builder: (BuildContext context) => new JobDetail(
                  id: dataJob[i]["lokerId"].toString(),
                ),
              );
              Navigator.of(context).push(route);
            },
            child: new Container(
              padding: new EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FittedBox(
                    child: Container(
                      width: 110, //500,
                      height: 110,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: CachedNetworkImage(
                          fit: BoxFit.contain,
                          imageUrl: dataJob[i]["lokerPic"],
                          placeholder: (context, i) {
                            return Image.asset("assets/images/logo_ts_red.png");
                          },
                          errorWidget: (_, __, ___) {
                            return Image.asset("assets/images/logo_ts_red.png");
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            dataJob[i]["lokerName"],
                            style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: 'expressway',
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                              margin: EdgeInsets.only(bottom: 5.0, top: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: new Icon(
                                      Icons.location_city,
                                      size: 13.0,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Expanded(
                                    child: Text(
                                      dataJob[i]['lokerCompanyName'],
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
                              width: 300,
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                children: <Widget>[
                                  new Icon(Icons.supervisor_account,
                                      size: 14.0),
                                  SizedBox(width: 10.0),
                                  Expanded(
                                    child: Text(
                                      dataJob[i]['bidangName'],
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'expressway',
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child:
                                        Icon(Icons.calendar_today, size: 14.0),
                                  ),
                                  SizedBox(width: 10.0),
                                  Expanded(
                                    child: Text(
                                      dataJob[i]['lokerCombineDate'],
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'expressway',
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                              margin: EdgeInsets.only(bottom: 5.0),
                              width: 300,
                              child: Row(
                                children: <Widget>[
                                  new Icon(Icons.location_on, size: 14.0),
                                  SizedBox(width: 10.0),
                                  Expanded(
                                    child: Text(
                                      dataJob[i]['kabupatenName'],
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'expressway',
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget displayJobProvince(BuildContext context, String _currentProvince, Function _selectProvince, List _dataProvince) {
      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormField(
          validator: (value) {
            if (_currentProvince == null) {
              return 'Kolom harus diisi (必须填写栏)';
            }
            return null;
          },
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(seconds: 0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
                  child: DropdownButtonFormField(
                    isDense: true,
                    items: _dataProvince != null
                        ? _dataProvince.map((item) {
                      return DropdownMenuItem(
                          value: item['provinsiId'].toString(),
                          child: Text(
                            item['provinsiName'].toString(),
                            style: Theme.of(context).textTheme.bodyText2,
                          ));
                    }).toList()
                        : null,
                    value: _currentProvince == "0" ? null : _currentProvince,
                    onChanged: _selectProvince,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(vertical: ScreenUtil().setSp(10), horizontal: ScreenUtil().setSp(10)),
                      prefixIcon: Icon(Icons.apartment, size: ScreenUtil().setSp(20)),
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor)),
                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      labelText: "Provinsi (省)",
                      labelStyle: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                    ),
                  ),
                ),
                state.errorText != null
                    ? Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    state.errorText,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.red),
                  ),
                )
                    : Container(),
              ],
            );
          },
        )
      ],
    );
  }

  Widget displayJobCity(BuildContext context, String _currentCity, Function _selectCity, List _dataCity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormField(
          validator: (value) {
            if (_currentCity == null) {
              return 'Kolom harus diisi(必须填写栏)';
            }
            return null;
          },
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(seconds: 0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
                  child: DropdownButtonFormField(
                    isDense: true,
                    items: _dataCity != null
                        ? _dataCity.map((item) {
                            return DropdownMenuItem(
                                value: item['kabupatenId'].toString(),
                                child: Text(
                                  item['kabupatenName'].toString(),
                                  style: Theme.of(context).textTheme.bodyText2,
                                ));
                          }).toList()
                        : null,
                    value: _currentCity == "0" ? null : _currentCity,
                    onChanged: _selectCity,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(vertical: ScreenUtil().setSp(10), horizontal: ScreenUtil().setSp(10)),
                      prefixIcon: Icon(Icons.apartment, size: ScreenUtil().setSp(20)),
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor)),
                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      labelText: "Kota/Kabupaten (市/区)",
                      labelStyle: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                    ),
                  ),
                ),
                state.errorText != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          state.errorText,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.red),
                        ),
                      )
                    : Container(),
              ],
            );
          },
        )
      ],
    );
  }
}
