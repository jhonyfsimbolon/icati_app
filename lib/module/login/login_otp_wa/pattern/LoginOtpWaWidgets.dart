import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginOtpWaWidgets {
  Widget displayLoginOtpWa(
      BuildContext context, TextEditingController _waCont) {
    return FormField(
      validator: (value) {
        if (_waCont.text.isEmpty) {
          return "Kolom wajib diisi";
        } else if (_waCont.text.length < 10) {
          return "Nomor HP minimal 10 angka";
        } else if (_waCont.text.length > 13) {
          return "Nomor HP maksimal 13 angka";
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
                  controller: _waCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                  style: Theme.of(context).textTheme.bodyText2,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(13)
                  ],
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      prefixIcon: Icon(FontAwesomeIcons.whatsapp,
                          color: Colors.black, size: 20),
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
                      labelText: "Nomor WhatsApp",
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

  Widget displayWaOtpInput(BuildContext context, TextEditingController _otpCont,
      StreamController<ErrorAnimationType> _errorController) {
    return Column(
      children: [
        FormField(
          validator: (value) {
            if (_otpCont.text.isEmpty) {
              return 'Kolom wajib diisi';
            }
            return null;
          },
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  autoFocus: true,
                  obscureText: false,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      inactiveColor: Color(0xFFD2D2D2),
                      activeColor: Theme.of(context).backgroundColor,
                      selectedFillColor: Theme.of(context).backgroundColor,
                      inactiveFillColor: Theme.of(context).backgroundColor,
                      selectedColor: Color(0xFFEDAE49)),
                  animationDuration: Duration(milliseconds: 100),
                  controller: _otpCont,
                  errorAnimationController: _errorController,
                  autoDisposeControllers: false,
                  keyboardType: TextInputType.phone,
                  backgroundColor: Theme.of(context).backgroundColor,
                  onChanged: (value) {},
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
        ),
      ],
    );
  }
}
