import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/directory/pattern/DirectoryPresenter.dart';
import 'package:icati_app/module/directory/pattern/DirectoryView.dart';
import 'package:icati_app/module/directory/pattern/DirectoryWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DirectoryDetail extends StatefulWidget {
  DirectoryDetail({this.id});

  final String id;

  @override
  _DirectoryDetailState createState() => _DirectoryDetailState();
}

class _DirectoryDetailState extends State<DirectoryDetail>
    implements DirectoryView {
  DirectoryPresenter directoryPresenter;
  List dataDirectory;
  BaseData baseData = BaseData();
  Member member = Member();
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    directoryPresenter = new DirectoryPresenter();
    directoryPresenter.attachView(this);
    baseData.isFailed = false;
    baseData.isSaving = false;
    baseData.autoValidate = false;
    baseData.errorMessage = "";
    directoryPresenter.getDirectoryDetail(widget.id);
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
      dataDirectory = null;
    });
    directoryPresenter.getDirectoryDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle appBarTextStyle =
        TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: "roboto");
    return new Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          title: Text("Direktori Bisnis 企业名录", style: appBarTextStyle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: dataDirectory == null || baseData.lat == "" || baseData.long == ""
            ? baseData.isFailed
                ? BaseView().displayErrorMessage(
                    context, onRefresh, baseData.errorMessage)
                : BaseView()
                    .displayLoadingScreen(context, color: Colors.blueAccent)
            : directoryDetail());
  }

  Widget directoryDetail() {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        child: Column(
          children: [
            DirectoryWidgets().displayPicture(context, dataDirectory),
            DirectoryWidgets().displayInfo(context, dataDirectory),
          ],
        ),
      ),
    );
  }

  @override
  onNetworkError() {
    BaseFunction()
        .displayToastLong("Connection failed, please try again later");
    Navigator.of(context).pop();
  }

  @override
  onSuccessDirectoryDetail(Map data) {
    if (this.mounted) {
      setState(() {
        dataDirectory = data['message'];
        baseData.isFailed = false;
      });
    }
  }

  @override
  onFailDirectoryDetail(Map data) {
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
  onSuccessDirectoryCategory(Map data) {}

  @override
  onFailDirectoryCategory(Map data) {}

  @override
  onSuccessDirectorySubCat(Map data, String page, int tapIndex) {}

  @override
  onFailDirectorySubCat(Map data, String page, int tapIndex) {}

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
