import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/othermenu/pundi/pattern/PundiPresenter.dart';
import 'package:icati_app/module/othermenu/pundi/pattern/PundiView.dart';

class PundiKasih extends StatefulWidget {
  @override
  _PundiKasihState createState() => _PundiKasihState();
}

class _PundiKasihState extends State<PundiKasih> implements PundiView {
  PundiPresenter pundiPresenter;
  bool isFailed = false;
  List dataKasih;
  String data, errorMessage = "";

  @override
  void initState() {
    super.initState();
    pundiPresenter = PundiPresenter();
    pundiPresenter.attachView(this);
    pundiPresenter.getPundi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Color(0XFF38b5d7),
        title: Row(
          children: [
            Icon(
              FontAwesomeIcons.handHoldingWater,
              size: 28,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            dataKasih == null
                ? Container()
                : Text(
                    dataKasih[0]['socialName'],
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
          ],
        ),
        elevation: 0,
      ),
      body: dataKasih != null
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  HtmlWidget(
                    dataKasih[0]['socialDesc'],
                    textStyle:
                        GoogleFonts.roboto(color: Colors.black, fontSize: 13),
                  ),
                ],
              ),
            )
          : isFailed == true
              ? Text(errorMessage,
                  style: GoogleFonts.roboto(color: Colors.grey))
              : BaseView()
                  .displayLoadingScreen(context, color: Colors.lightBlueAccent),
    );
  }

  @override
  onNetworkError() {
    if (this.mounted) {
      setState(() {
        isFailed = true;
        errorMessage =
            "Jaringan tidak terkoneksi atau terdapat kesalahan teknis. Silahkan coba lagi.";
      });
    }
  }

  @override
  onSuccessPundi(Map data) {
    if (this.mounted) {
      setState(() {
        isFailed = false;
        dataKasih = data['pundikasih'];
      });
    }
  }

  @override
  onFailPundi(Map data) {
    if (this.mounted) {
      setState(() {
        isFailed = false;
        errorMessage = "Tidak ada data";
      });
    }
  }
}
