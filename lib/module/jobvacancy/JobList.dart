import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:loadmore/loadmore.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/jobvacancy/JobSearch.dart';
import 'package:icati_app/module/jobvacancy/addJob/AddJobVacancy.dart';
import 'package:icati_app/module/jobvacancy/pattern/JobPresenter.dart';
import 'package:icati_app/module/jobvacancy/pattern/JobView.dart';
import 'package:icati_app/module/jobvacancy/pattern/JobWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobList extends StatefulWidget {
  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList>
    with TickerProviderStateMixin
    implements JobView {
  JobPresenter jobPresenter;
  List dataJob, datajobList;
  BaseData baseData = BaseData();
  TabController tabController;
  var box;
  String _currentProvince, _currentCity;
  List _dataProvince, _dataCity;
  bool isRefresh = false;

  @override
  void initState() {
    super.initState();
    jobPresenter = new JobPresenter();
    jobPresenter.attachView(this);
    baseData.isFailed = false;
    baseData.isLogin = false;
    jobPresenter.getProvince();
    _getCredential();
  }

  _getCredential() async {
    if (!mounted) return;
    box = await Hive.openBox("jobCache");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    baseData.isLogin =
        prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
    if (box.isOpen) {
      if (this.mounted) {
        setState(() {
          final dataBox = box.get("jobCache");
          if (dataBox != null) {
            dataJob = jsonDecode(dataBox);
            if (tabController != null) {
              tabController = TabController(
                  vsync: this,
                  length: dataJob.length,
                  initialIndex: tabController.index);
              print("ini 1 api");
            } else {
              tabController =
                  new TabController(vsync: this, length: dataJob.length);
              print("ini 2 api");
            }
            print("ini 2");
            print("ini data job cache " + dataJob.toString());
            print("ini tab controller " + tabController.toString());
          }
        });
      }
    }
    await jobPresenter.getCategoryJob();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle appBarTextStyle =
        TextStyle(fontSize: 16.0, color: Colors.black87, fontFamily: "roboto");
    return Scaffold(
      appBar: new AppBar(
        title: Text("Lowongan Kerja 工作", style: appBarTextStyle),
        backgroundColor: Colors.white,
        elevation: 0, titleSpacing: -10,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => JobSearch(),
              ));
            },
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120.0),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 0.0, right: 10, left: 10, bottom: 10),
            child: Column(
              children: [
                JobWidgets().displayJobProvince(
                    context, _currentProvince, _selectProvince, _dataProvince),
                SizedBox(height: ScreenUtil().setSp(10)),
                JobWidgets().displayJobCity(
                  context,
                  _currentCity,
                  _selectCity,
                  _dataCity,
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 0.0, right: 10, left: 10),
                //   child: DirectoryWidgets().displaySearchBox(
                //       context, _currentCity, _selectCity, _dataCity),
                // ),
              ],
            ),
          ),
        ),
        // bottom: dataJob != null && tabController != null
        //     ? PreferredSize(
        //         preferredSize: Size.fromHeight(48),
        //         child: Align(
        //           alignment: Alignment.centerLeft,
        //           child: TabBar(
        //             isScrollable: true,
        //             labelColor: Colors.red,
        //             unselectedLabelColor: Colors.grey,
        //             controller: tabController,
        //             indicatorSize: TabBarIndicatorSize.tab,
        //             indicator: UnderlineTabIndicator(
        //               borderSide:
        //                   BorderSide(width: 3.0, color: Colors.redAccent),
        //             ),
        //             labelStyle: GoogleFonts.roboto(
        //               textStyle: Theme.of(context).textTheme.headline4,
        //               fontSize: 13,
        //               color: Colors.black87,
        //               fontWeight: FontWeight.bold,
        //             ),
        //             tabs: dataJob
        //                 .map(
        //                   (cat) => Tab(
        //                       child: Text(cat['mCatName'].toString(),
        //                           textAlign: TextAlign.center)),
        //                 )
        //                 .toList(),
        //           ),
        //         ),
        //       )
        //     : null,
      ),
      backgroundColor: mainColor,
      body: dataJob == null
          ? baseData.isFailed
              ? BaseView().displayErrorMessage(
                  context, onRefresh, baseData.errorMessage)
              : BaseView()
                  .displayLoadingScreen(context, color: Colors.blueAccent)
          : TabBarView(
              controller: tabController,
              children: dataJob
                  .map(
                    (cat) => cat['data'].isEmpty
                        ? BaseView().displayErrorMessage(
                            context, onRefresh, "Tidak ada data",
                            textColor: Colors.grey)
                        : jobList(cat),
                  )
                  .toList(),
            ),
      floatingActionButton: baseData.isLogin
          ? FloatingActionButton.extended(
              backgroundColor: Colors.green,
              icon: Icon(Icons.add),
              label: Text('Tambah Lowongan Kerja'),
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddJobVacancy(),
                ));
              },
            )
          : SizedBox(),
    );
  }

  Widget jobList(var data) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Colors.black,
      child: LoadMore(
          isFinish: data['data'].length >= data['count'],
          onLoadMore: _loadMore,
          whenEmptyLoad: false,
          textBuilder: _indonesianText,
          child: JobWidgets().displayListJobVacancy(context, data['data'])),
    );
  }

  String _indonesianText(LoadMoreStatus status) {
    String text;
    switch (status) {
      case LoadMoreStatus.fail:
        text = "Loading Gagal, Silahkan coba lagi.";
        break;
      case LoadMoreStatus.idle:
        text = "Loading";
        break;
      case LoadMoreStatus.loading:
        text = "Loading ...";
        break;
      case LoadMoreStatus.nomore:
        text = "";
        break;
      default:
        text = "";
    }
    return text;
  }

  Future<bool> _loadMore() async {
    setState(() {
      dataJob[tabController.index]['page']++;
    });
    await jobPresenter.getJobListAll(
        _currentProvince != null ? _currentProvince : "0",
        _currentCity != null ? _currentCity : "0",
        dataJob[tabController.index]['page'].toString());
    return true;
  }

  // Widget jobList(List data) {
  //   RefreshController refreshController =
  //   RefreshController(initialRefresh: false);
  //   return SmartRefresher(
  //     enablePullDown: true,
  //     enablePullUp: true,
  //     header: MaterialClassicHeader(),
  //     controller: refreshController,
  //     onRefresh: onRefresh,
  //     onLoading: () async {
  //       //tabController.addListener(_handleTabSelection);
  //       dataJob[tabController.index]['page']++;
  //       print("ini page loading " + dataJob[tabController.index]['page'].toString());
  //       print("ini cityId loading " + dataJob[tabController.index]['mCatId'].toString().toString());
  //       print("ini tabIndex loading " + tabController.index.toString());
  //       await Future.delayed(Duration(milliseconds: 1000));
  //       jobPresenter.getJobListAll(dataJob[tabController.index]['mCatId'].toString(), dataJob[tabController.index]['page'].toString());
  //       refreshController.loadComplete();
  //     },
  //     footer: CustomFooter(
  //       builder: (BuildContext context, LoadStatus mode) {
  //         Widget body;
  //         if (mode == LoadStatus.idle) {
  //           print("ini iddle");
  //           body = Container();
  //         } else if (mode == LoadStatus.loading) {
  //           print("ini loading");
  //           body = BaseView().displayLoadingScreen(context);
  //         } else if (mode == LoadStatus.failed) {
  //           body = Text("Load Failed!Click retry!");
  //         } else if (mode == LoadStatus.canLoading) {
  //           print("ini can loading");
  //           //body = Text("release to load more");
  //         } else {
  //           print("ini else");
  //           //body = Text("No more Data");
  //         }
  //         return Container(
  //           height: 55.0,
  //           child: Center(child: Container(height: 100, child: body)),
  //         );
  //       },
  //     ),
  //     child: JobWidgets().displayListJobVacancy(context, data),
  //   );
  // }

  Future<Null> onRefresh() async {
    setState(() {
      isRefresh = true;
    });
    // await jobPresenter.getCategoryJob();
    await jobPresenter.getJobListAll(
        _currentProvince != null ? _currentProvince : "0",
        _currentCity != null ? _currentCity : "0",
        dataJob[tabController.index]['page'].toString());
  }

  void _selectCity(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentCity = value;
      print("current kabupaten select " + _currentCity);
      jobPresenter.getJobListAll(
          _currentProvince != null ? _currentProvince : "0",
          _currentCity != null ? _currentCity : "0",
          dataJob[tabController.index]['page'].toString());
    });
  }

  void _selectProvince(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentProvince = value;
      print("current provinsi select " + _currentProvince);
      if (_currentProvince != null) {
        this._currentCity = null;
        jobPresenter.getCity(this._currentProvince);
        jobPresenter.getJobListAll(
            _currentProvince != null ? _currentProvince : "0",
            _currentCity != null ? _currentCity : "0",
            dataJob[tabController.index]['page'].toString());
        print("contoh" + _currentProvince != null ? _currentProvince : "0");
      }
    });
  }

  _handleTabSelection() {
    if (tabController.indexIsChanging) {
      print("benar");
    }
  }

  @override
  onNetworkError() {
    BaseFunction()
        .displayToastLong("Connection failed, please try again later");
    Navigator.of(context).pop();
  }

  @override
  onSuccessJobList(Map data, int tabIndex) async {}

  @override
  onFailJobList(Map data, int tabIndex) {}

  @override
  onSuccessJobDetail(Map data) {}

  @override
  onFailJobDetail(Map data) {}

  @override
  onSuccessJobSearch(Map data) {}

  @override
  onFailJobSearch(Map data) {}

  @override
  onFailJobCategory(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isFailed = true;
        baseData.errorMessage = data["errorMessage"].toString();
      });
    }
  }

  @override
  onSuccessJobCategory(Map data) async {
    box = await Hive.openBox('jobCache');
    if (this.mounted) {
      setState(() {
        baseData.isFailed = false;
        dataJob = data['message'];
        box.put("jobCache", jsonEncode(dataJob));
        print("ini data job Api " + dataJob.toString());
        if (tabController != null) {
          tabController = TabController(
              vsync: this,
              length: dataJob.length,
              initialIndex: tabController.index);
          print("ini 1 api");
        } else {
          tabController =
              new TabController(vsync: this, length: dataJob.length);
          print("ini 2 api");
        }
        // if (!isRefresh) {
        //   tabController =
        //   new TabController(vsync: this, length: dataJob.length);
        // }
        // else {
        //   tabController = TabController(
        //     vsync: this,
        //     length: dataJob.length,
        //     initialIndex: tabController.index,
        //   );
        // }
      });
    }
  }

  @override
  onFailJobListAll(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isFailed = true;
        dataJob[tabController.index]['data'] = [];
      });
    }
  }

  @override
  onSuccessJobListAll(Map data) {
    if (mounted) {
      setState(() {
        // dataJob = data['message'];
        // dataJob = null;
        dataJob[tabController.index]['data'] = [];
        dataJob[tabController.index]['count'] = data['count'];
        dataJob[tabController.index]['data'].addAll((data['message']));
        datajobList = data['message'];
        print("ini data job all " + dataJob.toString());
      });
    }
  }

  @override
  onFailCity(Map data) {
    if (this.mounted) {
      setState(() {
        _dataCity = data['errorMessage'];
      });
    }
  }

  @override
  onFailProvince(Map data) {
    if (this.mounted) {
      setState(() {
        _dataProvince = data['errorMessage'];
      });
    }
  }

  @override
  onSuccessCity(Map data) {
    if (this.mounted) {
      setState(() {
        _dataCity = data['message'];
        print("ini kota " + _dataCity.toString());
      });
    }
  }

  @override
  onSuccessProvince(Map data) {
    if (this.mounted) {
      setState(() {
        _dataProvince = data['message'];
        if (_currentProvince != null) {
          print("proses mengambil data kabupaten");
          jobPresenter.getCity(this._currentProvince);
        }
        // if (_dataProvince != null) {
        //   // _currentProvince = _dataProvince
        //   //     .where((element) => element['provinsiName'].toString() == "RIAU")
        //   //     .first['provinsiId']
        //   //     .toString();
        //   // print("ini provinsiId " + _currentProvince);
        //
        //   if (this._currentProvince != null) {
        //     _addDirectoryPresenter.getCity(this._currentProvince);
        //   }
        // }
      });
    }
  }
}
