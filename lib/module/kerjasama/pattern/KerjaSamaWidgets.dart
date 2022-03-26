import 'package:flutter/material.dart';

class KerjaSamaWidgets {
  Widget displayGridKerjasama(context, List dataKerjasama, _kerjaSamaDialog) {
    return Container(
      child: GridView.builder(
        itemCount: dataKerjasama.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _kerjaSamaDialog(
                  context,
                  dataKerjasama[index]["KerjasamaName"],
                  dataKerjasama[index]["KerjasamaDesc"],
                  dataKerjasama[index]["KerjasamaLink"],
                  dataKerjasama[index]["urlSource"]);
            },
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.all(10),
              child: Center(
                child: FadeInImage.assetNetwork(
                  width: 110.0,
                  height: 110.0,
                  fit: BoxFit.cover,
                  placeholder: "assets/images/logo_ts_red.png",
                  image: dataKerjasama[index]["urlSource"],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
