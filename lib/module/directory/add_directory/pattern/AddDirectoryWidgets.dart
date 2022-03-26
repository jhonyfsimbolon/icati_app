import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AddDirectoryWidgets {
  Widget displayDirectoryPhoto(BuildContext context, Function _showChoiceDialog, File fileImage, bool _isFailed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => _showChoiceDialog(context),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: fileImage != null ? FileImage(fileImage) : null,
                          backgroundColor: fileImage != null ? Colors.transparent : Colors.grey[400],
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            // alignment: Alignment.bottomRight,
                            padding: EdgeInsets.all(3),
                            height: 25,
                            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: Icon(Icons.camera_alt, size: 15, color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        fileImage == null && _isFailed
            ? Text(
                "Logo usaha harus ada (企业标志必须存在)",
                style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.red),
              )
            : SizedBox(),
      ],
    );
  }

  Widget displayDirectoryName(BuildContext context, TextEditingController _directoryNameCont) {
    return FormField(
      validator: (value) {
        if (_directoryNameCont.text.isEmpty) {
          return 'Kolom harus diisi (必须填写栏)';
        }
        return null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(seconds: 0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
              child: TextFormField(
                  controller: _directoryNameCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(vertical: ScreenUtil().setSp(10), horizontal: ScreenUtil().setSp(10)),
                    prefixIcon: Icon(Icons.account_balance_rounded, size: ScreenUtil().setSp(20)),
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor)),
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    labelText: "Nama Tempat Usaha (营业地名称)",
                    labelStyle: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                  )),
            ),
            state.errorText != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      state.errorText,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.red),
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }

  Widget displayDirectoryCategory(BuildContext context, String _currentCategory, Function _selectCategory, List _dataCategory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormField(
          validator: (value) {
            if (_currentCategory == null) {
              return 'Kolom harus diisi (必须填写栏)';
            }
            return null;
          },
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(seconds: 0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
                  child: DropdownButtonFormField(
                    isDense: true,
                    items: _dataCategory != null
                        ? _dataCategory.map((item) {
                            return DropdownMenuItem(
                              value: item['mCatId'].toString(),
                              onTap: item['mCatParentId'] == 0 ? (){
                                print("Parent Category Tapped ${item['mCatName']}");
                              } : (){},
                              child: Text(
                                item['mCatName'].toString(),
                                style: item['mCatParentId'] == 0
                                    ? GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.bold)
                                    : Theme.of(context).textTheme.bodyText2,
                              ),
                            );
                          }).toList()
                        : null,
                    value: _currentCategory == "0" ? null : _currentCategory,
                    onChanged: _selectCategory,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(vertical: ScreenUtil().setSp(10), horizontal: ScreenUtil().setSp(10)),
                      prefixIcon: Icon(FontAwesomeIcons.chartPie, size: ScreenUtil().setSp(20)),
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor)),
                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      labelText: "Kategori Usaha (业务类别)",
                      labelStyle: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                    ),
                  ),
                ),
                state.errorText != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          state.errorText,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.red),
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

  Widget displayDirectoryEmail(BuildContext context, TextEditingController _directoryEmailCont) {
    return FormField(
      validator: (value) {
        if (_directoryEmailCont.text.isEmpty) {
          return 'Kolom harus diisi (必须填写栏)';
        } else {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern);
          RegExp numeric = RegExp(r'^-?[0-9]+$');
          if (!regex.hasMatch(_directoryEmailCont.text) && !numeric.hasMatch(_directoryEmailCont.text)) {
            return 'Format email tidak valid (无效的电子邮件格式)';
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
              child: TextFormField(
                controller: _directoryEmailCont,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  prefixIcon: Icon(FontAwesomeIcons.envelope, size: 20),
                  fillColor: Colors.white,
                  filled: true,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor)),
                  errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                  labelText: "Email Usaha (企业邮箱)",
                  labelStyle: GoogleFonts.roboto(),
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

  Widget displayDirectoryPhone(BuildContext context, _directoryPhoneCont) {
    return FormField(
      validator: (value) {
        if (_directoryPhoneCont.text.isEmpty) {
          return "Kolom wajib diisi (必须填写栏)";
        } else if (_directoryPhoneCont.text.length < 10) {
          return "Nomor Telepon (电话号码) /HP Usaha minimal 10 angka (至少十位数的商务手机)";
        } else if (_directoryPhoneCont.text.length > 13) {
          return "Nomor Telepon (电话号码) /HP Usaha maksimal 13 angka (最少十三位数的商务手机)";
        }
        return null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(seconds: 0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
              child: TextFormField(
                  controller: _directoryPhoneCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                  style: Theme.of(context).textTheme.bodyText2,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      prefixIcon: Icon(FontAwesomeIcons.mobileAlt, size: 20),
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor)),
                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      labelText: "Nomor Telepon/HP Usaha (电话号码/业务电话号码)",
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

  Widget displayDirectoryOperational(BuildContext context, TextEditingController _directoryOperationalCont) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(seconds: 0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
          child: TextFormField(
            controller: _directoryOperationalCont,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.multiline,
            minLines: 2,
            maxLines: null,
            style: Theme.of(context).textTheme.bodyText2,
            decoration: InputDecoration(
              contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              prefixIcon: Icon(FontAwesomeIcons.businessTime, size: 20),
              fillColor: Colors.white,
              filled: true,
              border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor)),
              labelText: "Jam Operasional (营业时间)",
              hintText: "(Contoh: Buka Senin-Sabtu 09:00 - 17:00 WIB)",
              hintStyle: GoogleFonts.roboto(),
              labelStyle: GoogleFonts.roboto(),
            ),
          ),
        ),
      ],
    );
  }

  Widget displayDirectoryWebsite(BuildContext context, TextEditingController _directoryWebCont) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(seconds: 0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
          child: TextFormField(
            controller: _directoryWebCont,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.url,
            style: Theme.of(context).textTheme.bodyText2,
            decoration: InputDecoration(
              contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              prefixIcon: Icon(FontAwesomeIcons.globe, size: 20),
              fillColor: Colors.white,
              filled: true,
              border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor)),
              labelText: "Alamat Website Usaha (Diisi jika ada)",
              hintStyle: GoogleFonts.roboto(),
              labelStyle: GoogleFonts.roboto(),
            ),
          ),
        ),
      ],
    );
  }

  Widget displayDirectoryTypeOption(BuildContext context, Function _onTypeChanged, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(text: "Apakah Usaha Anda Termasuk Rumahan/Online Shop (您的业务是否包括家庭/在线商店)?",
              children: [TextSpan(text: " *", style: TextStyle(color: Colors.red))]),
          style: GoogleFonts.roboto(),
        ),
        SizedBox(height: 4),
        FormField(
          validator: (value) {
            if (type == null) {
              return 'Kolom harus diisi (必须填写栏)';
            }
            return null;
          },
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _onTypeChanged("y");
                      },
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: Radio(
                                value: "y",
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                onChanged: (value) {
                                  _onTypeChanged(value);
                                },
                                groupValue: type,
                              ),
                            ),
                          ),
                          Text("Ya(是的)", style: GoogleFonts.roboto()),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _onTypeChanged("n");
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                            value: "n",
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            onChanged: (value) {
                              _onTypeChanged(value);
                            },
                            groupValue: type,
                          ),
                          Text("Tidak(不)", style: GoogleFonts.roboto()),
                        ],
                      ),
                    ),
                  ],
                ),
                state.errorText != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          state.errorText,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.red),
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

  // Widget displayDirectoryProvince(BuildContext context, String _currentProvince, Function _selectProvince, List _dataProvince) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       IgnorePointer(
  //         ignoring: true,
  //         child: FormField(
  //           validator: (value) {
  //             if (_currentProvince == null) {
  //               return 'Kolom harus diisi (必须填写栏)';
  //             }
  //             return null;
  //           },
  //           builder: (state) {
  //             return Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 AnimatedContainer(
  //                   duration: Duration(seconds: 0),
  //                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
  //                   child: DropdownButtonFormField(
  //                     isDense: true,
  //                     isExpanded: true,
  //                     iconDisabledColor: Colors.white,
  //                     iconEnabledColor: Colors.white,
  //                     items: _dataProvince != null
  //                         ? _dataProvince.map((item) {
  //                             return DropdownMenuItem(
  //                                 value: item['provinsiId'].toString(),
  //                                 child: Text(item['provinsiName'].toString(), style: Theme.of(context).textTheme.bodyText2));
  //                           }).toList()
  //                         : null,
  //                     value: _currentProvince == "0" ? null : _currentProvince,
  //                     onChanged: _selectProvince,
  //                     style: Theme.of(context).textTheme.bodyText2,
  //                     decoration: InputDecoration(
  //                         contentPadding: new EdgeInsets.symmetric(vertical: ScreenUtil().setSp(10), horizontal: ScreenUtil().setSp(10)),
  //                         prefixIcon: Icon(FontAwesomeIcons.building, size: ScreenUtil().setSp(20)),
  //                         fillColor: Colors.white,
  //                         filled: true,
  //                         border: new OutlineInputBorder(
  //                           borderRadius: new BorderRadius.circular(10),
  //                         ),
  //                         focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor)),
  //                         errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
  //                         labelText: "Provinsi",
  //                         labelStyle: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12))),
  //                   ),
  //                 ),
  //                 state.errorText != null
  //                     ? Padding(
  //                         padding: const EdgeInsets.only(top: 8),
  //                         child: Text(
  //                           state.errorText,
  //                           style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.red),
  //                         ),
  //                       )
  //                     : Container(),
  //                 SizedBox(height: 3),
  //                 Text(
  //                   "*Saat ini yang tersedia hanya provinsi Riau",
  //                   style: Theme.of(context).textTheme.bodyText2.copyWith(fontStyle: FontStyle.italic, fontSize: ScreenUtil().setSp(10)),
  //                 )
  //               ],
  //             );
  //           },
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget displayDirectoryProvince(BuildContext context, String _currentProvince, Function _selectProvince, List _dataProvince) {
      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormField(
          validator: (value) {
            if (_currentProvince == null) {
              return 'Kolom harus diisi (必须填写栏)';
            }
            return null;
          },
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(seconds: 0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
                  child: DropdownButtonFormField(
                    isDense: true,
                    items: _dataProvince != null
                        ? _dataProvince.map((item) {
                      return DropdownMenuItem(
                          value: item['provinsiId'].toString(),
                          child: Text(
                            item['provinsiName'].toString(),
                            style: Theme.of(context).textTheme.bodyText2,
                          ));
                    }).toList()
                        : null,
                    value: _currentProvince == "0" ? null : _currentProvince,
                    onChanged: _selectProvince,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(vertical: ScreenUtil().setSp(10), horizontal: ScreenUtil().setSp(10)),
                      prefixIcon: Icon(Icons.apartment, size: ScreenUtil().setSp(20)),
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor)),
                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      labelText: "Provinsi (省)",
                      labelStyle: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                    ),
                  ),
                ),
                state.errorText != null
                    ? Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    state.errorText,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.red),
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

  Widget displayDirectoryCity(BuildContext context, String _currentCity, Function _selectCity, List _dataCity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormField(
          validator: (value) {
            if (_currentCity == null) {
              return 'Kolom harus diisi(必须填写栏)';
            }
            return null;
          },
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(seconds: 0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
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
                      contentPadding: new EdgeInsets.symmetric(vertical: ScreenUtil().setSp(10), horizontal: ScreenUtil().setSp(10)),
                      prefixIcon: Icon(Icons.apartment, size: ScreenUtil().setSp(20)),
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor)),
                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      labelText: "Kota/Kabupaten (市/区)",
                      labelStyle: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                    ),
                  ),
                ),
                state.errorText != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          state.errorText,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.red),
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

  Widget displayDirectoryAddress(BuildContext context, TextEditingController _directoryAddressCont) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(seconds: 0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
          child: TextFormField(
            controller: _directoryAddressCont,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: null,
            style: Theme.of(context).textTheme.bodyText2,
            decoration: InputDecoration(
              contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              prefixIcon: Icon(FontAwesomeIcons.mapMarkedAlt, size: 20),
              fillColor: Colors.white,
              filled: true,
              border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor)),
              labelText: "Alamat Usaha (营业地址)",
              hintStyle: GoogleFonts.roboto(),
              labelStyle: GoogleFonts.roboto(),
            ),
          ),
        ),
      ],
    );
  }

  Widget displayDirectoryDiscount(BuildContext context, TextEditingController _directoryDiscountCont) {
    return FormField(
      validator: (value) {
        if (_directoryDiscountCont.text.isEmpty) {
          return "Kolom wajib diisi (必须填写栏)";
        }
        return null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(seconds: 0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
              child: TextFormField(
                  controller: _directoryDiscountCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                  style: Theme.of(context).textTheme.bodyText2,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      suffixIcon: Icon(FontAwesomeIcons.percent, size: 20),
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor)),
                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      labelText: "Diskon (折扣)",
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
            SizedBox(height: 3),
            Text(
              "*Berapa besar Diskon yang bersedia Anda berikan kepada member ICATI (dalam satuan persen)?",
              style: Theme.of(context).textTheme.bodyText2.copyWith(fontStyle: FontStyle.italic, fontSize: ScreenUtil().setSp(10)),
            )
          ],
        );
      },
    );
  }

  Widget displayDirectoryDiscountTerms(BuildContext context, TextEditingController _directoryDiscountTermsCont) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(seconds: 0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
          child: TextFormField(
            controller: _directoryDiscountTermsCont,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: null,
            style: Theme.of(context).textTheme.bodyText2,
            decoration: InputDecoration(
              contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              prefixIcon: Icon(FontAwesomeIcons.tag, size: 20),
              fillColor: Colors.white,
              filled: true,
              border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor)),
              labelText: "Ketentuan Diskon (折扣条款)",
              hintStyle: GoogleFonts.roboto(),
              labelStyle: GoogleFonts.roboto(),
            ),
          ),
        ),
      ],
    );
  }

  Widget displayDirectoryContactName(BuildContext context, TextEditingController _directoryContactNameCont) {
    return FormField(
      validator: (value) {
        if (_directoryContactNameCont.text.isEmpty) {
          return 'Kolom harus diisi (必须填写栏)';
        }
        return null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(seconds: 0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
              child: TextFormField(
                  controller: _directoryContactNameCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(vertical: ScreenUtil().setSp(10), horizontal: ScreenUtil().setSp(10)),
                    prefixIcon: Icon(Icons.person, size: ScreenUtil().setSp(20)),
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor)),
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    labelText: "Nama Pemilik Usaha (企业主姓名)",
                    labelStyle: GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                  )),
            ),
            state.errorText != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      state.errorText,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.red),
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }

  Widget displayDirectoryContactPhone(BuildContext context, _directoryContactPhoneCont) {
    return FormField(
      validator: (value) {
        if (_directoryContactPhoneCont.text.isEmpty) {
          return "Kolom harus diisi (必须填写栏)";
        } else if (_directoryContactPhoneCont.text.length < 10) {
          return "Nomor Telepon (电话号码) /HP Usaha minimal 10 angka (至少十位数的商务手机)";
        } else if (_directoryContactPhoneCont.text.length > 13) {
          return "Nomor Telepon (电话号码) /HP Usaha maksimal 13 angka (最少十三位数的商务手机)";
        }
        return null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(seconds: 0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
              child: TextFormField(
                  controller: _directoryContactPhoneCont,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                  style: Theme.of(context).textTheme.bodyText2,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      prefixIcon: Icon(FontAwesomeIcons.mobileAlt, size: 20),
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor)),
                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      labelText: "Nomor Telepon/HP Pemilik Usaha (电话号码/企业主的手机)",
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

  Widget displayDirectoryContactEmail(BuildContext context, TextEditingController _directoryEmailCont) {
    return FormField(
      validator: (value) {
        if (_directoryEmailCont.text.isEmpty) {
          return "Kolom harus diisi (必须填写栏)";
        } else {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern);
          RegExp numeric = RegExp(r'^-?[0-9]+$');
          if (!regex.hasMatch(_directoryEmailCont.text) && !numeric.hasMatch(_directoryEmailCont.text)) {
            return 'Format email tidak valid (无效的电子邮件格式)';
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
              child: TextFormField(
                controller: _directoryEmailCont,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  prefixIcon: Icon(FontAwesomeIcons.envelope, size: 20),
                  fillColor: Colors.white,
                  filled: true,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor)),
                  errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                  labelText: "Email Pemilik Usaha(电子邮件企业主)",
                  labelStyle: GoogleFonts.roboto(),
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

  Widget displayDirectorySocialMedia(BuildContext context, {TextEditingController controller, IconData prefixIcon, String labelText}) {
    TextInputType keyboardType;
    switch (labelText) {
      case "WhatsApp":
        keyboardType = TextInputType.phone;
        break;
      case "Line":
        keyboardType = TextInputType.text;
        break;
      default:
        keyboardType = TextInputType.url;
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(seconds: 0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
          child: TextFormField(
            key: Key(labelText),
            controller: controller,
            textInputAction: TextInputAction.done,
            keyboardType: keyboardType,
            inputFormatters: labelText == "WhatsApp" ? [FilteringTextInputFormatter.digitsOnly] : [],
            style: Theme.of(context).textTheme.bodyText2,
            decoration: InputDecoration(
              contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              prefixIcon: Icon(prefixIcon, size: 20),
              fillColor: Colors.white,
              filled: true,
              border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor)),
              labelText: labelText,
              hintStyle: GoogleFonts.roboto(),
              labelStyle: GoogleFonts.roboto(),
            ),
          ),
        ),
      ],
    );
  }
}
