import 'package:flutter/material.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/kabarduka/pattern/KabarDukaPresenter.dart';
import 'package:icati_app/module/kabarduka/pattern/KabarDukaView.dart';
import 'package:icati_app/module/kabarduka/pattern/KabarDukaWidgets.dart';

class KabarDuka extends StatefulWidget {
  @override
  _KabarDukaState createState() => _KabarDukaState();
}

class _KabarDukaState extends State<KabarDuka> implements KabarDukaView {
  KabarDukaPresenter _KabarDukaPresenter;

  List _dataKabarduka;

  @override
  void initState() {
    _KabarDukaPresenter = new KabarDukaPresenter();
    _KabarDukaPresenter.attachView(this);
    _KabarDukaPresenter.getKabarDukaList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          titleSpacing: -10,
          title: Text("Berita Duka 讣告",
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .copyWith(color: Colors.black87)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: mainColor,
        body: _dataKabarduka == null
            ? BaseView().displayLoadingScreen(context,
                color: Theme.of(context).buttonColor)
            : _dataKabarduka.isEmpty
                ? BaseView().displayErrorMessage(
                    context, _onRefresh, "Kabar Duka tidak tersedia")
                : KabarDukaWidgets()
                    .displayKabardukaList(context, _dataKabarduka, _onRefresh));
  }

  Future<Null> _onRefresh() async {
    _KabarDukaPresenter.getKabarDukaList();
  }

  @override
  onFailKabarDuka(Map data) {
    if (this.mounted) {
      setState(() {
        _dataKabarduka = data['errorMessage'];
      });
    }
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessKabarDuka(Map data) {
    if (this.mounted) {
      setState(() {
        _dataKabarduka = data['message'];
        // print("on success" + data['message']);
      });
    }
  }

  @override
  onFailKabarDukaDetail(Map data) {}

  @override
  onSuccessKabarDukaDetail(Map data) {}
}
