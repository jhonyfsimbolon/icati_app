import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/kerjasama/pattern/KerjaSamaPresenter.dart';
import 'package:icati_app/module/kerjasama/pattern/KerjaSamaView.dart';
import 'package:icati_app/module/kerjasama/pattern/KerjaSamaWidgets.dart';

class KerjaSama extends StatefulWidget {
  @override
  _KerjaSamaState createState() => _KerjaSamaState();
}

class _KerjaSamaState extends State<KerjaSama> implements KerjaSamaView {
  KerjaSamaPresenter _kerjaSamaPresenter;

  List _dataKerjaSama;

  @override
  void initState() {
    _kerjaSamaPresenter = new KerjaSamaPresenter();
    _kerjaSamaPresenter.attachView(this);
    _kerjaSamaPresenter.getGridKerjaSama();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        titleSpacing: -10,
        title: Text("Kerja Sama 关系",
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
      body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: _dataKerjaSama != null
              ? _dataKerjaSama.isNotEmpty
                  ? KerjaSamaWidgets().displayGridKerjasama(
                      context, _dataKerjaSama, _kerjaSamaDialog)
                  : BaseView().displayErrorMessage(
                      context, _onRefresh, "Data Kerja Sama Tidak Ada",
                      textColor: Colors.black)
              : BaseView().displayLoadingScreen(context,
                  color: Theme.of(context).buttonColor)),
    );
  }

  Future<Null> _onRefresh() async {
    setState(() {
      _kerjaSamaPresenter.getGridKerjaSama();
    });
  }

  Future<void> _kerjaSamaDialog(BuildContext context, String nama, String desc,
      String link, String image) async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 200.0,
                margin: EdgeInsets.only(bottom: 20.0),
                child: Center(
                  child: Image(
                    fit: BoxFit.contain,
                    image: NetworkImage(image),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 0.0, bottom: 20.0),
                  child: Text(
                    nama,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              desc.length < 400
                  ? Container(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(0),
                          margin: EdgeInsets.only(bottom: 20),
                          child: Html(
                            data: desc,
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Container(
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(0),
                            margin: EdgeInsets.only(bottom: 20),
                            child: Html(
                              data: desc,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Kunjungi Website',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onPressed: () {
                BaseFunction().launchURL(link);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  onFailKerjaSama(Map data) {
    if (this.mounted) {
      setState(() {
        _dataKerjaSama = data['errorMessage'];
      });
    }
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessKerjaSama(Map data) {
    if (this.mounted) {
      setState(() {
        _dataKerjaSama = data['message'];
      });
    }
  }
}
