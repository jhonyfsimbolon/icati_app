import 'package:flutter/material.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/herbal/pattern/HerbalDetailWidgets.dart';
import 'package:icati_app/module/herbal/pattern/HerbalPresenter.dart';
import 'package:icati_app/module/herbal/pattern/HerbalView.dart';

class HerbalDetail extends StatefulWidget {
  final String herbalId;

  HerbalDetail({this.herbalId});

  @override
  _HerbalDetailState createState() => _HerbalDetailState();
}

class _HerbalDetailState extends State<HerbalDetail> implements HerbalView {
  HerbalPresenter _herbalPresenter;
  List _dataDetailHerbal;

  @override
  void initState() {
    _herbalPresenter = new HerbalPresenter();
    _herbalPresenter.attachView(this);
    _herbalPresenter.herbalDetail(widget.herbalId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
              child: _dataDetailHerbal == null
                  ? Container()
                  : _dataDetailHerbal.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            HerbalDetailWidgets().displayBoxPic(
                                context, _dataDetailHerbal[0]['herbalImage']),
                            HerbalDetailWidgets().displayHerbalName(
                                context,
                                _dataDetailHerbal[0]['herbalName']
                                    .toUpperCase(),
                                _dataDetailHerbal[0]['herbalStatus']),
                            HerbalDetailWidgets().displayHerbalDesc(
                                context,
                                _dataDetailHerbal[0]['herbalDesc'],
                                _dataDetailHerbal[0]['herbalLink'])
                          ],
                        )
                      : BaseView().displayErrorMessage(context, _onRefresh,
                          "Tanaman herbal tidak ditemukan")),
        ),
      ),
    );
  }

  Future<Null> _onRefresh() async {
    setState(() {
      _herbalPresenter.herbalDetail(widget.herbalId);
    });
  }

  @override
  onFailHerbalDetail(Map data) {
    if (this.mounted) {
      setState(() {
        _dataDetailHerbal = data['errorMessage'];
        print("ini fail " + _dataDetailHerbal.toString());
      });
    }
  }

  @override
  onFailHerbalList(Map data) {}

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessHerbalDetail(Map data) {
    if (this.mounted) {
      setState(() {
        _dataDetailHerbal = data['message'];
        print("ini sukses " + _dataDetailHerbal.toString());
      });
    }
  }

  @override
  onSuccessHerbalList(Map data) {}
}
