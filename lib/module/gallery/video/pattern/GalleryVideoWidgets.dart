import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:icati_app/base/BaseFunction.dart';

class GalleryVideoWidgets {
  Widget displayVideoList(
      BuildContext context, List _dataVideoList, Function _onRefresh) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _dataVideoList == null ? 0 : _dataVideoList.length,
        itemBuilder: (context, i) {
          return new Container(
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(width: 0.0, color: Colors.white)),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {
                  BaseFunction().launchURL(_dataVideoList[i]['vidLink']);
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                              top: 10,
                              right: 10,
                              bottom: 10,
                            ),
                            width: 130, //500,
                            height: 130, //350,
                            child: FittedBox(
                              child: Container(
                                width: 100, //500,
                                height: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: _dataVideoList[i]['albPic'],
                                    placeholder: (context, i) {
                                      return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.asset(
                                            "assets/images/logo_ts_red.png"),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 125,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(_dataVideoList[i]['vidName'],
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .copyWith(
                                                fontSize: 13,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600)),
                                    SizedBox(height: 8),
                                    _dataVideoList[i]['vidDesc'].isNotEmpty
                                        ? Text(
                                            _dataVideoList[i]['vidDesc'],
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(fontSize: 12),
                                          )
                                        : Container(),
                                    SizedBox(height: 4),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
