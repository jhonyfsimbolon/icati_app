import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/othermenu/contact_us/pattern/ContactUsPresenter.dart';
import 'package:icati_app/module/othermenu/contact_us/pattern/ContactUsView.dart';
import 'package:icati_app/module/othermenu/contact_us/pattern/ContactUsWidgets.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs>
    with SingleTickerProviderStateMixin
    implements ContactUsView {
  final ScrollController _scrollController = ScrollController();
  Completer<GoogleMapController> _controller = Completer();
  ContactUsPresenter _contactUsPresenter;

  final _formKey = new GlobalKey<FormState>();

  TextEditingController _nameCont = TextEditingController();
  TextEditingController _phoneCont = TextEditingController();
  TextEditingController _emailCont = TextEditingController();
  TextEditingController _messageCont = TextEditingController();

  String _infoAddress = "", _infoPhone = "", _infoEmail = "";

  List<Tab> _tabList = List();

  BaseData _baseData = BaseData(isSaving: false);

  TabController _tabController;

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    _contactUsPresenter = ContactUsPresenter();
    _contactUsPresenter.attachView(this);
    _contactUsPresenter.getInfoContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Color.fromRGBO(159, 28, 42, 1),
        title: Text("HUBUNGI KAMI",
            style: GoogleFonts.roboto(fontSize: 14, color: Colors.white)),
        elevation: 0,
      ),
      body: _infoAddress.isNotEmpty ||
              _infoEmail.isNotEmpty ||
              _infoPhone.isNotEmpty
          ? SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Container(
                          margin: EdgeInsets.only(left: 5.0),
                          child: Text(
                            'Informasi Kontak ICATI',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 8.0),
                        Image(
                            image: AssetImage("assets/images/logo_icati.png"),
                            width: 20.0),
                        Container(
                          margin: EdgeInsets.only(left: 5.0),
                          child: Text('Ikatan Citra Alumni Taiwan Se-Indonesia',
                              style: TextStyle(fontFamily: 'expressway')),
                        ),
                      ],
                    ),
                    Html(data: _infoAddress),
                    SizedBox(height: 8.0),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 8.0),
                        Icon(
                          FontAwesomeIcons.phone,
                          size: 14.0,
                        ),
                        SizedBox(width: 8.0),
                        InkWell(
                            onTap: () {
                              BaseFunction().phoneCall(_infoPhone);
                            },
                            child: Text(_infoPhone,
                                style: TextStyle(
                                    fontFamily: 'expressway',
                                    color: Colors.blue))),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10.0),
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 8.0),
                          Icon(Icons.email, size: 15.0),
                          SizedBox(width: 8.0),
                          InkWell(
                              onTap: () {
                                BaseFunction().launchMail(_infoEmail);
                              },
                              child: Text(_infoEmail,
                                  style: TextStyle(
                                      fontFamily: 'expressway',
                                      color: Colors.blue))),
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: ContactUsWidgets().displayMapsContact(
                            context, _controller, _infoAddress)),
                    Divider(
                      color: Colors.grey,
                    ),
                    Text(
                      'Kirim Pesan',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: TextStyle(fontSize: 14.0),
                            controller: _nameCont,
                            decoration: InputDecoration(
                                labelText: 'Nama',
                                border: OutlineInputBorder()),
                            validator: (val) {
                              if (val == '') {
                                return 'Nama harus diisi';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            style: TextStyle(fontSize: 14.0),
                            controller: _phoneCont,
                            decoration: InputDecoration(
                                labelText: 'Nomor Handphone',
                                border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            validator: (val) {
                              if (val == '') {
                                return 'Nomor Handphone harus diisi';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            style: TextStyle(fontSize: 14.0),
                            controller: _emailCont,
                            decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder()),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val == '') {
                                return 'Email harus diisi';
                              } else {
                                Pattern pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp regex = new RegExp(pattern);
                                if (!regex.hasMatch(val)) {
                                  return 'Email tidak valid';
                                }
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            style: TextStyle(fontSize: 14.0),
                            controller: _messageCont,
                            decoration: InputDecoration(
                                labelText: 'Pesan',
                                border: OutlineInputBorder()),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            validator: (val) {
                              if (val == '') {
                                return 'Pesan harus diisi';
                              }
                              return null;
                            },
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: MaterialButton(
                                  onPressed: () {
                                    send();
                                  },
                                  color: Color.fromRGBO(159, 28, 42, 1),
                                  child: Text(
                                    'KIRIM',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : BaseView().displayLoadingScreen(context, color: Colors.black),
    );
  }

  void send() {
    setState(() {
      _baseData.isSaving = true;
      FocusScope.of(context).requestFocus(FocusNode());
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _contactUsPresenter.sendContactInfo(
          _nameCont.text, _phoneCont.text, _emailCont.text, _messageCont.text);
    } else {
      setState(() {
        _baseData.isSaving = false;
      });
    }
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  _handleScrollTab() {
    print("ini tab index click " + _tabController.index.toString());
    setState(() {
      Future.delayed(Duration.zero, () {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic);
      });
    });
  }

  @override
  onFailInfoContact(Map data) {}

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessInfoContact(Map data) {
    if (this.mounted) {
      setState(() {
        if (data['address'].isNotEmpty) {
          _infoAddress = data['address'][0]['contentDesc'];
        }
        if (data['contact'].isNotEmpty) {
          String _hp = data['contact'][0]['socialValue'].toString();
          _infoPhone = _hp.replaceAll(RegExp('-'), '');
          _infoEmail = data['contact'][1]['socialValue'];
        }
      });
    }
  }

  @override
  onFailSendContact(Map data) {
    if (this.mounted) {
      BaseFunction().displayToastLong(data['errorMessage']);
    }
  }

  @override
  onSuccessSendContact(Map data) {
    if (this.mounted) {
      BaseFunction().displayToastLong(data['message']);
      Navigator.pop(context);
    }
  }
}
