import 'package:flutter/material.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/relatedLink/pattern/RelatedLinkPresenter.dart';
import 'package:icati_app/module/relatedLink/pattern/RelatedLinkView.dart';
import 'package:icati_app/module/relatedLink/pattern/RelatedLinkWidgets.dart';

class RelatedLink extends StatefulWidget {
  String idLinkTerkait;

  RelatedLink({this.idLinkTerkait});

  @override
  _RelatedLinkState createState() => _RelatedLinkState();
}

class _RelatedLinkState extends State<RelatedLink> implements RelatedLinkView {
  RelatedLinkPresenter _relatedLinkPresenter;

  List _dataRelatedLink;

  @override
  void initState() {
    _relatedLinkPresenter = new RelatedLinkPresenter();
    _relatedLinkPresenter.attachView(this);
    _relatedLinkPresenter.getGridLinkGridView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          titleSpacing: 0,
          title: Text("Link Terkait",
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .copyWith(color: Colors.black87)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: mainColor,
        body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: _dataRelatedLink != null
                ? _dataRelatedLink.isNotEmpty
                    ? RelatedLinkWidgets()
                        .displayGridLink(context, _dataRelatedLink)
                    : BaseView().displayErrorMessage(
                        context, _onRefresh, "Data Link Terkait Tidak Ada",
                        textColor: Colors.black)
                : BaseView().displayLoadingScreen(context,
                    color: Theme.of(context).buttonColor)));
  }

  Future<Null> _onRefresh() async {
    setState(() {
      _relatedLinkPresenter.getGridLinkGridView();
    });
  }

  @override
  onFailRelatedLink(Map data) {
    if (this.mounted) {
      setState(() {
        _dataRelatedLink = data['errorMessage'];
      });
    }
  }

  @override
  onNetworkError() {
    // TODO: implement onNetworkError
    throw UnimplementedError();
  }

  @override
  onSuccessRelatedLink(Map data) {
    if (this.mounted) {
      setState(() {
        _dataRelatedLink = data['message'];
      });
      cekId();
    }
  }

  cekId() {
    if (this.mounted) {
      if (widget.idLinkTerkait != null) {
        for (int i = 0; i < _dataRelatedLink.length; i++) {
          if (widget.idLinkTerkait == _dataRelatedLink[i]["relatedId"]) {
            BaseFunction().launchURL(_dataRelatedLink[i]['relatedLink']);
          }
        }
      }
    }
  }
}
