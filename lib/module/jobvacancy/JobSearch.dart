import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/jobvacancy/JobDetail.dart';
import 'package:icati_app/module/jobvacancy/pattern/JobPresenter.dart';
import 'package:icati_app/module/jobvacancy/pattern/JobView.dart';

class JobSearch extends StatefulWidget {
  JobSearch({this.keyword});
  final String keyword;

  @override
  _JobSearchState createState() => _JobSearchState();
}

class _JobSearchState extends State<JobSearch> implements JobView {
  JobPresenter jobPresenter;
  TextEditingController keyword = TextEditingController();
  List dataJob;
  BaseData baseData = BaseData();

  @override
  void initState() {
    super.initState();
    jobPresenter = new JobPresenter();
    jobPresenter.attachView(this);
    baseData.isSearch = false;
    baseData.isLoading = false;
    baseData.isFailed = false;
    baseData.errorMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    TextStyle appBarTextStyle =
        TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: "roboto");
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          child: Container(
            margin: EdgeInsets.only(top: 10, left: 5, right: 5),
            child: AppBar(
              foregroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.white,
              title: Text("Lowongan Kerja 工作", style: appBarTextStyle),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autofocus: true,
                    controller: keyword,
                    decoration: InputDecoration(
                      fillColor: Color(0xffF1F1F1),
                      filled: true,
                      hintText: 'Ketik di sini',
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.0,
                          fontFamily: "roboto"),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: baseData.isSearch
                          ? IconButton(
                              icon: Icon(Icons.cancel, color: Colors.grey),
                              onPressed: onClear,
                            )
                          : null,
                    ),
                    onChanged: onTextChanged,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: dataJob != null
            ? displaySearchMerchant()
            : baseData.isLoading
                ? BaseView()
                    .displayLoadingScreen(context, color: Colors.black87)
                : baseData.isFailed
                    ? displayMerchantNotFound()
                    : displaySearchPic());
  }

  Widget displayMerchantNotFound() {
    return Center(
      child: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.not_interested_rounded,
                    color: Colors.grey, size: 100),
              ),
              Text(
                baseData.errorMessage,
                style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              ),
              SizedBox(height: 60)
            ],
          ),
        ),
      ),
    );
  }

  Widget displaySearchPic() {
    return Center(
      child: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Icon(Icons.search_outlined, color: Colors.grey, size: 100),
              ),
              Text(
                "Silakan masukan kata pencarian",
                style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              ),
              SizedBox(height: 60)
            ],
          ),
        ),
      ),
    );
  }

  Widget displaySearchMerchant() {
    return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.builder(
          shrinkWrap: false,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: dataJob == null ? 0 : dataJob.length,
          itemBuilder: (context, i) {
            return new Container(
              margin: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border(bottom: BorderSide(width: 0.0, color: Colors.white)),
              ),
              child: InkWell(
                onTap: () {
                  var route = new MaterialPageRoute(
                    builder: (BuildContext context) => new JobDetail(
                      id: dataJob[i]["lokerId"].toString(),
                    ),
                  );
                  Navigator.of(context).push(route);
                },
                child: new Container(
                  padding: new EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FittedBox(
                        child: Container(
                          width: 110, //500,
                          height: 110,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: CachedNetworkImage(
                              fit: BoxFit.contain,
                              imageUrl: dataJob[i]["lokerPic"],
                              placeholder: (context, i) {
                                return Image.asset(
                                    "assets/images/logo_ts_red.png");
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                dataJob[i]["lokerName"],
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontFamily: 'expressway',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                  margin:
                                      EdgeInsets.only(bottom: 5.0, top: 10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 3.0),
                                        child: new Icon(
                                          Icons.location_city,
                                          size: 13.0,
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Expanded(
                                        child: Text(
                                          dataJob[i]['lokerCompanyName'],
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'expressway',
                                            fontSize: 13.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                  width: 300,
                                  margin: EdgeInsets.only(bottom: 5.0),
                                  child: Row(
                                    children: <Widget>[
                                      new Icon(Icons.supervisor_account,
                                          size: 14.0),
                                      SizedBox(width: 10.0),
                                      Expanded(
                                        child: Text(
                                          dataJob[i]['bidangName'],
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'expressway',
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                  margin: EdgeInsets.only(bottom: 5.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: Icon(Icons.calendar_today,
                                            size: 14.0),
                                      ),
                                      SizedBox(width: 10.0),
                                      Expanded(
                                        child: Text(
                                          dataJob[i]['lokerCombineDate'],
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'expressway',
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                  margin: EdgeInsets.only(bottom: 5.0),
                                  width: 300,
                                  child: Row(
                                    children: <Widget>[
                                      new Icon(Icons.location_on, size: 14.0),
                                      SizedBox(width: 10.0),
                                      Text(
                                        "namaKabupaten",
                                        // dataJob[i]['kabupatenName'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontFamily: 'expressway',
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  void onTextChanged(String value) async {
    if (mounted) {
      setState(() {
        baseData.isSearch = true;
      });
      await Future.delayed(Duration(seconds: 1));
      if (value.length > 1 && value.isNotEmpty && value == keyword.text) {
        setState(() {
          baseData.isLoading = true;
          dataJob = null;
        });
        await jobPresenter.getJobSearch(keyword.text);
      }
      return;
    }
  }

  Future<Null> onRefresh() async {
    if (this.mounted) {
      setState(() {
        dataJob = null;
      });
    }
  }

  void onClear() {
    WidgetsBinding.instance.addPostFrameCallback((_) => keyword.clear());
    if (mounted) {
      setState(() {
        baseData.isSearch = false;
      });
    }
  }

  @override
  onNetworkError() {
    if (this.mounted) {
      setState(() {
        baseData.isSearch = false;
        baseData.isLoading = false;
      });
      BaseFunction()
          .displayToastLong("Conneection Failed, Please try again later");
    }
  }

  @override
  onSuccessJobSearch(Map data) {
    if (this.mounted) {
      setState(() {
        dataJob = data['message'];
        baseData.isSearch = false;
        baseData.isLoading = false;
        baseData.isFailed = false;
      });
    }
  }

  @override
  onFailJobSearch(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.errorMessage = data['errorMessage'];
        baseData.isSearch = false;
        baseData.isLoading = false;
        baseData.isFailed = true;
      });
    }
  }

  @override
  onSuccessJobDetail(Map data) {
    // TODO: implement onSuccessJobDetail
  }

  @override
  onFailJobDetail(Map data) {
    // TODO: implement onFailJobDetail
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
