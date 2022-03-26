import 'package:flutter/material.dart';

class ListMenu extends StatelessWidget {
  @required
  final String title;
  final IconData icon;
  final String imageIcon;
  @required
  dynamic navigateTo;

  ListMenu({this.title, this.icon, this.imageIcon, this.navigateTo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          trailing:
              Icon(Icons.arrow_forward_ios, size: 20.0, color: Colors.black),
          leading: title == "Tentang ICATI 关于 ICATI"
              ? ImageIcon(
                  AssetImage(imageIcon),
                  color: Colors.red[900],
                )
              : Icon(
                  icon,
                  color: Theme.of(context).primaryColorDark,
                ),
          minLeadingWidth: 1,
          onTap: () {
            if (title == "Direktori" ||
                title == "Lowongan Kerja 职位空缺" ||
                title == "Account") {
              if (navigateTo is String) {
                Navigator.of(context).pushReplacementNamed(navigateTo);
              } else if (navigateTo is Widget) {
                if (title == "Lowongan Kerja 职位空缺") {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => navigateTo));
                } else {
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (BuildContext context) => navigateTo));
                }
              } else {
                throw new ArgumentError(
                    'widget.navigateAfterSeconds must either be a String or Widget');
              }
            } else {
              if (navigateTo is String) {
                Navigator.of(context).pushNamed(navigateTo);
              } else if (navigateTo is Widget) {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => navigateTo));
              } else {
                throw new ArgumentError(
                    'widget.navigateAfterSeconds must either be a String or Widget');
              }
            }
          },
        ),
        Divider(height: 0.0, color: Colors.grey[400]),
      ],
    );
  }
}
