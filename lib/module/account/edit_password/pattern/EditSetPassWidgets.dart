import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EditSetPassWidgets {
  Widget displayEditSetCurrentPass(
      BuildContext context,
      TextEditingController _currentPassCont,
      FocusNode _currentPassNode,
      FocusNode _newPassNode,
      bool _currentPassVisible,
      Function _currentPassVisibility) {
    return FormField(
      validator: (value) {
        if (_currentPassCont.text.isEmpty) {
          return 'Kolom wajib diisi';
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
                controller: _currentPassCont,
                focusNode: _currentPassNode,
                textInputAction: TextInputAction.next,
                style: Theme.of(context).textTheme.bodyText2,
                onFieldSubmitted: (term) {
                  _currentPassNode.unfocus();
                  FocusScope.of(context).requestFocus(_newPassNode);
                },
                obscureText: !_currentPassVisible,
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.symmetric(
                      vertical: ScreenUtil().setSp(10),
                      horizontal: ScreenUtil().setSp(10)),
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.lock, size: ScreenUtil().setSp(20)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).focusColor)),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  labelText: "Kata Sandi Sekarang",
                  labelStyle:
                      GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _currentPassVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: ScreenUtil().setSp(20)),
                    onPressed: () {
                      _currentPassVisibility();
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

  Widget displayEditSetNewPass(
      BuildContext context,
      TextEditingController _newPassCont,
      FocusNode _newPassNode,
      FocusNode _rePassNode,
      bool _newPassVisible,
      Function _newPassVisibility) {
    return FormField(
      validator: (value) {
        if (_newPassCont.text.isEmpty || _newPassCont.text.length < 6) {
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
                controller: _newPassCont,
                focusNode: _newPassNode,
                textInputAction: TextInputAction.next,
                style: Theme.of(context).textTheme.bodyText2,
                onFieldSubmitted: (term) {
                  _newPassNode.unfocus();
                  FocusScope.of(context).requestFocus(_rePassNode);
                },
                obscureText: !_newPassVisible,
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
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).focusColor)),
                  labelText: "Kata Sandi Baru",
                  labelStyle:
                      GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _newPassVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: ScreenUtil().setSp(20)),
                    onPressed: () {
                      _newPassVisibility();
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

  Widget displayEditSetRePass(
      BuildContext context,
      TextEditingController _newPassCont,
      TextEditingController _rePassCont,
      FocusNode _rePassNode,
      bool _rePassVisible,
      Function _rePassVisibility) {
    return FormField(
      validator: (value) {
        if (_newPassCont.text != _rePassCont.text) {
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
                controller: _rePassCont,
                focusNode: _rePassNode,
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
                        _rePassVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: ScreenUtil().setSp(20)),
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
                    ))
                : Container(),
          ],
        );
      },
    );
  }
}
