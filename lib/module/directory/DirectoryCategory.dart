import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/directory/DirectorySearch.dart';
import 'package:icati_app/module/directory/add_directory/AddDirectory.dart';
import 'package:icati_app/module/directory/pattern/DirectoryPresenter.dart';
import 'package:icati_app/module/directory/pattern/DirectoryView.dart';
import 'package:icati_app/module/directory/pattern/DirectoryWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DirectoryCategory extends StatefulWidget {
  DirectoryCategory({this.id});

  final String id;

  @override
  _DirectoryCategoryState createState() => _DirectoryCategoryState();
}

class _DirectoryCategoryState extends State<DirectoryCategory>
    implements DirectoryView {
  DirectoryPresenter directoryPresenter;
  BaseData baseData = BaseData();
  Member member = Member();
  String _currentProvince = "0";
  String _currentCity = "0";
  List _dataProvince, _dataCity;
  List<Widget> category = List();
  var box;

  @override
  void initState() {
    directoryPresenter = new DirectoryPresenter();
    directoryPresenter.attachView(this);
    baseData.isFailed = false;
    baseData.isSaving = false;
    baseData.autoValidate = false;
    baseData.errorMessage = "";
    baseData.isLogin = false;
    // directoryPresenter.getDirectoryCategory(_currentProvince, _currentCity);
    getCredential();
    super.initState();
  }

  getCredential() async {
    if (!mounted) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    box = await Hive.openBox("directoryCache");
    directoryPresenter.getProvince();
    setState(() {
      baseData.isLogin =
          prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
      if (baseData.isLogin) {
        final user = prefs.getString("member");
        final List data = jsonDecode(user);
        print(data);
        member.mId = data[0]['mId'].toString();
        member.mName = data[0]['mName'].toString();
        member.mEmail = data[0]['mEmail'].toString();
        member.provinsiId = data[0]['provinsiId'].toString();
        member.kabupatenId = data[0]['kabupatenId'].toString();
        // _currentProvince = member.provinsiId;
        // _currentCity = member.kabupatenId;
        print("_currentCity: " + _currentCity);
      }
      if (box.isOpen) {
        if (this.mounted) {
          final dataBox = box.get("directoryCache");
          if (dataBox != null) {
            print("MASUK ");
            List dataCat = jsonDecode(dataBox);
            for (int x = 0; x < dataCat.length; x++) {
              setState(() {
                category.add(DirectoryWidgets().displayDirectoryCategory(
                    context,
                    dataCat[x]['mCatName'].toString(),
                    int.parse(dataCat[x]['mCatId'].toString()),
                    dataCat[x]['arraymerchant'],
                    _currentProvince,
                    _currentCity));
              });
            }
          }
        }
      }
    });
  }

  Future<Null> onRefresh() async {
    setState(() {
      category = [];
    });
    directoryPresenter.getDirectoryCategory(_currentProvince??"0", _currentCity??"0");
  }

  @override
  Widget build(BuildContext context) {
    TextStyle appBarTextStyle =
        TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: "roboto");
    return new Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DirectorySearch(),
                      settings:
                          RouteSettings(name: "Pencarian Direktori (查找目录)")));
              // ));
            },
          )
        ],
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text("Direktori Bisnis 企业名录", style: appBarTextStyle),
        bottom: PreferredSize(
          preferredSize: _currentProvince != "0" ? const Size.fromHeight(120.0): const Size.fromHeight(75.0),
          child: Column(
            children: [
              // InkWell(
              //   onTap: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //         builder: (context) => DirectorySearch(),
              //         settings:
              //             RouteSettings(name: "Pencarian Direktori (查找目录)")));
              //   },
              //   child: IgnorePointer(
              //     ignoring: true,
              //     child: Padding(
              //       padding: const EdgeInsets.all(10.0),
              //       child: TextField(
              //         autofocus: false,
              //         controller: null,
              //         decoration: InputDecoration(
              //           fillColor: Color(0xffF1F1F1),
              //           filled: true,
              //           hintText: 'Cari direktori',
              //           hintStyle: TextStyle(
              //               color: Colors.grey,
              //               fontSize: 13.0,
              //               fontFamily: "roboto"),
              //           prefixIcon: IconButton(
              //             icon: Icon(Icons.search, color: Colors.grey),
              //             onPressed: null,
              //           ),
              //           isDense: true,
              //           border: OutlineInputBorder(
              //             borderRadius: BorderRadius.all(Radius.circular(7.0)),
              //             borderSide: BorderSide.none,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0, right: 10, left: 10, bottom: 10),
                child: Column(
                  children: [
                    DirectoryWidgets().displayProvinceBox(
                        context, _currentProvince??"0", _selectProvince, _dataProvince),
                    SizedBox(height: ScreenUtil().setSp(10)),
                    _currentProvince != "0" ? DirectoryWidgets().displayCityBox(
                        context, _currentCity, _selectCity, _dataCity):SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: category.length < 1
          ? baseData.isFailed
              ? BaseView().displayErrorMessage(
                  context, onRefresh, baseData.errorMessage)
              : BaseView()
                  .displayLoadingScreen(context, color: Colors.blueAccent)
          : directoryCategory(),
      floatingActionButton: baseData.isLogin
          ? FloatingActionButton.extended(
              backgroundColor: Colors.green,
              icon: Icon(Icons.add),
              label: Text('Daftarkan Usaha Anda'),
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddDirectory(),
                ));
              },
            )
          : SizedBox(),
    );
  }

  void searchPage() {}

  Widget directoryCategory() {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: category,
        ),
      ),
    );
  }

  void _selectCity(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      category = [];
      this._currentCity = value;
      print("current city select " + _currentProvince);
    });
    // _explorePresenter.searchExplore(_currentCity, "province");
    directoryPresenter.getDirectoryCategory(_currentProvince??"0", _currentCity??"0");
  }

  void _selectProvince(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      category = [];
      this._currentProvince = value;
      if(_currentProvince != null){
        this._currentCity = null;
        directoryPresenter.getCity(this._currentProvince);

      }
      print("current province select " + _currentProvince);
    });
    // _explorePresenter.searchExplore(_currentCity, "province");
    directoryPresenter.getDirectoryCategory(_currentProvince??"0", _currentCity??"0");
  }

  @override
  onNetworkError() {
    BaseFunction()
        .displayToastLong("Connection failed, please try again later");
    Navigator.of(context).pop();
  }

  @override
  onSuccessDirectoryCategory(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isFailed = false;
        if (category.length < 1) {
          for (int x = 0; x < data['message'].length; x++) {
            // if (data['message'][x]['arraymerchant'][0]['provinsiId']
            //         .toString() ==
            //     _currentCity) {
            // print(data['message'][x]['arraymerchant'][0]['provinsiId']
            //     .toString());
            setState(() {
              category.add(DirectoryWidgets().displayDirectoryCategory(
                  context,
                  data['message'][x]['mCatName'].toString(),
                  int.parse(data['message'][x]['mCatId'].toString()),
                  data['message'][x]['arraymerchant'],
                  _currentProvince,
                  _currentCity));
            });
            // }
          }
        }
        box.put("directoryCache", jsonEncode(data['message']));
      });
    }
  }

  @override
  onFailDirectoryCategory(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isFailed = true;
        box.put("directoryCache", jsonEncode(data['errorMessage']));
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
  onSuccessDirectoryDetail(Map data) {
    // TODO: implement onSuccessDirectoryDetail
  }

  @override
  onFailDirectoryDetail(Map data) {
    // TODO: implement onFailDirectoryDetail
  }

  @override
  onSuccessProvince(Map data) {
    if (this.mounted) {
      setState(() {
        _dataProvince = data['message'];
        print("ini provinsi " + _dataProvince.toString());
      });
      if (_currentProvince != null) {
          print("proses mengambil data kabupaten");
        directoryPresenter.getCity(this._currentProvince);
        }
      if (_dataProvince != null) {
        // _explorePresenter.searchExplore(_currentCity, "province");
        directoryPresenter.getDirectoryCategory(_currentProvince??"0", _currentCity??"0");
      }
    }
  }

  @override
  onFailProvince(Map data) {
    if (this.mounted) {
      setState(() {
        _dataProvince = data['errorMessage'];
      });
    }
  }

  @override
  onSuccessDirectorySubCat(Map data, String page, int tapIndex) {}

  @override
  onFailDirectorySubCat(Map data, String page, int tapIndex) {}

  @override
  onFailCity(Map data) {
    if (this.mounted) {
      setState(() {
        _dataCity = data['errorMessage'];
      });
    }
  }

  @override
  onSuccessCity(Map data) {
    if (this.mounted) {
      setState(() {
        _dataCity = data['message'];
        print("ini kota " + _dataCity.toString());
        if(_dataCity != null){
          _currentCity = "0";
        }
      });
    }
  }
}
