import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icati_app/base/BaseFunction.dart';

class ContactUsWidgets {
  Widget displayContactDesc(BuildContext context) {
    return Column(
      children: [
        Image.asset("assets/images/logo_ts_red.png", width: 100, height: 100),
        SizedBox(height: 10),
        Center(
          child: Text(
            "Silakan hubungi kami melalui\n "
            "informasi kontak icati Fondation Riau",
            style:
                GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Widget displayTabMenu(
      BuildContext context, TabController _tabController, List<Tab> _tabList) {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.0),
                border:
                    Border(bottom: BorderSide(color: Colors.black, width: 2))),
            margin: EdgeInsets.only(top: 15),
            child: Center(
              child: TabBar(
                  isScrollable: false,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 30),
                  labelColor: Color(0XFF38b5d7),
                  labelStyle: GoogleFonts.roboto(
                      fontSize: 12, fontWeight: FontWeight.w500),
                  unselectedLabelColor: Colors.grey,
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  tabs: _tabList),
            )),
      ),
    ]);
  }

  Widget displayTabMenuContent(
      context,
      TabController _tabController,
      String _address,
      Completer<GoogleMapController> _controller,
      TextEditingController nameCont,
      TextEditingController phoneCont,
      TextEditingController emailCont,
      TextEditingController messageCont,
      bool isSaving,
      Function send,
      String email,
      var formKey,
      String numberPhone) {
    return [
      displayMapsContact(context, _controller, _address),
      displayPhoneContact(context, numberPhone),
      displayFormContact(context, nameCont, phoneCont, emailCont, messageCont,
          isSaving, send, email, formKey),
    ][_tabController.index];
  }

  Widget displayMapsContact(BuildContext context,
      Completer<GoogleMapController> _controller, String _address) {
    String _alamatx = _address.replaceAll(RegExp('<div>'), '');
    String _alamaty = _alamatx.replaceAll(RegExp('<\/div>'), '');
    print(_alamaty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        _address.isNotEmpty ? HtmlWidget(_address) : Container(),
        SizedBox(height: _address.isNotEmpty ? 20 : 0),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: GoogleMap(
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            rotateGesturesEnabled: true,
            myLocationEnabled: true,
            compassEnabled: true,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              new Factory<OneSequenceGestureRecognizer>(
                () => new EagerGestureRecognizer(),
              ),
            ].toSet(),
            initialCameraPosition:
                CameraPosition(target: LatLng(0.537668, 101.406759), zoom: 20),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: {
              Marker(
                markerId: MarkerId('ICATI'),
                position: LatLng(0.537668, 101.406759),
                infoWindow: InfoWindow(
                    title: 'ICATI',
                    snippet: _alamaty.toString()),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange,
                ),
              ),
            },
          ),
        ),
      ],
    );
  }

  Widget displayPhoneContact(BuildContext context, String numberPhone) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 50, bottom: 50, left: 30, right: 30),
      color: Color(0XFFCCC9DC).withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(numberPhone, style: GoogleFonts.roboto(fontSize: 14)),
          GestureDetector(
            onTap: () {
              BaseFunction().phoneCall(numberPhone);
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 1.5),
                  color: Colors.green),
              child: Center(
                child: Icon(Icons.phone, size: 15, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget displayEmailContact(BuildContext context, String email) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
      color: Color(0XFFCCC9DC).withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(email, style: GoogleFonts.roboto(fontSize: 14)),
          GestureDetector(
            onTap: () {
              BaseFunction().launchMail(email);
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 1.5),
                  color: Colors.red),
              child: Center(
                child: Icon(Icons.email, size: 15, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget displayFormContact(
      BuildContext context,
      TextEditingController nameCont,
      TextEditingController phoneCont,
      TextEditingController emailCont,
      TextEditingController messageCont,
      bool isSaving,
      Function send,
      String email,
      formKey) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            displayEmailContact(context, email),
            SizedBox(height: 10),
            displayName(context, nameCont),
            SizedBox(height: 10),
            displayPhone(context, phoneCont),
            SizedBox(height: 10),
            displayEmail(context, emailCont),
            SizedBox(height: 10),
            displayMessage(context, messageCont),
            SizedBox(height: 10),
            !isSaving
                ? Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          onPressed: send,
                          padding: const EdgeInsets.all(16.0),
                          color: Color(0XFF38b5d7),
                          child: Text("KIRIM",
                              style: TextStyle(color: Colors.white)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget displayName(BuildContext context, TextEditingController nameCont) {
    return FormField(
      validator: (value) {
        if (nameCont.text.isEmpty) {
          return 'Kolom harus diisi';
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
                  controller: nameCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                  style: GoogleFonts.roboto(fontSize: 12),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      prefixIcon: Icon(Icons.person, size: 20),
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0XFF38b5d7))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      labelText: "Nama",
                      labelStyle: GoogleFonts.roboto(fontSize: 12))),
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

  Widget displayPhone(BuildContext context, TextEditingController phoneCont) {
    return FormField(
      validator: (value) {
        if (phoneCont.text.isEmpty) {
          return 'Kolom harus diisi';
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
                  controller: phoneCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  style: GoogleFonts.roboto(fontSize: 12),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      prefixIcon: Icon(FontAwesomeIcons.mobile, size: 20),
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0XFF38b5d7))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      labelText: "Nomor Telepon",
                      labelStyle: GoogleFonts.roboto(fontSize: 12))),
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

  Widget displayEmail(BuildContext context, TextEditingController emailCont) {
    return FormField(
      validator: (value) {
        if (emailCont.text.isEmpty) {
          return 'Kolom harus diisi';
        } else {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern);
          RegExp numeric = RegExp(r'^-?[0-9]+$');
          if (!regex.hasMatch(emailCont.text) &&
              !numeric.hasMatch(emailCont.text)) {
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
                controller: emailCont,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.roboto(fontSize: 12),
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(FontAwesomeIcons.envelope, size: 20),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0XFF38b5d7))),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  labelText: "Email",
                  labelStyle: GoogleFonts.roboto(fontSize: 12),
                ),
              ),
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

  Widget displayMessage(
      BuildContext context, TextEditingController messageCont) {
    return FormField(
      validator: (value) {
        if (messageCont.text.isEmpty) {
          return 'Kolom harus diisi';
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
                  controller: messageCont,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: GoogleFonts.roboto(fontSize: 12),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      prefixIcon: Icon(Icons.message, size: 20),
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0XFF38b5d7))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      labelText: "Pesan",
                      labelStyle: GoogleFonts.roboto(fontSize: 12))),
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
