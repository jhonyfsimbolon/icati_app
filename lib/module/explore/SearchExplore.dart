import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/module/explore/pattern/ExplorePresenter.dart';
import 'package:icati_app/module/explore/pattern/ExploreView.dart';
import 'package:icati_app/module/explore/pattern/ExploreWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchExplore extends StatefulWidget {
  @override
  _SearchExploreState createState() => _SearchExploreState();
}

class _SearchExploreState extends State<SearchExplore> implements ExploreView {
  ExplorePresenter _explorePresenter;
  TextEditingController _searchCont = TextEditingController();
  List _dataExplore;
  BaseData _baseData = BaseData(isSearch: false);
  SharedPreferences _prefs;
  String mId = "";

  @override
  void initState() {
    super.initState();
    _explorePresenter = new ExplorePresenter();
    _explorePresenter.attachView(this);
    _explorePresenter.searchExplore("", "");
    _getCredential();
  }

  void _getCredential() async {
    _prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        final member = _prefs.getString("member");
        final List data = jsonDecode(member);
        print("ini member " + member.toString());
        mId = data[0]['mId'].toString();
        print("ini mId " + mId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(159, 28, 42, 1),
          foregroundColor: Color.fromRGBO(159, 28, 42, 1),
          shadowColor: Color.fromRGBO(159, 28, 42, 1),
          automaticallyImplyLeading: false,
          title: TextField(
            autofocus: true,
            controller: _searchCont,
            cursorColor: Color.fromRGBO(159, 28, 42, 1),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              focusColor: Color.fromRGBO(159, 28, 42, 1),
              hoverColor: Color.fromRGBO(159, 28, 42, 1),
              hintText: 'Cari Berdasarkan Nama ...',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
              prefixIcon: IconButton(
                icon: Icon(Icons.arrow_back,color:Color.fromRGBO(159, 28, 42, 1)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              suffixIcon: _baseData.isSearch
                  ? IconButton(
                    color: Color.fromRGBO(159, 28, 42, 1),
                      icon: Icon(Icons.cancel),
                      onPressed: onClear,
                    )
                  : null,
            ),
            onChanged: onTextChanged,
          ),
        ),
        body: _dataExplore != null
            ? _dataExplore.isNotEmpty
                ? Column(
                    children: [
                      ExploreWidgets()
                          .displayExplore(context, _dataExplore, mId),
                    ],
                  )
                : SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 400,
                          child:
                              ExploreWidgets().displayExploreNotFound(context),
                        )
                      ],
                    ),
                  )
            : Container());
  }

  void onTextChanged(String value) async {
    if (!mounted) return;
    setState(() {
      _baseData.isSearch = true;
    });
    await Future.delayed(Duration(seconds: 1));
    if (value.isNotEmpty && value == _searchCont.text) {
      setState(() {
        _dataExplore = null;
      });
      await _explorePresenter.searchExplore(value, "name");
    }
    if (_searchCont.text == null || _searchCont.text.toString().isEmpty) {
      setState(() {
        _dataExplore = null;
        _baseData.isSearch = false;
      });
      await _explorePresenter.searchExplore("", "");
    }
    return;
  }

  void onClear() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => _searchCont.clear());
    if (mounted) {
      setState(() {
        _baseData.isSearch = false;
        _dataExplore = null;
      });
      await _explorePresenter.searchExplore("", "");
    }
  }

  @override
  onFailProvince(Map data) {}

  @override
  onFailSearchExplore(Map data) {
    if (!mounted) return;
    setState(() {
      _dataExplore = data['errorMessage'];
    });
    print("search gagal");
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessProvince(Map data) {}

  @override
  onSuccessSearchExplore(Map data) {
    if (!mounted) return;
    setState(() {
      _dataExplore = data['message'];
    });
    print("search sukses");
  }

  @override
  onFailCity(Map data) {
    // TODO: implement onFailCity
    throw UnimplementedError();
  }

  @override
  onFailNegara(Map data) {
    // TODO: implement onFailNegara
    throw UnimplementedError();
  }

  @override
  onSuccessCity(Map data) {
    // TODO: implement onSuccessCity
    throw UnimplementedError();
  }

  @override
  onSuccessNegara(Map data) {
    // TODO: implement onSuccessNegara
    throw UnimplementedError();
  }
}
