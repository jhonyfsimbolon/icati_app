import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailVerifyWidgets {
  Widget displayEmailFailed(BuildContext context, String message) {
    return Center(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset(
                  "assets/images/icon_failed_verify.png",
                  width: 70,
                  height: 70),
            ),
            SizedBox(height: 20),
            Text("VERIFIKASI EMAIL GAGAL",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 20)),
            Text(message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2),
          ],
        ),
      ),
    );
  }

  Widget displayEmailSuccess(BuildContext context, String message) {
    return Center(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset(
                  "assets/images/icon_success_verify.png",
                  width: 70,
                  height: 70),
            ),
            SizedBox(height: 20),
            Text("VERIFIKASI EMAIL BERHASIL",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 20)),
            Center(
              child: Text(message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2),
            ),
          ],
        ),
      ),
    );
  }

  Widget displayEmailInput(
      BuildContext context, TextEditingController _emailCont) {
    return FormField(
      validator: (value) {
        if (_emailCont.text.isEmpty) {
          return 'Kolom harus diisi';
        } else {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern);
          RegExp numeric = RegExp(r'^-?[0-9]+$');
          if (!regex.hasMatch(_emailCont.text) &&
              !numeric.hasMatch(_emailCont.text)) {
            return 'Format email tidak valid';
          }
        }
        return null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(seconds: 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
              child: TextFormField(
                  controller: _emailCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.emailAddress,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      prefixIcon: Icon(FontAwesomeIcons.envelope, size: 20),
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).focusColor)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      labelText: "Email",
                      labelStyle: GoogleFonts.roboto())),
            ),
            state.errorText != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      state.errorText,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
