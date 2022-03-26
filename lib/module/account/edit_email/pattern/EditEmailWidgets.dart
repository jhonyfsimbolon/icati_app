import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class EditEmailWidgets {
  Widget displayCurrentEmail(BuildContext context, String _currentEmail) {
    return Row(
      children: [
        Text.rich(
          TextSpan(
              text: "Email Anda sekarang\n",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Colors.black45),
              children: [
                TextSpan(
                    text: _currentEmail,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.black45, fontWeight: FontWeight.w700))
              ]),
        )
      ],
    );
  }

  Widget displayEditEmail(
      BuildContext context, TextEditingController _editEmailCont) {
    return FormField(
      validator: (value) {
        if (_editEmailCont.text.isEmpty) {
          return 'Kolom harus diisi';
        } else {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern);
          RegExp numeric = RegExp(r'^-?[0-9]+$');
          if (!regex.hasMatch(_editEmailCont.text) &&
              !numeric.hasMatch(_editEmailCont.text)) {
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
                  controller: _editEmailCont,
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
                      labelText: "Email Baru",
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

  Widget displayEmailEditFailed(BuildContext context, String message) {
    return Center(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(FontAwesomeIcons.timesCircle, size: 100),
            SizedBox(height: 20),
            Text("GAGAL",
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.w500)),
            Text(message,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    fontSize: 14, fontWeight: FontWeight.w300)),
          ],
        ),
      ),
    );
  }

  Widget displayEmailEditSuccess(BuildContext context, String message) {
    return Center(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(FontAwesomeIcons.checkCircle, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text("BERHASIL",
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.w500)),
            Center(
              child: Text(message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      fontSize: 14, fontWeight: FontWeight.w300)),
            ),
          ],
        ),
      ),
    );
  }
}
