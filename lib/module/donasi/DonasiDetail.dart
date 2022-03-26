import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/donasi/pattern/DonasiPresenter.dart';
import 'package:icati_app/module/donasi/pattern/DonasiView.dart';

class DonasiDetail extends StatefulWidget {
  final String id;

  DonasiDetail({this.id});

  @override
  _DonasiDetailState createState() => _DonasiDetailState();
}

class _DonasiDetailState extends State<DonasiDetail> implements DonasiView {
  DonasiPresenter _donasiPresenter;
  String errorMessage = "";
  bool isFailed = false;
  Map dataDonasi;

  @override
  void initState() {
    super.initState();
    _donasiPresenter = new DonasiPresenter();
    _donasiPresenter.attachView(this);
    _donasiPresenter.getDonasiDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle appBarTextStyle =
        TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: "roboto");
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text("Detail Donasi", style: appBarTextStyle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: dataDonasi == null
          ? isFailed
              ? BaseView().displayErrorMessage(context, onRefresh, errorMessage)
              : BaseView()
                  .displayLoadingScreen(context, color: Colors.blueAccent)
          : RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  FittedBox(
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: dataDonasi['socialPic'],
                          height: 120,
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(FontAwesomeIcons.moneyBillWave,
                                      color: Colors.blueAccent),
                                  SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Target Donasi"),
                                      SizedBox(height: 4),
                                      Text(dataDonasi['socialFundPretty'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(FontAwesomeIcons.calendarAlt,
                                      color: Colors.blueAccent),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Tanggal Donasi"),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                dataDonasi['socialDateRangePretty']
                                                        .toString()
                                                        .isEmpty
                                                    ? "-"
                                                    : dataDonasi[
                                                        'socialDateRangePretty'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                dataDonasi['socialName'],
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    height: 1.5),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: HtmlWidget(dataDonasi['socialDesc'],
                                  textStyle: GoogleFonts.roboto(
                                      fontSize: 13, color: Colors.grey)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<Null> onRefresh() async {
    await _donasiPresenter.getDonasiDetail(widget.id);
  }

  @override
  onFailDonasiDetail(Map data) {
    if (this.mounted) {
      setState(() {
        errorMessage = data['errorMessage'];
        isFailed = true;
      });
    }
  }

  @override
  onSuccessDonasiDetail(Map data) {
    if (this.mounted) {
      setState(() {
        dataDonasi = data['message'];
        isFailed = false;
      });
    }
  }

  @override
  onSuccessDonasiList(Map data) {
    // TODO: implement onSuccessDonasiList
    throw UnimplementedError();
  }

  @override
  onFailDonasiList(Map data) {
    // TODO: implement onFailDonasiList
    throw UnimplementedError();
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }
}
