import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AddJobWidgets {
  Widget displayJobCompanyName(
      BuildContext context, TextEditingController _companyNameCont) {
    return FormField(
      validator: (value) {
        if (_companyNameCont.text.isEmpty) {
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
                  controller: _companyNameCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: ScreenUtil().setSp(10),
                        horizontal: ScreenUtil().setSp(10)),
                    prefixIcon: Icon(Icons.account_balance_rounded,
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
                    labelText: "Nama Perusahaan",
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

  Widget displayJobCompanyPhoto(BuildContext context,
      Function _showChoiceDialog, File fileImage, bool _isFailed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Logo Perusahaan Anda",
            style: Theme.of(context).textTheme.bodyText2),
        SizedBox(height: ScreenUtil().setSp(10)),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => _showChoiceDialog(context),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          fileImage != null ? FileImage(fileImage) : null,
                      backgroundColor: fileImage != null
                          ? Colors.transparent
                          : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green,
                    Colors.green,
                    Colors.green,
                    Colors.green
                  ],
                ),
                // border: Border.all(color: Colors.black12, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        FontAwesomeIcons.edit,
                        color: Colors.white,
                        size: 15,
                      )),
                  GestureDetector(
                    onTap: () => _showChoiceDialog(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Pilih Berkas",
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        fileImage == null && _isFailed
            ? Text(
                "logo harus ada",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Colors.red),
              )
            : SizedBox(),
        Text(
          "*Format foto JPEG (.jpg), PNG (.png)",
          style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontStyle: FontStyle.italic, fontSize: ScreenUtil().setSp(10)),
        ),
      ],
    );
  }

  Widget displayJobProvince(BuildContext context, String _currentProvince,
      Function _selectProvince, List _dataProvince) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        IgnorePointer(
          ignoring: false,
          child: FormField(
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
                      isExpanded: true,
                      iconDisabledColor: Colors.white,
                      iconEnabledColor: Colors.white,
                      items: _dataProvince != null
                          ? _dataProvince.map((item) {
                              return DropdownMenuItem(
                                  value: item['provinsiId'].toString(),
                                  child: Text(item['provinsiName'].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2));
                            }).toList()
                          : null,
                      value: _currentProvince == "0" ? null : _currentProvince,
                      onChanged: _selectProvince,
                      style: Theme.of(context).textTheme.bodyText2,
                      decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: ScreenUtil().setSp(10),
                              horizontal: ScreenUtil().setSp(10)),
                          prefixIcon: Icon(FontAwesomeIcons.building,
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
        )
      ],
    );
  }

  Widget displayJobCity(BuildContext context, String _currentCity,
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

  Widget displayJobNamePosition(
      BuildContext context, TextEditingController _jobPositionCont) {
    return FormField(
      validator: (value) {
        if (_jobPositionCont.text.isEmpty) {
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
                  controller: _jobPositionCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: ScreenUtil().setSp(10),
                        horizontal: ScreenUtil().setSp(10)),
                    prefixIcon: Icon(Icons.person_pin_rounded,
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
                    labelText: "Nama Jabatan",
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

  Widget displayJobFiled(BuildContext context, String _currentJobField,
      Function _selectJobField, List _dataJobField) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormField(
          validator: (value) {
            if (_currentJobField == null) {
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
                    iconDisabledColor: Colors.white,
                    iconEnabledColor: Colors.white,
                    items: _dataJobField != null
                        ? _dataJobField.map((item) {
                            return DropdownMenuItem(
                                value: item['bidangId'].toString(),
                                child: Text(item['bidangName'].toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2));
                          }).toList()
                        : null,
                    value: _currentJobField == "0" ? null : _currentJobField,
                    onChanged: _selectJobField,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: ScreenUtil().setSp(10),
                            horizontal: ScreenUtil().setSp(10)),
                        prefixIcon: Icon(Icons.work_outlined,
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
                        labelText: "Bidang",
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
                    : Container()
              ],
            );
          },
        )
      ],
    );
  }

  Widget displayJobInfo(
      BuildContext context, TextEditingController _jobInfoCont) {
    return FormField(
      validator: (value) {
        if (_jobInfoCont.text.isEmpty) {
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
                  controller: _jobInfoCont,
                  keyboardType: TextInputType.multiline,
                  style: Theme.of(context).textTheme.bodyText2,
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: ScreenUtil().setSp(30),
                        horizontal: ScreenUtil().setSp(10)),
                    prefixIcon: Icon(Icons.perm_device_information,
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
                    labelText: "Detail Info",
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
            SizedBox(height: 3),
            Text(
              "*Detail Info Lowongan Kerja (Posisi, persyaratan, penempatan,"
              " cara mengirimkan lamaran",
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: ScreenUtil().setSp(10)),
            )
          ],
        );
      },
    );
  }

  Widget displayJobStartShow(
      BuildContext context, TextEditingController _dateStartCont) {
    final formatDate = DateFormat("dd/M/yyyy");
    return FormField(
      validator: (value) {
        if (_dateStartCont.text.isEmpty) {
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
                controller: _dateStartCont,
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
                    labelText: "Tanggal Mulai",
                    labelStyle: GoogleFonts.roboto(fontSize: 12)),
                resetIcon: null,
                format: formatDate,
                onShowPicker: (context, currentValue) async {
                  return showDatePicker(
                    context: context,
                    firstDate: DateTime(1970),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100),
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
            SizedBox(height: 3),
            Text(
              "*Tanggal berapa iklan lowongan kerja ingin ditampilkan",
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: ScreenUtil().setSp(10)),
            )
          ],
        );
      },
    );
  }

  Widget displayJobEndShow(
      BuildContext context, TextEditingController _dateEndCont) {
    final formatDate = DateFormat("dd/M/yyyy");
    return FormField(
      validator: (value) {
        if (_dateEndCont.text.isEmpty) {
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
                controller: _dateEndCont,
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
                    labelText: "Tanggal Selesai",
                    labelStyle: GoogleFonts.roboto(fontSize: 12)),
                resetIcon: null,
                format: formatDate,
                onShowPicker: (context, currentValue) async {
                  return showDatePicker(
                    context: context,
                    firstDate: DateTime(1970),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100),
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
            SizedBox(height: 3),
            Text(
              "*Tanggal berapa iklan lowongan kerja selesai",
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: ScreenUtil().setSp(10)),
            )
          ],
        );
      },
    );
  }

  Widget displayJobResponsibleName(
      BuildContext context, TextEditingController _responsibleNameCont) {
    return FormField(
      validator: (value) {
        if (_responsibleNameCont.text.isEmpty) {
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
                  controller: _responsibleNameCont,
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

  Widget displayJobResponsibleHp(BuildContext context, _responsibleHpCont) {
    return FormField(
      validator: (value) {
        if (_responsibleHpCont.text.isEmpty) {
          return "Kolom wajib diisi";
        } else if (_responsibleHpCont.text.length < 10) {
          return "Nomor HP minimal 10 angka";
        } else if (_responsibleHpCont.text.length > 13) {
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
                  controller: _responsibleHpCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                  style: Theme.of(context).textTheme.bodyText2,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      prefixIcon: Icon(FontAwesomeIcons.mobileAlt, size: 20),
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
                      labelText: "Nomor Handphone",
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

  Widget displayJobResponsibleEmail(
      BuildContext context, TextEditingController _responsibleEmailCont) {
    return FormField(
      validator: (value) {
        if (_responsibleEmailCont.text.isEmpty) {
          return 'Kolom harus diisi';
        } else {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern);
          RegExp numeric = RegExp(r'^-?[0-9]+$');
          if (!regex.hasMatch(_responsibleEmailCont.text) &&
              !numeric.hasMatch(_responsibleEmailCont.text)) {
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
                  controller: _responsibleEmailCont,
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
