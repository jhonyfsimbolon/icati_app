import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/explore/SearchExplore.dart';
import 'package:icati_app/module/explore/pattern/ExplorePresenter.dart';
import 'package:icati_app/module/explore/pattern/ExploreView.dart';
import 'package:icati_app/module/explore/pattern/ExploreWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> implements ExploreView {
  ExplorePresenter _explorePresenter;
  String _currentNegara = "100";
  String _currentProvince = "0";
  String _currentCity = "0";
  Member _member = Member();
  List _dataExplore, _dataNegara, _dataProvince, _dataCity;
  SharedPreferences _prefs;
  BaseData _baseData = BaseData(isLogin: false);
  var box;

  @override
  void initState() {
    super.initState();
    _explorePresenter = new ExplorePresenter();
    _explorePresenter.attachView(this);
    _getCredential();
  }

  _getCredential() async {
    if (!mounted) return;
    _prefs = await SharedPreferences.getInstance();
    box = await Hive.openBox("exploreCache");
    _baseData.isLogin =
        _prefs.containsKey("IS_LOGIN") ? _prefs.getBool("IS_LOGIN") : false;
    if (_baseData.isLogin) {
      setState(() {
        final user = _prefs.getString("member");
        final List data = jsonDecode(user);
        _member.negaraid = data[0]['negaraid'].toString();
        _member.provinsiId = data[0]['provinsiId'].toString();
        _member.kabupatenId = data[0]['kabupatenId'].toString();
        _member.mId = data[0]['mId'].toString();
        // _currentProvince = _member.provinsiId;
        // _currentNegara = _member.negaraid;
        // _currentCity = _member.kabupatenId;

        // print("_currentProvince: " + _currentProvince);
        if (box.isOpen) {
          if (this.mounted) {
            final dataBox = box.get("exploreCache");
            if (dataBox != null) {
              _dataExplore = jsonDecode(dataBox);
              ;
            }
          }
        }
      });
      _explorePresenter.getNegara();
      // _explorePresenter.getProvince();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text("EXPLORE 探讨",
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: Colors.white)),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchExplore(),
                  ));
                },
              )
            ],
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                      Color.fromRGBO(159, 28, 42, 1),
                      Color.fromRGBO(159, 28, 42, 1),
                  ])),
            )),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: Container(
            margin: EdgeInsets.only(top: 5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
                  child: ExploreWidgets().displayNegara(context, _currentNegara, _selectNegara, _dataNegara),
                ),
                _currentNegara.toString() == "100"
                ? Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
                  child: ExploreWidgets().displayProvince(
                      context, _currentProvince, _selectProvince, _dataProvince),
                ): SizedBox(),
                _currentProvince.toString() != null && _currentProvince.toString() != "0" && _dataCity!=null
                ? Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
                  child: ExploreWidgets().displayCity(context, _currentCity, _selectCity, _dataCity),
                ): SizedBox(),
                SizedBox(height: 10),
                _dataExplore != null
                    ? _dataExplore.isNotEmpty
                        ? ExploreWidgets()
                            .displayExplore(context, _dataExplore, _member.mId)
                        : SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height - 400,
                                  child: ExploreWidgets()
                                      .displayExploreNotFound(context),
                                )
                              ],
                            ),
                          )
                    : Container(),
              ],
            ),
          ),
        ));
  }


  void _selectNegara(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentNegara = value;
      // print("current negara select " + _currentNegara + ", provinsi " +_currentProvince.toString()+", kabupaten "+_currentCity);
      if (_currentNegara != null) {
        if (_currentNegara == "100") {
          print("proses mengambil data provinsi");
          this._currentProvince = null;
          this._currentCity = null;
          _explorePresenter.getProvince();
        } else {
          this._currentProvince = null;
          this._currentCity = null;
          _dataProvince = null;
          _dataCity = null;
        }
        _explorePresenter.searchExplore(_currentNegara, "country");
      } else {
        // this._currentProvince = null;
        // this._currentCity = null;
        _dataProvince = null;
        _dataCity = null;
      }
    });
  }

  void _selectProvince(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _dataExplore = null;
      this._currentProvince = value;
      this._currentCity = null;
      print("current province select " + _currentProvince);
    });
    if (_currentProvince != null) {
      print("proses mengambil data kabupaten");
      if(_currentProvince == "0"){
        _explorePresenter.searchExplore(_currentNegara, "country");
      }
      else{
      _explorePresenter.getCity(_currentProvince??"0");
      _explorePresenter.searchExplore(_currentProvince, "province");
      }
    }
  }

    void _selectCity(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._currentCity = value;
      print("current kabupaten select " + _currentCity);
    });
    if(_currentCity!=null){
      if(_currentCity == "0"){
        _explorePresenter.searchExplore(_currentProvince, "province");
      }else{
        _explorePresenter.searchExplore(_currentCity, "city");
      }
    
    }
  }


  Future<Null> onRefresh() async {
    setState(() {
      _dataExplore = null;
      // this._currentProvince = _member.provinsiId;
    });
    if(_currentCity!=null && _currentCity!="0"){
      _explorePresenter.searchExplore(_currentCity, "city");
    } else if(_currentProvince!=null && _currentProvince!="0"){
      _explorePresenter.searchExplore(_currentProvince, "province");
    } else {
      _explorePresenter.searchExplore(_currentNegara, "country");
    }
    
  }

  @override
  onFailSearchExplore(Map data) {
    if (this.mounted) {
      setState(() {
        _dataExplore = data['errorMessage'];
        print("ini explore" + _dataExplore.toString());
        box.put("exploreCache", jsonEncode(data['errorMessage']));
      });
    }
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessSearchExplore(Map data) {
    if (this.mounted) {
      setState(() {
        _dataExplore = data['message'];
        print("ini explore" + _dataExplore.toString());
        box.put("exploreCache", jsonEncode(data['message']));
      });
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
  onSuccessProvince(Map data) {
    if (this.mounted) {
      setState(() {
        _dataProvince = data['message'];
        print("ini provinsi " + _dataProvince.toString());
      });
      if (_currentProvince != null) {
        _explorePresenter.getCity(_currentProvince??"0");
        if(_currentCity == null || _currentCity == "0"){
          _explorePresenter.searchExplore(_currentProvince, "province");
        }
      }
    }
  }

  @override
  onFailCity(Map data) {
    if (this.mounted) {
      setState(() {
        _dataCity = data['errorMessage'];
      });
    }
  }

  @override
  onFailNegara(Map data) {
    if (this.mounted) {
      setState(() {
        _dataNegara = data['errorMessage'];
      });
    }
  }

  @override
  onSuccessCity(Map data) {
    if (this.mounted) {
      setState(() {
        _dataCity = data['message'];
        // if (_dataCity != null) {
        //   _editProfilePresenter.getCity(_currentProvince);
        // }
        if(_currentCity!=null){
          if(_currentCity !="0"){
            _explorePresenter.searchExplore(_currentCity, "city");
          } else {
            _explorePresenter.searchExplore(_currentProvince, "province");
          }
        }
      });
    }
  }

  @override
  onSuccessNegara(Map data) {
    if (this.mounted) {
      setState(() {
        _dataNegara = data['message'];
        _dataProvince = [];
        _dataCity = [];
        if (_dataNegara != null) {
          // _currentNegara = _dataNegara
          //     .where(
          //         (element) => element['negaraName'].toString() == "INDONESIA")
          //     .first['negaraId']
          //     .toString();
          // int a = 0;
          // _currentNegara = a.toString();
          print("ini negaraId " + _currentNegara);
        }
        if (_currentNegara == "100") {
          print("proses mengambil data kabupaten");
          _explorePresenter.getProvince();
        } else {
          _explorePresenter.searchExplore(_currentNegara, "country");
          _dataProvince = [];
          _dataCity = [];
        }
      });
    }
  }
}
