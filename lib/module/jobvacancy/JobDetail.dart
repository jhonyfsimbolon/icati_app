import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/jobvacancy/pattern/JobPresenter.dart';
import 'package:icati_app/module/jobvacancy/pattern/JobView.dart';
import 'package:icati_app/module/jobvacancy/pattern/JobWidgets.dart';

class JobDetail extends StatefulWidget {
  JobDetail({this.id});

  final String id;

  @override
  _JobDetailState createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> implements JobView {
  JobPresenter jobPresenter;
  List dataJob;
  BaseData baseData = BaseData();
  Member member = Member();
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    jobPresenter = new JobPresenter();
    jobPresenter.attachView(this);
    baseData.isFailed = false;
    baseData.isSaving = false;
    baseData.autoValidate = false;
    baseData.errorMessage = "";
    baseData.lat = "";
    baseData.long = "";
    jobPresenter.getJobDetail(widget.id);
    super.initState();
  }

  Future<Null> onRefresh() async {
    setState(() {
      dataJob = null;
    });
    jobPresenter.getJobDetail(widget.id);
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
          title: Text("Lowongan Kerja 工作", style: appBarTextStyle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // actions: [
          //   InkWell(
          //       onTap:(){
          //         Share.share(dataJob[0]["lokerShare"],
          //             subject: dataJob[0]["lokerName"]);
          //       },
          //       child: Icon(Icons.share, color: Colors.black)),
          //   SizedBox(width: 20,)
          // ],
        ),
        body: dataJob == null
            ? baseData.isFailed
                ? BaseView().displayErrorMessage(
                    context, onRefresh, baseData.errorMessage)
                : BaseView()
                    .displayLoadingScreen(context, color: Colors.blueAccent)
            : body());
  }

  Widget body() {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        child: Column(
          children: [
            JobWidgets().displayBoxPicInfo(context, dataJob),
            JobWidgets().displayBoxInfo(context, dataJob)
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
  onSuccessJobDetail(Map data) {
    if (this.mounted) {
      setState(() {
        dataJob = data['message'];
        baseData.isFailed = false;
      });
    }
  }

  @override
  onFailJobDetail(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isFailed = true;
      });
      BaseFunction().displayToastLong(data['errorMessage']);
    }
  }

  @override
  onSuccessJobList(Map data, int tabIndex) {
    // TODO: implement onSuccessJobList
  }

  @override
  onFailJobList(Map data, int tabIndex) {
    // TODO: implement onFailJobList
  }

  @override
  onSuccessJobSearch(Map data) {
    // TODO: implement onSuccessJobSearch
  }

  @override
  onFailJobSearch(Map data) {
    // TODO: implement onFailJobSearch
  }

  @override
  onFailJobCategory(Map data) {
    // TODO: implement onFailJobCategory
    throw UnimplementedError();
  }

  @override
  onSuccessJobCategory(Map data) {
    // TODO: implement onSuccessJobCategory
    throw UnimplementedError();
  }

  @override
  onFailJobListAll(Map data) {
    // TODO: implement onFailJobListAll
    throw UnimplementedError();
  }

  @override
  onSuccessJobListAll(Map data) {
    // TODO: implement onSuccessJobListAll
    throw UnimplementedError();
  }

  @override
  onFailCity(Map data) {
    // TODO: implement onFailCity
    throw UnimplementedError();
  }

  @override
  onFailProvince(Map data) {
    // TODO: implement onFailProvince
    throw UnimplementedError();
  }

  @override
  onSuccessCity(Map data) {
    // TODO: implement onSuccessCity
    throw UnimplementedError();
  }

  @override
  onSuccessProvince(Map data) {
    // TODO: implement onSuccessProvince
    throw UnimplementedError();
  }
}
