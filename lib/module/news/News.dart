import 'package:flutter/material.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/news/pattern/NewsPresenter.dart';
import 'package:icati_app/module/news/pattern/NewsView.dart';
import 'package:icati_app/module/news/pattern/NewsWidgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News>
    with SingleTickerProviderStateMixin
    implements NewsView {
  NewsPresenter newsPresenter;
  List dataNews;
  BaseData baseData = BaseData();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int selectedPage = 0;

  @override
  void initState() {
    super.initState();
    newsPresenter = new NewsPresenter();
    newsPresenter.attachView(this);
    baseData.page = 0;
    baseData.isFailed = false;
    newsPresenter.getNewsList(baseData.page.toString());
  }

  @override
  Widget build(BuildContext context) {
    TextStyle appBarTextStyle =
        TextStyle(fontSize: 16.0, color: Colors.black87, fontFamily: "roboto");
    return Scaffold(
        appBar: new AppBar(
          title: Text("Berita 消息", style: appBarTextStyle),
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
        ),
        backgroundColor: mainColor,
        body: dataNews == null
            ? baseData.isFailed
                ? BaseView().displayErrorMessage(
                    context, onRefresh, baseData.errorMessage)
                : BaseView()
                    .displayLoadingScreen(context, color: Colors.blueAccent)
            : newsList());
  }

  Widget newsList() {
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
              body = dataNews.length == baseData.dataLength
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
        child: NewsWidgets().displayNewsList(context, dataNews));
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) {
      if (dataNews.length < baseData.dataLength) {
        setState(() {
          baseData.page = baseData.page + 1;
          newsPresenter.getNewsList(baseData.page.toString());
        });
      } else {
        print("no more list");
      }
      _refreshController.loadComplete();
    }
  }

  Future<Null> onRefresh() async {
    setState(() {
      dataNews = null;
    });
    newsPresenter.getNewsList(baseData.page.toString());
  }

  // onSelectPage(){
  //   if(mounted){
  //     setState(() {
  //       selectedPage
  //     });
  //   }
  // }

  @override
  onNetworkError() {
    BaseFunction()
        .displayToastLong("Connection failed, please try again later");
    Navigator.of(context).pop();
  }

  @override
  onSuccessNewsList(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isFailed = false;
        baseData.dataLength = data['length'];
        if (baseData.page == 0) {
          dataNews = data['message'];
        } else {
          dataNews.addAll(data['message']);
        }
      });
    }
  }

  @override
  onFailNewsList(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isFailed = true;
        baseData.errorMessage = data['errorMessage'];
      });
    }
  }

  @override
  onSuccessNewsDetail(Map data) {
    // TODO: implement onSuccessNewsDetail
  }

  @override
  onFailNewsDetail(Map data) {
    // TODO: implement onFailNewsDetail
  }

  @override
  onSuccessAddComment(Map data) {
    // TODO: implement onSuccessAddComment
  }

  @override
  onFailAddComment(Map data) {
    // TODO: implement onFailAddComment
  }
}
