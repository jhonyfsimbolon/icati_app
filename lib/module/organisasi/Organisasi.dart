import 'package:flutter/material.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/organisasi/pattern/OrganisasiPresenter.dart';
import 'package:icati_app/module/organisasi/pattern/OrganisasiView.dart';
import 'package:icati_app/module/organisasi/pattern/OrganisasiWidgets.dart';

class Organisasi extends StatefulWidget {
  @override
  _OrganisasiState createState() => _OrganisasiState();
}

class _OrganisasiState extends State<Organisasi> implements OrganisasiView {
  OrganisasiPresenter _OrganisasiPresenter;

  List _dataOrganisasi;

  @override
  void initState() {
    _OrganisasiPresenter = new OrganisasiPresenter();
    _OrganisasiPresenter.attachView(this);
    _OrganisasiPresenter.getGridOrganisasi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        titleSpacing: -10,
        title: Row(
          children: [
            Text("Organisasi",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(color: Colors.black87)),
            Text(" 组织",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(color: Colors.black87)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: mainColor,
      body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: _dataOrganisasi != null
              ? _dataOrganisasi.isNotEmpty
                  ? OrganisasiWidgets()
                      .displayGridOrganisasi(context, _dataOrganisasi)
                  : BaseView().displayErrorMessage(
                      context, _onRefresh, "Data Organisasi Tidak Ada",
                      textColor: Colors.black)
              : BaseView().displayLoadingScreen(context,
                  color: Theme.of(context).buttonColor)),
    );
  }

  Future<Null> _onRefresh() async {
    setState(() {
      _dataOrganisasi = null;
      _OrganisasiPresenter.getGridOrganisasi();
    });
  }

  @override
  onFailOrganisasi(Map data) {
    if (this.mounted) {
      setState(() {
        _dataOrganisasi = data['errorMessage'];
      });
    }
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessOrganisasi(Map data) {
    if (this.mounted) {
      setState(() {
        _dataOrganisasi = data['message'];
      });
    }
  }

  @override
  onFailOrganisasiDetail(Map data) {
    // TODO: implement onFailOrganisasiDetail
    throw UnimplementedError();
  }

  @override
  onSuccessOrganisasiDetail(Map data) {
    // TODO: implement onSuccessOrganisasiDetail
    throw UnimplementedError();
  }
}
