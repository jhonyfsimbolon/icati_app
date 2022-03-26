import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/donasi/pattern/DonasiPresenter.dart';
import 'package:icati_app/module/donasi/pattern/DonasiView.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'DonasiDetail.dart';

class Donasi extends StatefulWidget {
  @override
  _DonasiState createState() => _DonasiState();
}

class _DonasiState extends State<Donasi> implements DonasiView {
  DonasiPresenter _donasiPresenter;
  bool isFailed = false;
  List dataDonasi;
  int page = 0, totalLength;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _donasiPresenter = new DonasiPresenter();
    _donasiPresenter.attachView(this);
    _donasiPresenter.getDonasiList();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle appBarTextStyle =
        TextStyle(fontSize: 16.0, color: Colors.black87);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Donasi", style: appBarTextStyle),
      ),
      backgroundColor: Colors.white,
      body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: MaterialClassicHeader(),
          controller: _refreshController,
          onRefresh: onRefresh,
          onLoading: _onLoading,
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = dataDonasi.length == totalLength
                    ? Text("No more data")
                    : Text("");
              } else if (mode == LoadStatus.loading) {
                body = BaseView()
                    .displayLoadingScreen(context, color: Colors.blue);
              } else if (mode == LoadStatus.failed) {
                body = Text("Load Failed!Click retry!");
              } else if (mode == LoadStatus.canLoading) {
                //body = Text("release to load more");
              } else {
                //body = Text("No more Data");
              }
              return Container(
                height: 55.0,
                child: Center(child: Container(height: 100, child: body)),
              );
            },
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: dataDonasi == null ? 0 : dataDonasi.length,
            itemBuilder: (context, i) {
              print(dataDonasi);
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        DonasiDetail(id: dataDonasi[i]["socialId"].toString()),
                    settings: RouteSettings(name: "Detail Donasi"),
                  ));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 10),
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
                                    imageUrl: dataDonasi[i]['socialPic'],
                                    placeholder: (context, i) {
                                      return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.asset(
                                            "assets/images/logo_ts_red.png"),
                                      );
                                    },
                                    errorWidget: (_, __, ___) {
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
                            //height: 125,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 0.0, right: 10.0, top: 10),
                                  child: Text(
                                    dataDonasi[i]['socialName'],
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(dataDonasi[i]['socialFundPretty']
                                    .toString()),
                                SizedBox(height: 4),
                                Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          dataDonasi[i]
                                              ['socialDateRangePretty'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'roboto ',
                                              fontSize: 11.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1500));
    if (mounted) {
      if (dataDonasi.length < totalLength) {
        setState(() {
          page = page++;
        });
        await _donasiPresenter.getDonasiList(page: page);
      }
      _refreshController.loadComplete();
    }
  }

  Future<Null> onRefresh() async {
    setState(() {
      page = 0;
      // dataDonasi = null;
    });
    await _donasiPresenter.getDonasiList();
    _refreshController.refreshCompleted();
  }

  @override
  onFailDonasiDetail(Map data) {
    // TODO: implement onFailDonasiDetail
    throw UnimplementedError();
  }

  @override
  onFailDonasiList(Map data) {
    print("failed donasi");
    if (this.mounted) {
      setState(() {
        if (page != 0) {
          page = page--;
        }
        isFailed = true;
      });
    }
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessDonasiDetail(Map data) {}

  @override
  onSuccessDonasiList(Map data) {
    if (this.mounted) {
      setState(() {
        totalLength = data['length'];
        if (page != 0) {
          dataDonasi.add(data['message']);
        } else {
          dataDonasi = data['message'];
        }
        isFailed = false;
      });
    }
  }
}
