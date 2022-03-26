import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EditProfileWidgets {
  Widget displayEditPhoto(BuildContext context, Function _showChoiceDialog,
      File fileImage, String oldPicture) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              height: 60,
            ),
            Container(
              height: 70,
            )
          ],
        ),
        Positioned(
          top: 15,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.only(bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () => _showChoiceDialog(context),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: fileImage != null
                        ? FileImage(fileImage)
                        : oldPicture.isNotEmpty || oldPicture != null
                            ? NetworkImage(oldPicture)
                            : NetworkImage(
                                "http://icati.or.id/assets/images/account_picture_default.png"),
                    backgroundColor: fileImage != null || oldPicture.isNotEmpty
                        ? Colors.transparent
                        : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            top: 80,
            left: 75,
            right: 0,
            child: GestureDetector(
              onTap: () => _showChoiceDialog(context),
              child: Container(
                padding: EdgeInsets.all(3),
                height: 25,
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ))
      ],
    );
  }

  Widget displayEditName(
      BuildContext context, TextEditingController editNameCont) {
    return FormField(
      validator: (value) {
        if (editNameCont.text.isEmpty) {
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
                  controller: editNameCont,
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

  Widget displayEditGender(
      BuildContext context, String currentGender, Function selectGender) {
    List gender = [
      {'genderId': 'm', 'genderName': 'Laki-laki'},
      {'genderId': 'f', 'genderName': 'Perempuan'}
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormField(
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
                    items: gender.map((item) {
                      return DropdownMenuItem(
                          value: item['genderId'].toString(),
                          child: Text(item['genderName'].toString(),
                              style: Theme.of(context).textTheme.bodyText2));
                    }).toList(),
                    value: currentGender.isEmpty ? null : currentGender,
                    onChanged: selectGender,
                    style: Theme.of(context).textTheme.bodyText2,
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
                        labelStyle: GoogleFonts.roboto(fontSize: 12)),
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

  Widget displayEditReligion(
      BuildContext context, String _currentReligion, Function _selectReligion) {
    List religion = [
      {'religionId': 'buddha', 'religionName': 'Buddha'},
      {'religionId': 'hindu', 'religionName': 'Hindu'},
      {'religionId': 'islam', 'religionName': 'Islam'},
      {'religionId': 'katolik', 'religionName': 'Katolik'},
      {'religionId': 'konghucu', 'religionName': 'Konghucu'},
      {'religionId': 'kristen-protestan', 'religionName': 'Kristen Protestan'},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormField(
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
                    items: religion.map((item) {
                      return DropdownMenuItem(
                          value: item['religionId'].toString(),
                          child: Text(item['religionName'].toString(),
                              style: Theme.of(context).textTheme.bodyText2));
                    }).toList(),
                    value: _currentReligion.isEmpty ? null : _currentReligion,
                    onChanged: _selectReligion,
                    style: Theme.of(context).textTheme.bodyText2,
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
                        labelStyle: GoogleFonts.roboto(fontSize: 12)),
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

  Widget displayEditJob(BuildContext context, String _currentJob,
      Function _selectJob, List _dataJob) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // IgnorePointer(
        //   ignoring: true,
        FormField(
          validator: (value) {
            if (_currentJob == null) {
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
                    items: _dataJob != null
                        ? _dataJob.map((item) {
                            return DropdownMenuItem(
                                value: item['jobtId'].toString(),
                                child: Text(item['jobtName'],
                                    style:
                                        Theme.of(context).textTheme.bodyText2));
                          }).toList()
                        : null,
                    value: _currentJob == "0" ? null : _currentJob,
                    onChanged: _selectJob,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: ScreenUtil().setSp(10),
                            horizontal: ScreenUtil().setSp(10)),
                        prefixIcon: Icon(FontAwesomeIcons.briefcase,
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
                        labelText: "Pekerjaan",
                        labelStyle: GoogleFonts.roboto(fontSize: 12)),
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
        // )
      ],
    );
  }

  Widget displayEditNegara(BuildContext context, String _currentNegara,
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

  Widget displayEditProvince(BuildContext context, String _currentProvince,
      Function _selectProvince, List _dataProvince) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // IgnorePointer(
        //   ignoring: true,
        FormField(
          validator: (value) {
            if (_currentProvince == null || _currentProvince == "0") {
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
                        labelStyle: GoogleFonts.roboto(fontSize: 12)),
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
        // )
      ],
    );
  }

  Widget displayEditCity(BuildContext context, String _currentCity,
      Function _selectCity, List _dataCity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormField(
          validator: (value) {
            if (_currentCity == null || _currentCity == "0") {
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
                            borderSide: BorderSide(
                                color: Theme.of(context).focusColor)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        labelText: "Kota/Kabupaten",
                        labelStyle: GoogleFonts.roboto(fontSize: 12)),
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

  Widget displayEditBlood(
      BuildContext context, String _currentBlood, Function _selectBlood) {
    List blood = [
      {'bloodId': 'U', 'bloodName': 'Tidak Tahu'},
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
          validator: (value) {
            if (_currentBlood == null) {
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
                    items: blood.map((item) {
                      return DropdownMenuItem(
                          value: item['bloodId'].toString(),
                          child: Text(item['bloodName'].toString(),
                              style: Theme.of(context).textTheme.bodyText2));
                    }).toList(),
                    value: _currentBlood,
                    onChanged: _selectBlood,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: ScreenUtil().setSp(10),
                            horizontal: ScreenUtil().setSp(10)),
                        prefixIcon:
                            Icon(Icons.bloodtype, size: ScreenUtil().setSp(20)),
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
                        labelStyle: GoogleFonts.roboto(fontSize: 12)),
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

  Widget displayEditNameMandarin(
      BuildContext context, TextEditingController editNameMandarinCont) {
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
                  controller: editNameMandarinCont,
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

  Widget displayBirthDay(
      BuildContext context, TextEditingController birthdayCont) {
    final formatDate = DateFormat("dd/M/yyyy");
    return FormField(
      validator: (value) {
        if (birthdayCont.text.isEmpty) {
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
                controller: birthdayCont,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: ScreenUtil().setSp(10),
                        horizontal: ScreenUtil().setSp(10)),
                    prefixIcon: Icon(FontAwesomeIcons.calendarAlt,
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

  Widget displayEditCodeReference(
      BuildContext context, TextEditingController editCodeReference) {
    return FormField(
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
                  controller: editCodeReference,
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

  Widget displayEditUniv(
      BuildContext context, TextEditingController editUnivCont) {
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
                  controller: editUnivCont,
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

  Widget displayEditThnMasuk(
      BuildContext context, TextEditingController editThnMasukCont) {
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
                  controller: editThnMasukCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: ScreenUtil().setSp(10),
                        horizontal: ScreenUtil().setSp(10)),
                    prefixIcon: Icon(FontAwesomeIcons.calendar,
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
      BuildContext context, TextEditingController editTmpLahirCont) {
    return FormField(
      validator: (value) {
        if (editTmpLahirCont.text.isEmpty) {
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
                  controller: editTmpLahirCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: ScreenUtil().setSp(10),
                        horizontal: ScreenUtil().setSp(10)),
                    prefixIcon: Icon(Icons.apartment_outlined,
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

  Widget displayEditAlamat(
      BuildContext context, TextEditingController editAlamatCont) {
    return FormField(
      validator: (value) {
        if (editAlamatCont.text.isEmpty) {
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
                  controller: editAlamatCont,
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
}
