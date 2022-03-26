import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/agenda/pattern/AgendaPresenter.dart';
import 'package:icati_app/module/agenda/pattern/AgendaView.dart';
import 'package:icati_app/module/agenda/pattern/AgendaWidgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Agenda extends StatefulWidget {
  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda>
    with TickerProviderStateMixin
    implements AgendaView {
  AgendaPresenter agendaPresenter;
  List dataAgenda;
  BaseData baseData = BaseData();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int index = 0;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    agendaPresenter = new AgendaPresenter();
    agendaPresenter.attachView(this);
    baseData.page = 0;
    baseData.isFailed = false;
    agendaPresenter.getAgendaList(baseData.page.toString());
  }

  @override
  Widget build(BuildContext context) {
    TextStyle appBarTextStyle =
        TextStyle(fontSize: 16.0, color: Colors.black87, fontFamily: "roboto");
    return Scaffold(
        appBar: new AppBar(
          title: Text("Agenda Kegiatan 活动议程", style: appBarTextStyle),
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: -10,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // bottom: dataAgenda != null && tabController != null
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
          //             tabs: dataAgenda
          //                 .map(
          //                   (cat) => Tab(
          //                       child: Text(cat['kabupatenName'],
          //                           textAlign: TextAlign.center)),
          //                 )
          //                 .toList(),
          //           ),
          //         ),
          //       )
          //     : null,
        ),
        backgroundColor: mainColor,
        body: dataAgenda == null
            ? baseData.isFailed
                ? BaseView().displayErrorMessage(
                    context, onRefresh, baseData.errorMessage)
                : BaseView()
                    .displayLoadingScreen(context, color: Colors.blueAccent)
            : agendaList());
    // : TabBarView(
    //     controller: tabController,
    //     children: dataAgenda
    //         .map((data) => data['data'].length > 0
    //             ? agendaList(data['data'])
    //             : BaseView().displayErrorMessage(
    //                 context, onRefresh, "Tidak ada data",
    //                 textColor: Colors.grey))
    //         .toList(),
    //   ));
  }

  Widget agendaList() {
    return SmartRefresher(
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
              body = dataAgenda.length == baseData.dataLength
                  ? Text("No more data")
                  : Text("");
            } else if (mode == LoadStatus.loading) {
              body = BaseView().displayLoadingScreen(context);
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
        child: AgendaWidgets().displayAgendaList(
          context,
          dataAgenda,
        ));
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) {
      if (dataAgenda.length < baseData.dataLength) {
        setState(() {
          baseData.page = baseData.page + 1;
          // agendaPresenter.getAgendaListMore(dataAgenda[index]['kabupatenId'],
          //     baseData.page.toString(), tabController.index);
          agendaPresenter.getAgendaList(baseData.page.toString());
        });
      } else {
        print("no more list");
      }
      _refreshController.loadComplete();
    }
  }

  Future<Null> onRefresh() async {
    setState(() {
      dataAgenda = null;
      tabController = null;
    });
    agendaPresenter.getAgendaList(baseData.page.toString());
  }

  _handleTabSelection() {
    if (tabController.indexIsChanging) {
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
  onSuccessAgendaList(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isFailed = false;
        baseData.dataLength = data['length'];
        dataAgenda = data['message'];
        tabController =
            new TabController(vsync: this, length: dataAgenda.length);
        tabController.addListener(_handleTabSelection);
      });
    }
  }

  @override
  onFailAgendaList(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isFailed = true;
        baseData.errorMessage = data['errorMessage'];
      });
    }
  }

  @override
  onSuccessAgendaListMore(Map data, int tabIndex) {
    if (this.mounted) {
      setState(() {
        baseData.isFailed = false;
        tabController.animateTo(tabIndex);
        dataAgenda.addAll(data['message']);
      });
    }
  }

  @override
  onFailAgendaListMore(Map data, int tabIndex) {
    if (this.mounted) {
      setState(() {
        baseData.isFailed = true;
        tabController.animateTo(tabIndex);
        baseData.errorMessage = data['errorMessage'];
      });
    }
  }

  @override
  onSuccessAgendaDetail(Map data) {
    // TODO: implement onSuccessAgendaDetail
  }

  @override
  onFailAgendaDetail(Map data) {
    // TODO: implement onFailAgendaDetail
  }
}
