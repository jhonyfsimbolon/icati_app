import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icati_app/module/othermenu/ListMenu.dart';
import 'package:icati_app/module/othermenu/contact_us/ContactUs.dart';
import 'package:icati_app/module/othermenu/contact_us/Contact_Us.dart';

class OtherMenu extends StatefulWidget {
  @override
  _OtherMenuState createState() => _OtherMenuState();
}

class _OtherMenuState extends State<OtherMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          OtherMenuWidgets().displayListMenu(
              context, "Tentang icati Foundation Riau", () {},
              imageIcon: "assets/images/logo_ts_white.svg"),
          OtherMenuWidgets().displayListMenu(context, "Donasi", () {},
              icon: FontAwesomeIcons.handshake),
          OtherMenuWidgets().displayListMenu(context, "Berita", () {},
              icon: FontAwesomeIcons.newspaper),
          OtherMenuWidgets().displayListMenu(context, "Agenda Kegiatan", () {},
              icon: FontAwesomeIcons.calendar),
          OtherMenuWidgets().displayListMenu(context, "Galeri Foto", () {},
              icon: Icons.image),
          OtherMenuWidgets().displayListMenu(context, "Galeri Video", () {},
              icon: Icons.videocam),
          OtherMenuWidgets().displayListMenu(context, "Kerja Sama", () {},
              icon: FontAwesomeIcons.userTie),
          OtherMenuWidgets().displayListMenu(context, "Link Terkait", () {},
              icon: FontAwesomeIcons.link),
          OtherMenuWidgets().displayListMenu(
              context, "Hubungi Kami", ContactUs(),
              icon: Icons.info),
        ],
      ),
    );
  }
}
