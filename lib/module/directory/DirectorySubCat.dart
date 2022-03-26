import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loadmore/loadmore.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/directory/DirectorySearch.dart';
import 'package:icati_app/module/directory/pattern/DirectoryPresenter.dart';
import 'package:icati_app/module/directory/pattern/DirectoryView.dart';
import 'package:icati_app/module/directory/pattern/DirectoryWidgets.dart';

class DirectorySubCat extends StatefulWidget {
  final String catId;
  final String provinsiId;
  final String kabupatenId;

  DirectorySubCat({this.catId, this.provinsiId, this.kabupatenId});

  @override
  _DirectorySubCatState createState() => _DirectorySubCatState();
}

class _DirectorySubCatState extends State<DirectorySubCat>
    with TickerProviderStateMixin
    implements DirectoryView {
  DirectoryPresenter directoryPresenter;
  List dataDirectory;
  BaseData baseData = BaseData();

  //RefreshController _refreshController = RefreshController(initialRefresh: false);
  int index = 0;
  TabController tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    directoryPresenter = new DirectoryPresenter();
    directoryPresenter.attachView(this);
    baseData.page = 0;
    baseData.isFailed = false;
    directoryPresenter.getDirectorySubCat(
        baseData.page.toString(), widget.catId, "", 0, widget.provinsiId, widget.kabupatenId);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle appBarTextStyle =
        TextStyle(fontSize: 16.0, color: Colors.black87, fontFamily: "roboto");
    return Scaffold(
        appBar: new AppBar(
          title: Text("Direktori Bisnis 企业名录", style: appBarTextStyle),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DirectorySearch(),
                      settings: RouteSettings(name: "Pencarian Direktori")));
                },
                child: Icon(Icons.search, color: Colors.black)),
            SizedBox(
              width: 20,
            )
          ],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: dataDirectory != null && tabController != null
              ? PreferredSize(
                  preferredSize: Size.fromHeight(48),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      isScrollable: true,
                      labelColor: Colors.red,
                      unselectedLabelColor: Colors.grey,
                      controller: tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: UnderlineTabIndicator(
                        borderSide:
                            BorderSide(width: 3.0, color: Colors.redAccent),
                      ),
                      labelStyle: GoogleFonts.roboto(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      tabs: dataDirectory
                          .map(
                            (cat) => Tab(
                                child: Text(cat['mCatName'],
                                    textAlign: TextAlign.center)),
                          )
                          .toList(),
                    ),
                  ),
                )
              : null,
        ),
        backgroundColor: mainColor,
        body: dataDirectory == null && tabController == null
            ? baseData.isFailed
                ? BaseView().displayErrorMessage(
                    context, onRefresh, baseData.errorMessage)
                : BaseView()
                    .displayLoadingScreen(context, color: Colors.blueAccent)
            : TabBarView(
                controller: tabController,
                children: dataDirectory
                    .map((data) => data['data'].length > 0
                        ? subCatList(data)
                        : BaseView().displayErrorMessage(
                            context, onRefresh, "Tidak ada data",
                            textColor: Colors.grey))
                    .toList(),
              ));
  }

  Widget subCatList(Map data) {
    print("status finish " +
        dataDirectory[tabController.index]['isFinish'].toString());
    if (!baseData.isFailed) {
      return RefreshIndicator(
          onRefresh: onRefresh,
          child: LoadMore(
            isFinish: data['data'].length >= data['count']-1,
            onLoadMore: () async {
              await Future.delayed(Duration(milliseconds: 1500));
              if (this.mounted) {
                setState(() {
                  data['page']++;
                });
              }
              await directoryPresenter.getDirectorySubCat(
                  data['page'].toString(),
                  widget.catId,
                  dataDirectory[tabController.index]['mCatId'].toString(),
                  tabController.index,
                  widget.provinsiId,
                  widget.kabupatenId);
              return true;
            },
            whenEmptyLoad: false,
            textBuilder: BaseFunction().indonesianText,
            child: DirectoryWidgets().displaySubCatList(context, data['data']),
          ));
    } else {
      print("error dsini ");
      return BaseView()
          .displayErrorMessage(context, onRefresh, baseData.errorMessage);
    }
  }

  Future<Null> onRefresh() async {
    setState(() {
      dataDirectory = null;
      tabController = null;
    });
    directoryPresenter.getDirectorySubCat("0", widget.catId, "0", 0, widget.provinsiId, widget.kabupatenId);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  _handleTabSelection() {
    if (tabController.indexIsChanging) {
      print("tab cont ");
      print(dataDirectory[tabController.index]['data'].length.toString());
      print(dataDirectory[tabController.index]['count'].toString());
      setState(() {});
    }
  }

  @override
  onNetworkError() {
    BaseFunction()
        .displayToastLong("Connection failed, please try again later");
    Navigator.of(context).pop();
  }

  @override
  onSuccessDirectorySubCat(Map data, String page, int tapIndex) {
    if (this.mounted) {
      setState(() {
        baseData.isFailed = false;
        if (page == "0") {
          dataDirectory = data['message'];
          if (tabController != null) {
            tabController = TabController(
                vsync: this, length: dataDirectory.length, initialIndex: 0);
          } else {
            tabController =
                new TabController(vsync: this, length: dataDirectory.length);
          }
          tabController.addListener(_handleTabSelection);
        } else {
          dataDirectory[tabController.index]['data'].addAll(data['message']);
        }
        if (tabController != null) {
          tabController.animateTo(tapIndex);
        }
        if (dataDirectory[tabController.index]['data'].length >=
            dataDirectory[tabController.index]['count']) {
          dataDirectory[tabController.index]['isFinish'] = true;
        } else {
          dataDirectory[tabController.index]['isFinish'] = false;
        }
      });
    }
  }

  @override
  onFailDirectorySubCat(Map data, String page, int tapIndex) {
    if (this.mounted) {
      setState(() {
        baseData.isFailed = true;
      });
      BaseFunction().displayToastLong(data['errorMessage']);
    }
  }

  @override
  onSuccessDirectorySearch(Map data) {
    // TODO: implement onSuccessDirectorySearch
  }

  @override
  onFailDirectorySearch(Map data) {
    // TODO: implement onFailDirectorySearch
  }

  @override
  onSuccessDirectoryCategory(Map data) {
    // TODO: implement onSuccessDirectoryCategory
  }

  @override
  onFailDirectoryCategory(Map data) {
    // TODO: implement onFailDirectoryCategory
  }

  @override
  onSuccessDirectoryDetail(Map data) {
    // TODO: implement onSuccessDirectoryDetail
  }

  @override
  onFailDirectoryDetail(Map data) {
    // TODO: implement onFailDirectoryDetail
  }

  @override
  onFailCity(Map data) {
    // TODO: implement onFailCity
    throw UnimplementedError();
  }

  @override
  onSuccessCity(Map data) {
    // TODO: implement onSuccessCity
    throw UnimplementedError();
  }

  @override
  onFailProvince(Map data) {
    // TODO: implement onFailProvince
    throw UnimplementedError();
  }

  @override
  onSuccessProvince(Map data) {
    // TODO: implement onSuccessProvince
    throw UnimplementedError();
  }
}
