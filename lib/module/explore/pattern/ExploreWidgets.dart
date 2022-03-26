import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/module/explore/DetailExplore.dart';

class ExploreWidgets {
  Widget displayNegara(BuildContext context, String _currentNegara,
      Function _selectNegara, List _dataNegara) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // IgnorePointer(
        // ignoring: true,
        FormField(
          validator: (value) {
            if (_currentNegara == null || _currentNegara == "0") {
              return 'Kolom harus diisi';
            }
            return null;
          },
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(seconds: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(blurRadius: 2, color: Colors.grey)
                      ]),
                  child: DropdownButtonFormField(
                    isDense: true,
                    isExpanded: true,
                    // iconDisabledColor: Colors.white,
                    // iconEnabledColor: Colors.white,
                    items: _dataNegara != null
                        ? _dataNegara.map((item) {
                            return DropdownMenuItem(
                                value: item['negaraId'].toString(),
                                child: Text(item['negaraName'].toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyText2));
                          }).toList()
                        : null,
                    value: _currentNegara == "0" ? null : _currentNegara,
                    onChanged: _selectNegara,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: ScreenUtil().setSp(10),
                            horizontal: ScreenUtil().setSp(10)),
                        prefixIcon:
                            Icon(Icons.apartment, size: ScreenUtil().setSp(20)),
                        fillColor: Colors.white,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).focusColor)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        labelText: "Negara 国家",
                        labelStyle: GoogleFonts.roboto(
                            fontSize: ScreenUtil().setSp(12))),
                  ),
                ),
                state.errorText != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          state.errorText,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: Colors.red),
                        ),
                      )
                    : Container(),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget displayProvince(BuildContext context, String _currentProvince,
      Function _selectProvince, List _dataProvince) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // IgnorePointer(
        //   ignoring: true,
        FormField(
          validator: (value) {
            if (_currentProvince == null || _currentProvince == "0") {
              return 'Kolom harus diisi';
            }
            return null;
          },
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(seconds: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(blurRadius: 2, color: Colors.grey)
                      ]),
                  child: DropdownButtonFormField(
                    isDense: true,
                    // iconDisabledColor: Colors.white,
                    // iconEnabledColor: Colors.white,
                    items: _dataProvince != null
                        ? _dataProvince.map((item) {
                            return DropdownMenuItem(
                                value: item['provinsiId'].toString(),
                                child: Text(item['provinsiName'].toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyText2));
                          }).toList()
                        : null,
                    value: _currentProvince == "0" ? null : _currentProvince,
                    onChanged: _selectProvince,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: ScreenUtil().setSp(10),
                            horizontal: ScreenUtil().setSp(10)),
                        prefixIcon:
                            Icon(Icons.apartment, size: ScreenUtil().setSp(20)),
                        fillColor: Colors.white,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).focusColor)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        labelText: "Provinsi 省",
                        labelStyle: GoogleFonts.roboto(fontSize: 12)),
                  ),
                ),
                state.errorText != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          state.errorText,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: Colors.red),
                        ),
                      )
                    : Container(),
              ],
            );
          },
        ),
        // )
      ],
    );
  }

  // Widget displaySearchBox(BuildContext context, String _currentCity,
  //     Function _selectCity, List _dataCity) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       FormField(
  //         validator: (value) {
  //           if (_currentCity == null) {
  //             return 'Kolom harus diisi';
  //           }
  //           return null;
  //         },
  //         builder: (state) {
  //           return Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               AnimatedContainer(
  //                 duration: Duration(seconds: 0),
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(10),
  //                     boxShadow: [
  //                       BoxShadow(blurRadius: 2, color: Colors.grey)
  //                     ]),
  //                 child: DropdownButtonFormField(
  //                   isDense: true,
  //                   items: _dataCity != null
  //                       ? _dataCity.map((item) {
  //                           return DropdownMenuItem(
  //                               value: item['provinsiId'].toString(),
  //                               child: Text(
  //                                 item['provinsiName'].toString(),
  //                                 style: Theme.of(context).textTheme.bodyText2,
  //                               ));
  //                         }).toList()
  //                       : null,
  //                   value: _currentCity == "0" ? null : _currentCity,
  //                   onChanged: _selectCity,
  //                   style: Theme.of(context).textTheme.bodyText2,
  //                   decoration: InputDecoration(
  //                     contentPadding: new EdgeInsets.symmetric(
  //                         vertical: ScreenUtil().setSp(10),
  //                         horizontal: ScreenUtil().setSp(10)),
  //                     prefixIcon:
  //                         Icon(Icons.apartment, size: ScreenUtil().setSp(20)),
  //                     prefixText: "Provinsi:\t\t\t",
  //                     prefixStyle: Theme.of(context)
  //                         .textTheme
  //                         .bodyText2
  //                         .copyWith(color: Colors.black45),
  //                     fillColor: Colors.white,
  //                     filled: true,
  //                     border: new OutlineInputBorder(
  //                       borderRadius: new BorderRadius.circular(10),
  //                     ),
  //                     focusedBorder: OutlineInputBorder(
  //                         borderSide:
  //                             BorderSide(color: Theme.of(context).focusColor)),
  //                     errorBorder: OutlineInputBorder(
  //                         borderSide: BorderSide(color: Colors.red)),
  //                     labelStyle:
  //                         GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
  //                   ),
  //                 ),
  //               ),
  //               state.errorText != null
  //                   ? Padding(
  //                       padding: const EdgeInsets.only(top: 8),
  //                       child: Text(
  //                         state.errorText,
  //                         style: Theme.of(context)
  //                             .textTheme
  //                             .bodyText2
  //                             .copyWith(color: Colors.red),
  //                       ),
  //                     )
  //                   : Container(),
  //             ],
  //           );
  //         },
  //       )
  //     ],
  //   );
  // }

  Widget displayCity(BuildContext context, String _currentCity,
      Function _selectCity, List _dataCity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormField(
          validator: (value) {
            if (_currentCity == null || _currentCity == "0") {
              return 'Kolom harus diisi';
            }
            return null;
          },
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(seconds: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(blurRadius: 2, color: Colors.grey)
                      ]),
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
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: ScreenUtil().setSp(10),
                            horizontal: ScreenUtil().setSp(10)),
                        prefixIcon:
                            Icon(Icons.apartment, size: ScreenUtil().setSp(20)),
                        fillColor: Colors.white,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).focusColor)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        labelText: "Kota/Kabupaten 城市",
                        labelStyle: GoogleFonts.roboto(fontSize: 12)),
                  ),
                ),
                state.errorText != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          state.errorText,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: Colors.red),
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

  Widget displayExplore(BuildContext context, List dataExplore, String mId) {
    return Expanded(
      child: StaggeredGridView.countBuilder(
          padding: EdgeInsets.all(10),
          crossAxisCount: 3,
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
          // gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 3, childAspectRatio: 0.9),
          itemCount: dataExplore.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        DetailExplore(dataExplore: dataExplore[i], mId: mId)));
              },
              child: Container(
                height: 135,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  //color: Colors.grey.withOpacity(0.5),
                ),
                margin: EdgeInsets.only(
                    top: 0.0, bottom: 0.0, right: 3.0, left: 3.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: dataExplore[i]['pic'] == ""
                          ? "http://icati.or.id/assets/images/account_picture_default.png"
                          : dataExplore[i]['pic'],
                      imageBuilder: (context, imageProvider) => Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, i) {
                        return Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/logo_ts_red.png'),
                                fit: BoxFit.cover),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) => Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/account_picture_default.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        dataExplore[i]['mName'],
                        style: TextStyle(fontSize: 11, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget displayExploreNotFound(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(FontAwesomeIcons.users,
                  size: 48.0, color: Colors.black45),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Member tidak ditemukan",
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
