import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
//import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../main.dart';

class DetailPopup extends StatefulWidget {
  DetailPopup({this.id, this.title, this.desc, this.pic});

  @required
  final String id, title, desc, pic;

  @override
  _DetailPopupState createState() => _DetailPopupState();
}

class _DetailPopupState extends State<DetailPopup> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle appBarTextStyle = TextStyle(fontSize: 15.0, color: Colors.black);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: appBarTextStyle),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
          child: widget.pic != null ? Column(children: <Widget>[
            displayPopUpPic(),
            displayPopUpInfo(),
          ],)
        : Container(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 100.0),
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ))
    );
  }

  Widget displayPopUpPic() {
    return GestureDetector(
      onTap: () {},
      child: new Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 10.0),
        padding: EdgeInsets.all(20.0),
        child: new Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
          new FadeInImage.assetNetwork(
            fit: BoxFit.cover,
            placeholder: "assets/images/logo_ts_red.png",
            image: widget.pic,
          ),
        ]),
      ),
    );
  }

  Widget displayPopUpInfo() {
    return GestureDetector(
      onTap: () {},
      child: new Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 10.0),
        padding: EdgeInsets.all(10.0),
        child: new Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
          Container(
              width: 300,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child:
                    Html(
                      data: widget.desc,
                      style: {
                        "body": Style(
                            fontSize: FontSize.medium,
                            fontFamily: 'expressway',
                            color: Colors.black87),
                      },
                    )
                  ),
                ],
              )),
        ]),
      ),
    );
  }


}
