import 'package:flutter/material.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/herbal/pattern/HerbalDetailWidgets.dart';

class HerbalDetailPhoto extends StatefulWidget {
  final List herbalImages;
  final int index;

  HerbalDetailPhoto({this.herbalImages, this.index});

  @override
  _HerbalDetailPhotoState createState() => _HerbalDetailPhotoState();
}

class _HerbalDetailPhotoState extends State<HerbalDetailPhoto> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle appBarTextStyle = TextStyle(fontSize: 18.0, color: Colors.white);
    return new Scaffold(
        backgroundColor: Colors.black45,
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 8.0),
              Text(
                "Herbal Detail Foto",
                style: appBarTextStyle,
              ),
            ],
          ),
        ),
        body: widget.herbalImages != null
            ? HerbalDetailWidgets().displayHerbalSwipePic(
                context, widget.herbalImages, widget.index)
            : BaseView().displayLoadingScreen(context,
                color: Theme.of(context).buttonColor));
  }
}
