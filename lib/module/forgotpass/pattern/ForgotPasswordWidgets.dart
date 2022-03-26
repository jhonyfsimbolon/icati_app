import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordWidgets {
  Widget displaySendEmail(
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
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.red),
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }

  Widget displayInputPassword(
      BuildContext context,
      TextEditingController _passwordCont,
      bool _passwordVisible,
      Function _passwordVisibility) {
    return FormField(
      validator: (value) {
        if (_passwordCont.text.isEmpty || _passwordCont.text.length < 6) {
          return 'Kata sandi baru harus minimal 6 karakter';
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
                controller: _passwordCont,
                obscureText: !_passwordVisible,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.symmetric(
                      vertical: ScreenUtil().setSp(10),
                      horizontal: ScreenUtil().setSp(10)),
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.lock, size: ScreenUtil().setSp(20)),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).focusColor)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  labelText: "Kata Sandi",
                  labelStyle:
                      GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: ScreenUtil().setSp(20)),
                    onPressed: () {
                      _passwordVisibility();
                    },
                  ),
                ),
              ),
            ),
            state.errorText != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      state.errorText,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.red),
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }

  Widget displayInputRePass(
      BuildContext context,
      TextEditingController _passwordCont,
      TextEditingController _rePasswordCont,
      bool _rePassVisible,
      Function _rePassVisibility) {
    return FormField(
      validator: (value) {
        if (_passwordCont.text != _rePasswordCont.text) {
          return 'Konfirmasi kata sandi tidak sama';
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
                controller: _rePasswordCont,
                obscureText: !_rePassVisible,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.symmetric(
                      vertical: ScreenUtil().setSp(10),
                      horizontal: ScreenUtil().setSp(10)),
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.lock, size: ScreenUtil().setSp(20)),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).focusColor)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  labelText: "Konfirmasi Kata Sandi",
                  labelStyle:
                      GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _rePassVisible ? Icons.visibility : Icons.visibility_off,
                      size: ScreenUtil().setSp(20),
                    ),
                    onPressed: () {
                      _rePassVisibility();
                    },
                  ),
                ),
              ),
            ),
            state.errorText != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      state.errorText,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.red),
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
