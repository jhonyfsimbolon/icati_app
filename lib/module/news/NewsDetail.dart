import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/news/pattern/NewsPresenter.dart';
import 'package:icati_app/module/news/pattern/NewsView.dart';
import 'package:icati_app/module/news/pattern/NewsWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsDetail extends StatefulWidget {
  NewsDetail({this.id});

  final String id;

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> implements NewsView {
  NewsPresenter newsPresenter;
  List dataNews;
  BaseData baseData = BaseData();
  Member member = Member();

  int selectedPage = 0;

  TextEditingController nameCont = new TextEditingController();
  TextEditingController emailCont = new TextEditingController();
  TextEditingController msgCont = new TextEditingController();
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    newsPresenter = new NewsPresenter();
    newsPresenter.attachView(this);
    baseData.isFailed = false;
    baseData.isSaving = false;
    baseData.autoValidate = false;
    baseData.errorMessage = "";
    newsPresenter.getNewsDetail(widget.id);
    getCredential();
    super.initState();
  }

  getCredential() async {
    if (!mounted) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      baseData.isLogin =
          prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
      if (baseData.isLogin) {
        final user = prefs.getString("member");
        final List data = jsonDecode(user);
        member.mId = data[0]['mId'].toString();
        member.mName = data[0]['mName'].toString();
        member.mEmail = data[0]['mEmail'].toString();
      }
    });
  }

  Future<Null> onRefresh() async {
    setState(() {
      dataNews = null;
    });
    newsPresenter.getNewsDetail(widget.id);
  }

  Future<Null> getNewComment() async {
    if (this.mounted) {
      setState(() {
        msgCont.clear();
      });
    }
    newsPresenter.getNewsDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle appBarTextStyle =
        TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: "roboto");
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: -10,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          title: Text("Berita 消息", style: appBarTextStyle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: dataNews == null
            ? baseData.isFailed
                ? BaseView().displayErrorMessage(
                    context, onRefresh, baseData.errorMessage)
                : BaseView()
                    .displayLoadingScreen(context, color: Colors.blueAccent)
            : newsDetail());
  }

  Widget newsDetail() {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        child: Column(
          children: [
            NewsWidgets().displayNewsPic(context, dataNews),
            NewsWidgets().displayNewsContent(context, dataNews, selectedPage),
            dataNews[0]["newsContent"].length > 1
                ? Container(
                    margin: EdgeInsets.only(right: 10, left: 10),
                    color: Colors.white,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        selectedPage == 0
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedPage -= 1;
                                  });
                                },
                                child: Text(
                                  "< Previous\t",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                        // Text(" ... "),
                        // dataNews[0]["newsContent"]
                        //     .map(
                        //         (item) => new Text(item['newsPage'].toString()))
                        //     .toList(),
                        selectedPage < dataNews[0]["newsContent"].length - 1
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedPage += 1;
                                  });
                                },
                                child: Text(
                                  "\tNext >",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  )
                : Container(),
            NewsWidgets().displayComment(context, dataNews[0]['comments']),
            baseData.isLogin
                ? NewsWidgets().displaySendComment(
                    context,
                    nameCont,
                    emailCont,
                    msgCont,
                    formKey,
                    baseData.autoValidate,
                    baseData.isSaving,
                    submit,
                    sendComment)
                : Container()
          ],
        ),
      ),
    );
  }

  submit() async {
    final form = formKey.currentState;
    setState(() {
      baseData.isSaving = true;
    });
    if (form.validate()) {
      form.save();
      sendComment();
    } else {
      setState(() {
        baseData.autoValidate = true;
        baseData.isSaving = false;
      });
    }
  }

  sendComment() async {
    if (formKey.currentState.validate()) {
      print("send comment");
      print(widget.id);
      print(member.mName);
      print(member.mEmail);
      print(msgCont.text);
      await newsPresenter.addCommentNews(
          widget.id, member.mName, member.mEmail, msgCont.text);
    } else {
      setState(() {
        baseData.autoValidate = true;
        baseData.isSaving = false;
      });
    }
  }

  @override
  onNetworkError() {
    BaseFunction()
        .displayToastLong("Connection failed, please try again later");
    Navigator.of(context).pop();
  }

  @override
  onSuccessNewsDetail(Map data) {
    if (this.mounted) {
      setState(() {
        dataNews = data['message'];
        baseData.isFailed = false;
      });
    }
  }

  @override
  onFailNewsDetail(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.errorMessage = data['errorMessage'];
        baseData.isFailed = true;
      });
    }
  }

  @override
  onSuccessNewsList(Map data) {
    // TODO: implement onSuccessNewsList
  }

  @override
  onFailNewsList(Map data) {
    // TODO: implement onFailNewsList
  }

  @override
  onSuccessAddComment(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isSaving = false;
      });
      getNewComment();
    }
  }

  @override
  onFailAddComment(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isSaving = false;
      });
      BaseFunction().displayToastLong(data['errorMessage']);
    }
  }
}
