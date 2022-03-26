import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class OtherMenuWidgets {
  Widget displayListMenu(BuildContext context, String title, dynamic navigateTo,
      {IconData icon, String imageIcon}) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            title,
            style: GoogleFonts.roboto(
                fontSize: 12.5, fontWeight: FontWeight.w400),
          ),
          trailing:
              Icon(Icons.arrow_forward_ios, size: 15.0, color: Colors.black),
          leading: title == "Tentang Paramita Foundation Riau"
              ? Image(
                  color: Color(0XFF38b5d7),
                  image: Svg(imageIcon,
                      color: Color(0XFF38b5d7), size: Size(30, 30)),
                  //color: Colors.red,
                )
              : Icon(
                  icon,
                  size: 20,
                  color: Color(0XFF38b5d7),
                ),
          onTap: () {
              if (navigateTo is String) {
                Navigator.of(context).pushNamed(navigateTo);
              } else if (navigateTo is Widget) {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => navigateTo));
              }
          },
        ),
        Divider(height: 0.0, color: Colors.grey[400]),
      ],
    );
  }
}
