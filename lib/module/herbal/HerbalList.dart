import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/herbal/HerbalDetail.dart';
import 'package:icati_app/module/herbal/pattern/HerbalPresenter.dart';
import 'package:icati_app/module/herbal/pattern/HerbalView.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HerbalList extends StatefulWidget {
  @override
  _HerbalListState createState() => _HerbalListState();
}

class _HerbalListState extends State<HerbalList> implements HerbalView {
  HerbalPresenter herbalPresenter;
  bool isFailed = false;
  String errorMessage = '';
  List dataHerb;
  int page = 0, totalLength;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var box;

  @override
  void initState() {
    super.initState();
    herbalPresenter = new HerbalPresenter();
    herbalPresenter.attachView(this);
    herbalPresenter.getHerbalList(page.toString());
    getCache();
  }

  void getCache() async {
    if (this.mounted) {
      box = await Hive.openBox("herbCache");
      setState(() {
        final dataBox = box.get("herbCache");
        if (dataBox != null) {
          dataHerb = jsonDecode(dataBox);
          print("tidak null");
        } else {
          print("null");
        }
      });
    }
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
          title: Text("Tanaman Herbal", style: appBarTextStyle),
        ),
        backgroundColor: mainColor,
        body: dataHerb == null
            ? isFailed
                ? BaseView().displayErrorMessage(
                    context, onRefresh, errorMessage, textColor: Colors.black)
                : BaseView().displayLoadingScreen(context,
                    color: Colors.lightBlueAccent)
            : SmartRefresher(
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
                      body = dataHerb.length == totalLength
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
                  itemCount: dataHerb == null ? 0 : dataHerb.length,
                  itemBuilder: (context, i) {
                    print(dataHerb);
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HerbalDetail(
                            herbalId: dataHerb[i]['herbalId'].toString(),
                          ),
                          settings: RouteSettings(name: "Detail HerbalList"),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
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
                                        bottom: 10),
                                    width: 130, //500,
                                    height: 130, //350,
                                    child: FittedBox(
                                      child: Container(
                                        width: 100, //500,
                                        height: 100,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: dataHerb[i]['herbalPic'],
                                            placeholder: (context, i) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Image.asset(
                                                    "assets/images/logo_ts_red.png"),
                                              );
                                            },
                                            errorWidget: (_, __, ___) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Image.asset(
                                                    "assets/images/logo_ts_red.png"),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(height: 16),
                                          Container(
                                            child: Text(
                                              dataHerb[i]['herbalName'],
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          // Container(
                                          //   child: Text(
                                          //     dataHerb[i]['herbalTime'],
                                          //     maxLines: 2,
                                          //     overflow: TextOverflow.ellipsis,
                                          //     style: TextStyle(
                                          //         color: Colors.black,
                                          //         fontFamily: 'roboto ',
                                          //         fontSize: 11.0),
                                          //   ),
                                          // ),
                                          //SizedBox(height: 10),
                                          Container(
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: dataHerb[i]
                                                            ['herbalStatus'] ==
                                                        "Tersedia"
                                                    ? Colors.green
                                                    : Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                  dataHerb[i]['herbalStatus'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline1
                                                      .copyWith(
                                                          fontSize: 10,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )));
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1500));
    if (mounted) {
      if (dataHerb.length < totalLength) {
        setState(() {
          page = page++;
        });
        await herbalPresenter.getHerbalList(page.toString());
      }
      _refreshController.loadComplete();
    }
  }

  Future<Null> onRefresh() async {
    setState(() {
      page = 0;
      dataHerb = null;
    });
    await herbalPresenter.getHerbalList(page.toString());
    _refreshController.refreshCompleted();
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessHerbalList(Map data) async {
    box = await Hive.openBox('herbCache');
    if (this.mounted) {
      setState(() {
        totalLength = data['length'];
        if (page != 0) {
          dataHerb.add(data['message']);
        } else {
          box.put("herbCache", jsonEncode(data['message']));
          dataHerb = data['message'];
        }
        isFailed = false;
      });
    }
  }

  @override
  onFailHerbalList(Map data) {
    if (this.mounted) {
      setState(() {
        isFailed = true;
        errorMessage = data['errorMessage'];
      });
    }
  }

  onSuccessHerbalDetail(Map data) {}

  onFailHerbalDetail(Map data) {}
}
