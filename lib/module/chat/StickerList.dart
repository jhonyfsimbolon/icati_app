import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:icati_app/network/SocketHelper.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StickerList extends StatefulWidget {
  @override
  _StickerListState createState() => _StickerListState();
}

class _StickerListState extends State<StickerList> {
  List stickers;
  IO.Socket _socket;
  SharedPreferences _prefs;
  String kabupatenId, mId;

  @override
  void initState() {
    super.initState();
    getCredential();
  }

  void getCredential() async {
    _prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        final member = _prefs.getString("member");
        final List data = jsonDecode(member);
        mId = data[0]['mId'].toString();
        kabupatenId = data[0]['kabupatenId'].toString();
      });
      print("kabupaten " + kabupatenId.toString());
    }
    connectSocket();
  }

  void connectSocket() async {
    _socket = SocketHelper().connectServer(kabupatenId, "");
    _socket.connect();
    _socket.onConnect((data) => print("connected stickers"));

    _socket.emit('sticker_request', "");

    _socket.on("sticker_response", (data) {
      print("sticker_response ");
      if (this.mounted) {
        setState(() {
          stickers = data['message'];
        });
      }
      print("stickers " + stickers.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _socket.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Sticker", style: TextStyle(color: Colors.black)),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back, color: Colors.black),
            tooltip: "Back",
          ),
        ),
        body: stickers != null ? displayCatSticker() : Container());
  }

  Widget displayCatSticker() {
    return stickers.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: stickers != null ? stickers.length : 0,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        stickers[index]['stickerCatName'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    displayStickers(context, stickers[index]['stickerData'])
                  ],
                );
              },
            ),
          )
        : Center(child: Text("Tidak ada data sticker"));
  }

  Widget displayStickers(context, List stickers) {
    return stickers.isNotEmpty
        ? GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount:
                stickers == null || stickers.length < 1 ? 0 : stickers.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(stickers[index]["stickerLink"]);
                },
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(10),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: CachedNetworkImage(
                        width: 110.0,
                        height: 110.0,
                        fit: BoxFit.cover,
                        placeholder: (context, i) {
                          return Image.asset("assets/images/logo_ts_white.png");
                        },
                        imageUrl: stickers[index]["stickerLink"],
                      ),
                    ),
                  ),
                ),
//          FittedBox(
//            child: Container(
//              width: 110, //500,
//              height: 110,
//              child: ClipRRect(
//                borderRadius: BorderRadius.circular(5.0),
//                child: CachedNetworkImage(
//                  fit: BoxFit.cover,
//                  imageUrl: dataAlbum[index]["pho"],
//                  placeholder: (context, i) {
//                    return Image.asset("assets/images/logo_ts_white.png");
//                  },
//                ),
//              ),
//            ),
//          ),
              );
            },
          )
        : Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Center(child: Text("Tidak ada data sticker")));
  }
}
