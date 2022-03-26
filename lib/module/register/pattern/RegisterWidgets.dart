import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:intl/intl.dart';

class RegisterWidgets {
  Widget displaySignInByAccount(
      BuildContext context,
      Function _signInByGoogle,
      Function _signInByFb,
      Function _signInByApple,
      Function _signInByTwitter,
      Function _signInByEmail) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap:
              // () {},
              _signInByGoogle,
          child: Material(
            color: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setSp(12)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.google,
                      size: ScreenUtil().setSp(15), color: Colors.white),
                  SizedBox(width: ScreenUtil().setSp(5)),
                  Text("Google",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white))
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: ScreenUtil().setSp(10)),
        GestureDetector(
          onTap: _signInByFb,
          child: Material(
            color: Color(0xFF3B5998),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setSp(12)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.facebookF,
                      size: ScreenUtil().setSp(15), color: Colors.white),
                  SizedBox(width: ScreenUtil().setSp(5)),
                  Text("Facebook",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white))
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: ScreenUtil().setSp(10)),
        GestureDetector(
          onTap: _signInByTwitter,
          child: Material(
            color: Color(0xFF1DA1F2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setSp(12)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.twitter,
                      size: ScreenUtil().setSp(15), color: Colors.white),
                  SizedBox(width: ScreenUtil().setSp(5)),
                  Text("Twitter",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white))
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: ScreenUtil().setSp(10)),
        Platform.isIOS
            ? Container(
                //width: MediaQuery.of(context).size.width - ScreenUtil().setWidth(112.w),
                child: SignInWithAppleButton(
                    onPressed: _signInByApple,
                    height: ScreenUtil().setSp(35),
                    borderRadius: BorderRadius.circular(10)),
              )
            : SizedBox(),
        SizedBox(height: ScreenUtil().setSp(10)),
        GestureDetector(
          onTap: _signInByEmail,
          child: Material(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 3,
            child: Container(
              //width: MediaQuery.of(context).size.width - ScreenUtil().setWidth(112.w),
              padding: EdgeInsets.all(ScreenUtil().setSp(12)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.envelope,
                      size: ScreenUtil().setSp(15), color: Colors.white),
                  SizedBox(width: ScreenUtil().setSp(5)),
                  Text("Daftar dengan Email",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget displayRegName(
      BuildContext context, TextEditingController regNameCont) {
    return FormField(
      validator: (value) {
        if (regNameCont.text.isEmpty) {
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
                  controller: regNameCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: ScreenUtil().setSp(10),
                        horizontal: ScreenUtil().setSp(10)),
                    prefixIcon:
                        Icon(Icons.person, size: ScreenUtil().setSp(20)),
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
                    labelText: "Nama",
                    labelStyle:
                        GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                  )),
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

  Widget displayRegNameMandarin(
      BuildContext context, TextEditingController regNameMandarinCont) {
    return FormField(
      // validator: (value) {
      //   if (regNameMandarinCont.text.isEmpty) {
      //     return 'Kolom harus diisi';
      //   }
      //   return null;
      // },
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
                  controller: regNameMandarinCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: ScreenUtil().setSp(10),
                        horizontal: ScreenUtil().setSp(10)),
                    prefixIcon:
                        Icon(Icons.person, size: ScreenUtil().setSp(20)),
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
                    labelText: "Nama Mandarin",
                    labelStyle:
                        GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                  )),
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

  Widget displayRegGender(BuildContext context, String currentGender,
      Function selectGender, List gender) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormField(
          validator: (value) {
            if (currentGender == null) {
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
                      boxShadow: [
                        BoxShadow(blurRadius: 2, color: Colors.grey)
                      ]),
                  child: DropdownButtonFormField(
                    isDense: true,
                    iconEnabledColor: Colors.transparent,
                    style: Theme.of(context).textTheme.bodyText2,
                    items: gender.map((item) {
                      return DropdownMenuItem(
                          value: item['genderId'].toString(),
                          child: Text(item['genderName'].toString(),
                              style: Theme.of(context).textTheme.bodyText2));
                    }).toList(),
                    value: currentGender == "" ? null : currentGender,
                    onChanged: selectGender,
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: ScreenUtil().setSp(10),
                            horizontal: ScreenUtil().setSp(10)),
                        prefixIcon: Icon(Icons.supervisor_account_sharp,
                            size: ScreenUtil().setSp(20)),
                        fillColor: Colors.white,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).focusColor)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        labelText: "Jenis Kelamin",
                        labelStyle: GoogleFonts.roboto(
                            fontSize: ScreenUtil().setSp(12))),
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
        )
      ],
    );
  }

  Widget displayRegReligion(BuildContext context, String _currentReligion,
      Function _selectReligion, List religion) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormField(
          validator: (value) {
            if (_currentReligion == null) {
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
                      boxShadow: [
                        BoxShadow(blurRadius: 2, color: Colors.grey)
                      ]),
                  child: DropdownButtonFormField(
                    isDense: true,
                    iconEnabledColor: Colors.transparent,
                    style: Theme.of(context).textTheme.bodyText2,
                    items: religion.map((item) {
                      return DropdownMenuItem(
                          value: item['religionId'].toString(),
                          child: Text(item['religionName'].toString(),
                              style: GoogleFonts.roboto(fontSize: 12)));
                    }).toList(),
                    value: _currentReligion == "" ? null : _currentReligion,
                    onChanged: _selectReligion,
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: ScreenUtil().setSp(10),
                            horizontal: ScreenUtil().setSp(10)),
                        prefixIcon: Icon(FontAwesomeIcons.pray,
                            size: ScreenUtil().setSp(20)),
                        fillColor: Colors.white,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).focusColor)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        labelText: "Agama",
                        labelStyle: GoogleFonts.roboto(
                            fontSize: ScreenUtil().setSp(12))),
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
        )
      ],
    );
  }

  Widget displayUniv(BuildContext context, TextEditingController regUnivCont) {
    return FormField(
      // validator: (value) {
      //   if (regUniv.text.isEmpty) {
      //     return 'Kolom harus diisi';
      //   }
      //   return null;
      // },
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
                  controller: regUnivCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: ScreenUtil().setSp(10),
                        horizontal: ScreenUtil().setSp(10)),
                    prefixIcon: Icon(Icons.school_outlined,
                        size: ScreenUtil().setSp(20)),
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
                    labelText: "Universitas",
                    labelStyle:
                        GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                  )),
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

  Widget displayThnMasuk(
      BuildContext context, TextEditingController regThnMasukCont) {
    return FormField(
      // validator: (value) {
      //   if (regThnMasuk.text.isEmpty) {
      //     return 'Kolom harus diisi';
      //   }
      //   return null;
      // },
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
                  controller: regThnMasukCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: ScreenUtil().setSp(10),
                        horizontal: ScreenUtil().setSp(10)),
                    prefixIcon: Icon(Icons.calendar_today,
                        size: ScreenUtil().setSp(20)),
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
                    labelText: "Tahun Masuk",
                    labelStyle:
                        GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                  )),
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

  Widget displayTmpLahir(
      BuildContext context, TextEditingController regTmpLahirCont) {
    return FormField(
      validator: (value) {
        if (regTmpLahirCont.text.isEmpty) {
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
                  controller: regTmpLahirCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: ScreenUtil().setSp(10),
                        horizontal: ScreenUtil().setSp(10)),
                    prefixIcon: Icon(Icons.school_outlined,
                        size: ScreenUtil().setSp(20)),
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
                    labelText: "Tempat Lahir",
                    labelStyle:
                        GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                  )),
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

  Widget displayAlamat(
      BuildContext context, TextEditingController regAlamatCont) {
    return FormField(
      validator: (value) {
        if (regAlamatCont.text.isEmpty) {
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
                  controller: regAlamatCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: ScreenUtil().setSp(10),
                        horizontal: ScreenUtil().setSp(10)),
                    prefixIcon:
                        Icon(Icons.location_on, size: ScreenUtil().setSp(20)),
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
                    labelText: "Alamat Sekarang",
                    labelStyle:
                        GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                  )),
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

  Widget displayRegNegara(BuildContext context, String _currentNegara,
      Function _selectNegara, List _dataNegara) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // IgnorePointer(
        // ignoring: true,
        FormField(
          validator: (value) {
            if (_currentNegara == null || _currentNegara == 0) {
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
                      boxShadow: [
                        BoxShadow(blurRadius: 2, color: Colors.grey)
                      ]),
                  child: DropdownButtonFormField(
                    isDense: true,
                    isExpanded: true,
                    // iconDisabledColor: Colors.white,
                    // iconEnabledColor: Colors.white,
                    items: _dataNegara != null
                        ? _dataNegara.map((item) {
                            return DropdownMenuItem(
                                value: item['negaraId'].toString(),
                                child: Text(item['negaraName'].toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyText2));
                          }).toList()
                        : null,
                    value: _currentNegara == "0" ? null : _currentNegara,
                    onChanged: _selectNegara,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: ScreenUtil().setSp(10),
                            horizontal: ScreenUtil().setSp(10)),
                        prefixIcon:
                            Icon(Icons.apartment, size: ScreenUtil().setSp(20)),
                        fillColor: Colors.white,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).focusColor)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        labelText: "Negara",
                        labelStyle: GoogleFonts.roboto(
                            fontSize: ScreenUtil().setSp(12))),
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
        ),
      ],
    );
  }

  Widget displayRegProvince(BuildContext context, String _currentProvince,
      Function _selectProvince, List _dataProvince) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // IgnorePointer(
        // ignoring: true,
        FormField(
          validator: (value) {
            if (_currentProvince == null) {
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
                      boxShadow: [
                        BoxShadow(blurRadius: 2, color: Colors.grey)
                      ]),
                  child: DropdownButtonFormField(
                    isDense: true,
                    // isExpanded: true,
                    // iconDisabledColor: Colors.white,
                    // iconEnabledColor: Colors.white,
                    items: _dataProvince != null
                        ? _dataProvince.map((item) {
                            return DropdownMenuItem(
                                value: item['provinsiId'].toString(),
                                child: Text(item['provinsiName'].toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyText2));
                          }).toList()
                        : null,
                    value: _currentProvince == "0" ? null : _currentProvince,
                    onChanged: _selectProvince,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: ScreenUtil().setSp(10),
                            horizontal: ScreenUtil().setSp(10)),
                        prefixIcon:
                            Icon(Icons.apartment, size: ScreenUtil().setSp(20)),
                        fillColor: Colors.white,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).focusColor)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        labelText: "Provinsi",
                        labelStyle: GoogleFonts.roboto(
                            fontSize: ScreenUtil().setSp(12))),
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
        ),
      ],
    );
  }

  Widget displayRegCity(BuildContext context, String _currentCity,
      Function _selectCity, List _dataCity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormField(
          validator: (value) {
            if (_currentCity == null) {
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
                      boxShadow: [
                        BoxShadow(blurRadius: 2, color: Colors.grey)
                      ]),
                  child: DropdownButtonFormField(
                    isDense: true,
                    items: _dataCity != null
                        ? _dataCity.map((item) {
                            return DropdownMenuItem(
                                value: item['kabupatenId'].toString(),
                                child: Text(
                                  item['kabupatenName'].toString(),
                                  style: Theme.of(context).textTheme.bodyText2,
                                ));
                          }).toList()
                        : null,
                    value: _currentCity == "0" ? null : _currentCity,
                    onChanged: _selectCity,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: ScreenUtil().setSp(10),
                          horizontal: ScreenUtil().setSp(10)),
                      prefixIcon:
                          Icon(Icons.apartment, size: ScreenUtil().setSp(20)),
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
                      labelText: "Kota/Kabupaten",
                      labelStyle:
                          GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
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
        )
      ],
    );
  }

  Widget displayRegBlood(
      BuildContext context, String _currentBlood, Function _selectBlood) {
    List blood = [
      {'bloodId': '', 'bloodName': 'Tidak Tahu'},
      {'bloodId': 'A+', 'bloodName': 'A+'},
      {'bloodId': 'A-', 'bloodName': 'A-'},
      {'bloodId': 'B+', 'bloodName': 'B+'},
      {'bloodId': 'B-', 'bloodName': 'B-'},
      {'bloodId': 'AB+', 'bloodName': 'AB+'},
      {'bloodId': 'AB-', 'bloodName': 'AB-'},
      {'bloodId': 'O+', 'bloodName': 'O+'},
      {'bloodId': 'O-', 'bloodName': 'O-'},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormField(
          // validator: (value) {
          //   if (_currentBlood == null) {
          //     return 'Kolom harus diisi';
          //   }
          //   return null;
          // },
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(seconds: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(blurRadius: 2, color: Colors.grey)
                      ]),
                  child: DropdownButtonFormField(
                    isDense: true,
                    iconEnabledColor: Colors.transparent,
                    style: Theme.of(context).textTheme.bodyText2,
                    items: blood.map((item) {
                      return DropdownMenuItem(
                          value: item['bloodId'].toString(),
                          child: Text(item['bloodName'].toString(),
                              style: Theme.of(context).textTheme.bodyText2));
                    }).toList(),
                    value: _currentBlood,
                    onChanged: _selectBlood,
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: ScreenUtil().setSp(10),
                            horizontal: ScreenUtil().setSp(10)),
                        prefixIcon: Icon(FontAwesomeIcons.tint,
                            size: ScreenUtil().setSp(20)),
                        fillColor: Colors.white,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).focusColor)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        labelText: "Golongan Darah",
                        labelStyle: GoogleFonts.roboto(
                            fontSize: ScreenUtil().setSp(12))),
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
        )
      ],
    );
  }

  Widget displayRegBirthDay(
      BuildContext context, TextEditingController regBirthDayCont) {
    final formatDate = DateFormat("dd/M/yyyy");
    return FormField(
      validator: (value) {
        if (regBirthDayCont.text.isEmpty) {
          return 'Kolom harus diisi';
        }
        return null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: Duration(seconds: 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
              child: DateTimeField(
                readOnly: true,
                controller: regBirthDayCont,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0),
                    prefixIcon: Icon(FontAwesomeIcons.calendarAlt, size: 20),
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
                    labelText: "Tanggal Lahir",
                    labelStyle: GoogleFonts.roboto(fontSize: 12)),
                resetIcon: null,
                format: formatDate,
                onShowPicker: (context, currentValue) async {
                  return showDatePicker(
                    context: context,
                    firstDate: DateTime(1921),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime.now(),
                  );
                },
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

  Widget displayRegEmail(BuildContext context,
      TextEditingController regEmailCont, String _emailDefault) {
    return FormField(
      validator: (value) {
        if (regEmailCont.text.isEmpty) {
          return 'Kolom harus diisi';
        } else {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern);
          RegExp numeric = RegExp(r'^-?[0-9]+$');
          if (!regex.hasMatch(regEmailCont.text) &&
              !numeric.hasMatch(regEmailCont.text)) {
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
                controller: regEmailCont,
                enabled: _emailDefault.isNotEmpty ? false : true,
                keyboardType: TextInputType.emailAddress,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.symmetric(
                      vertical: ScreenUtil().setSp(10),
                      horizontal: ScreenUtil().setSp(10)),
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(FontAwesomeIcons.envelope,
                      size: ScreenUtil().setSp(20)),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).focusColor)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  labelText: "Email",
                  labelStyle:
                      GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
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

  Widget displayRegPassword(
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

  Widget displayRegRePass(
      BuildContext context,
      TextEditingController _regPasswordCont,
      TextEditingController _regRePasswordCont,
      bool _rePassVisible,
      Function _rePassVisibility) {
    return FormField(
      validator: (value) {
        if (_regPasswordCont.text != _regRePasswordCont.text) {
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
                controller: _regRePasswordCont,
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

  Widget displayRegReference(
      BuildContext context, TextEditingController regRefCont, String refCode) {
    return FormField(
      // validator: (value) {
      //   if (regRefCont.text.isEmpty) {
      //     return 'Kolom harus diisi';
      //   }
      //   return null;
      // },
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
                  enabled: refCode != null ? false : true,
                  controller: regRefCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: ScreenUtil().setSp(10),
                          horizontal: ScreenUtil().setSp(10)),
                      prefixIcon: Icon(Icons.supervised_user_circle,
                          size: ScreenUtil().setSp(20)),
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
                      labelText: "Kode Referensi (jika ada)",
                      labelStyle: GoogleFonts.roboto(
                          fontSize: ScreenUtil().setSp(12)))),
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
                : Container()
          ],
        );
      },
    );
  }
}
