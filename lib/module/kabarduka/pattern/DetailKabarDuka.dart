import 'package:flutter/material.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/kabarduka/pattern/KabarDukaPresenter.dart';
import 'package:icati_app/module/kabarduka/pattern/KabarDukaView.dart';
import 'package:icati_app/module/kabarduka/pattern/KabarDukaWidgets.dart';

class DetailPhoto extends StatefulWidget {
  final String albumId;
  final int index;

  DetailPhoto({this.albumId, this.index});

  @override
  _DetailPhotoState createState() => _DetailPhotoState();
}

class _DetailPhotoState extends State<DetailPhoto> implements KabarDukaView {
  KabarDukaPresenter _KabarDukaPresenter;
  List _dataDetailPhoto;

  @override
  void initState() {
    _KabarDukaPresenter = new KabarDukaPresenter();
    _KabarDukaPresenter.attachView(this);
    // _KabarDukaPresenter.getKabarDukaDetail(widget.albumId);
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
                "Galeri Foto",
                style: appBarTextStyle,
              ),
            ],
          ),
        ),
        body: _dataDetailPhoto != null
            ? KabarDukaWidgets()
            // .displaySwipePic(context, _dataDetailPhoto, widget.index)
            : BaseView().displayLoadingScreen(context,
                color: Theme.of(context).buttonColor));
  }

  @override
  onFailKabarDuka(Map data) {}

  @override
  onFailKabarDukaDetail(Map data) {
    if (this.mounted) {
      setState(() {
        _dataDetailPhoto = data['errorMessage'];
      });
    }
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessKabarDuka(Map data) {}

  @override
  onSuccessKabarDukaDetail(Map data) {
    if (this.mounted) {
      setState(() {
        _dataDetailPhoto = data['message'];
        print("ini foto slide " + _dataDetailPhoto.toString());
      });
    }
  }
}
