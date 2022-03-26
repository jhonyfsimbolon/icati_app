import 'package:flutter/material.dart';
import 'package:icati_app/base/BaseFunction.dart';

class RelatedLinkWidgets {
  Widget displayGridLink(context, List _dataLink) {
    return Container(
      child: GridView.builder(
        itemCount: _dataLink.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.95),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              BaseFunction().launchURL(_dataLink[index]['relatedLink']);
            },
            child: Container(
              margin: const EdgeInsets.all(7.0),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Center(
                      child: FadeInImage.assetNetwork(
                        width: 110.0,
                        height: 110.0,
                        fit: BoxFit.cover,
                        placeholder: "assets/images/logo_ts_red.png",
                        image: _dataLink[index]["relatedPic"],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Text(_dataLink[index]['relatedName'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
