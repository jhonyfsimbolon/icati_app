import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EditSosMedWidgets {
  Widget socialField(
      BuildContext context,
      TextEditingController _controller,
      String _labelText,
      var _iconData,
      bool _showCursor,
      Function _onTapField) {
    return FormField(validator: (value) {
      if (_controller.text.length > 250) {
        return 'Teks maksimal 250 karakter';
      }
      return null;
    }, builder: (state) {
      return Column(
        children: [
          AnimatedContainer(
              duration: Duration(seconds: 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
              child: TextFormField(
                controller: _controller,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.name,
                style: Theme.of(context).textTheme.bodyText2,
                showCursor: _showCursor,
                onTap: _onTapField,
                decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: ScreenUtil().setSp(15),
                        horizontal: ScreenUtil().setSp(10)),
                    prefixIcon: Icon(_iconData, size: ScreenUtil().setSp(20)),
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
                    labelText: _labelText,
                    labelStyle:
                        GoogleFonts.roboto(fontSize: ScreenUtil().setSp(12)),
                    prefixText: _labelText == "Facebook"
                        ? 'https://www.facebook.com/'
                        : _labelText == "Instagram"
                            ? 'https://www.instagram.com/'
                            : _labelText == "Twitter"
                                ? 'https://www.twitter.com/'
                                : _labelText == "Youtube"
                                    ? 'https://www.youtube.com/channel/'
                                    : _labelText == "LinkedIn"
                                        ? 'https://www.linkedin.com/in/'
                                        : _labelText == "Tik Tok"
                                            ? 'https://www.tiktok.com/'
                                            : _labelText == "Website"
                                                ? 'https://'
                                                : null,
                    prefixStyle: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: Colors.black45, fontSize: ScreenUtil().setSp(11) )),
                maxLines: null,
              )),
          state.errorText != null
              ? Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setSp(8)),
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
    });
  }
}
