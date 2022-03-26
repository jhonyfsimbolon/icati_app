import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/othermenu/about_us/pattern/AboutUsPresenter.dart';
import 'package:icati_app/module/othermenu/about_us/pattern/AboutUsView.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> implements AboutUsView {
  AboutUsPresenter _aboutUsPresenter;
  bool isFailed = false;
  String data, errorMessage = "";

  @override
  void initState() {
    super.initState();
    _aboutUsPresenter = AboutUsPresenter();
    _aboutUsPresenter.attachView(this);
    _aboutUsPresenter.getAboutUs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Color.fromRGBO(159, 28, 42, 1),
        title: Text("TENTANG KAMI",
            style: GoogleFonts.roboto(fontSize: 14, color: Colors.white)),
        elevation: 0,
      ),
      body: data == null
          ? isFailed
              ? Center(
                  child: BaseView()
                      .displayLoadingScreen(context, color: Color.fromRGBO(159, 28, 42, 1)),
                )
              : Text(errorMessage,
                  style: GoogleFonts.roboto(color: Colors.grey))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: HtmlWidget(
                data,
                textStyle:
                    GoogleFonts.roboto(color: Colors.black, fontSize: 12),
              ),
            ),
    );
  }

  @override
  onFailAboutUs(Map data) {
    if (this.mounted) {
      setState(() {
        isFailed = true;
        errorMessage = data['errorMessage'];
      });
    }
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
  onSuccessAboutUs(Map data) {
    if (this.mounted) {
      setState(() {
        isFailed = false;
        this.data = data['message']['contentDesc'];
      });
    }
  }
}
