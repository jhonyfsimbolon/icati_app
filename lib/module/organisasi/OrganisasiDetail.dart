import 'dart:async';
import 'package:flutter/material.dart';
import 'package:icati_app/module/organisasi/pattern/OrganisasiPresenter.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/organisasi/pattern/OrganisasiView.dart';
import 'package:icati_app/module/organisasi/pattern/OrganisasiWidgets.dart';

class OrganisasiDetail extends StatefulWidget {
  OrganisasiDetail({this.id});

  final String id;

  @override
  _OrganisasiDetailState createState() => _OrganisasiDetailState();
}

class _OrganisasiDetailState extends State<OrganisasiDetail>
    implements OrganisasiView {
  OrganisasiPresenter _organisasiPresenter;

  List _dataOrganisasiDetail;

  @override
  void initState() {
    _organisasiPresenter = new OrganisasiPresenter();
    _organisasiPresenter.attachView(this);
    _organisasiPresenter.getOrganisasiDetail(widget.id);
    super.initState();
  }

  Future<Null> onRefresh() async {
    setState(() {
      _dataOrganisasiDetail = null;
    });
    _organisasiPresenter.getOrganisasiDetail(widget.id);
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
          title: Text("Organisasi 组织", style: appBarTextStyle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: _dataOrganisasiDetail == null
            ? BaseView().displayLoadingScreen(context, color: Colors.blueAccent)
            : organisasiDetail());
  }

  Widget organisasiDetail() {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        child: Column(
          children: [
            OrganisasiWidgets().displayBoxPic(
                context,
                _dataOrganisasiDetail[0]['urlSource'],
                _dataOrganisasiDetail[0]['organizationName']),
            OrganisasiWidgets().displayBoxContact(
                context,
                _dataOrganisasiDetail[0]['organizationWebsite'],
                _dataOrganisasiDetail[0]['organizationEmail'],
                _dataOrganisasiDetail[0]['organizationPhone']),
            OrganisasiWidgets().displayBoxInfo(
                context, _dataOrganisasiDetail[0]['organizationDesc']),
            OrganisasiWidgets().displayBoxMediaSisiol(
                context,
                _dataOrganisasiDetail[0]['organizationFacebook'],
                _dataOrganisasiDetail[0]['organizationInstagram'],
                _dataOrganisasiDetail[0]['organizationTwitter'],
                _dataOrganisasiDetail[0]['organizationYoutube'],
                _dataOrganisasiDetail[0]['organizationTiktok'],
                _dataOrganisasiDetail[0]['organizationWA'],
                _dataOrganisasiDetail[0]['organizationTelegram']),
          ],
        ),
      ),
    );
  }

  @override
  onSuccessOrganisasiList(Map data) {
    // TODO: implement onSuccessOrganisasiList
  }

  @override
  onFailOrganisasiList(Map data) {
    // TODO: implement onFailOrganisasiList
  }

  @override
  onFailOrganisasiDetail(Map data) {
    // TODO: implement onFailOrganisasiDetail
    throw UnimplementedError();
  }

  @override
  onFailOrganisasi(Map data) {
    // TODO: implement onFailOrganisasi
    throw UnimplementedError();
  }

  @override
  onSuccessOrganisasi(Map data) {
    // TODO: implement onSuccessOrganisasi
    throw UnimplementedError();
  }

  @override
  onNetworkError() {
    BaseFunction()
        .displayToastLong("Connection failed, please try again later");
    Navigator.of(context).pop();
  }

  @override
  onSuccessOrganisasiDetail(Map data) {
    if (this.mounted) {
      setState(() {
        _dataOrganisasiDetail = data['message'];
        // baseData.isFailed = false;
      });
    }
  }
}
