import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/kabarduka/pattern/KabarDukaPresenter.dart';
import 'package:icati_app/module/kabarduka/pattern/KabarDukaView.dart';
import 'package:icati_app/module/kabarduka/pattern/KabarDukaWidgets.dart';

class KabarDukaDetail extends StatefulWidget {
  final String kabardukaId;
  final String kabardukaNama;

  KabarDukaDetail({this.kabardukaId, this.kabardukaNama});

  @override
  _KabarDukaDetailState createState() => _KabarDukaDetailState();
}

class _KabarDukaDetailState extends State<KabarDukaDetail>
    implements KabarDukaView {
  KabarDukaPresenter _KabarDukaPresenter;

  List _dataKabardukaDetail;

  @override
  void initState() {
    _KabarDukaPresenter = new KabarDukaPresenter();
    _KabarDukaPresenter.attachView(this);
    _KabarDukaPresenter.getKabarDukaDetail(widget.kabardukaId);
    print("id detail" + widget.kabardukaId);
    print("nama detail" + widget.kabardukaNama);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _dataKabardukaDetail == null
            ? BaseView().displayLoadingScreen(context, color: Colors.blueAccent)
            : SafeArea(
                top: false,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                            Color.fromRGBO(159, 28, 42, 1),
                            Color.fromRGBO(159, 28, 42, 1),
                          ])),
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setSp(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 30),
                                Text("BERITA DUKA",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1)),
                                SizedBox(height: 5),
                                Text("Telah Meninggal Dengan Tenang",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14,
                                            letterSpacing: 0.5)),
                                SizedBox(height: 5),
                                Text(
                                    // widget.kabardukaNama,
                                    _dataKabardukaDetail[0]['kabardukaName'] +
                                        " (" +
                                        _dataKabardukaDetail[0]['kabardukaUmur']
                                            .toString() +
                                        " Tahun)",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            letterSpacing: 0.5))
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setSp(30)),
                          Expanded(
                            child: Container(
                              padding:
                                  EdgeInsets.only(top: ScreenUtil().setSp(18)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30)),
                                color: Colors.white,
                              ),
                              child: Container(
                                child: _dataKabardukaDetail != null
                                    ? kabardukaDetail()
                                    : BaseView().displayLoadingScreen(context,
                                        color: Theme.of(context).buttonColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }

  Widget kabardukaDetail() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Column(
        children: [
          KabarDukaWidgets().displayPic(context, _dataKabardukaDetail),
          KabarDukaWidgets().displayContent(context, _dataKabardukaDetail)
        ],
      ),
    );
  }

  Future<Null> _onRefresh() async {
    _KabarDukaPresenter.getKabarDukaDetail(widget.kabardukaId);
  }

  @override
  onFailKabarDuka(Map data) {}

  @override
  onFailKabarDukaDetail(Map data) {
    if (this.mounted) {
      setState(() {
        _dataKabardukaDetail = data['errorMessage'];
      });
    }
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessKabarDuka(Map data) {}

  @override
  onSuccessKabarDukaDetail(Map data) {
    if (this.mounted) {
      setState(() {
        _dataKabardukaDetail = data['message'];
        print(_dataKabardukaDetail);
      });
    }
  }
}
