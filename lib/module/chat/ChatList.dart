import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/module/chat/ChatMember.dart';
import 'package:icati_app/module/chat/ChatRoom.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
import 'package:icati_app/network/SocketHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatList extends StatefulWidget {
  final Function onRefresh;

  ChatList({this.onRefresh});
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  IO.Socket _socket,
      _socket2,
      _socket3,
      _socket4,
      _socket5,
      _socket6,
      _socket7,
      _socket8;
  List dataRooms = [], dataChat;
  SharedPreferences _prefs;
  double height, width;
  bool groupTap = false;
  bool personalTap = false;

  String mId = "", provinsiId = "", kabupatenId = "";

  @override
  void initState() {
    super.initState();
    _getCredential();
  }

  void _getCredential() async {
    _prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        final member = _prefs.getString("member");
        final List data = jsonDecode(member);
        print("ini member " + member.toString());
        mId = data[0]['mId'].toString();
        provinsiId = data[0]['provinsiId'].toString();
        kabupatenId = data[0]['kabupatenId'].toString();
        print("ini mId " + mId);
        print("ini provinsiId " + provinsiId);
        print("ini kabupatenId " + kabupatenId);
      });

      _listenRoom();
    }
  }

  Future _listenRoom() async {
    _socket = SocketHelper().connectServer("0", mId);
    _socket.connect();
    _socket.onConnect((data) => print("connected"));

    // _socket2 = SocketHelper().connectServer("8", mId);
    // _socket2.connect();
    // _socket2.onConnect((data) => print("connected"));

    // _socket3 = SocketHelper().connectServer("9", mId);
    // _socket3.connect();
    // _socket3.onConnect((data) => print("connected"));

    // _socket4 = SocketHelper().connectServer("10", mId);
    // _socket4.connect();
    // _socket4.onConnect((data) => print("connected"));

    // _socket5 = SocketHelper().connectServer("11", mId);
    // _socket5.connect();
    // _socket5.onConnect((data) => print("connected"));

    // _socket6 = SocketHelper().connectServer("12", mId);
    // _socket6.connect();
    // _socket6.onConnect((data) => print("connected"));

    // _socket7 = SocketHelper().connectServer("13", mId);
    // _socket7.connect();
    // _socket7.onConnect((data) => print("connected"));

    // _socket8 = SocketHelper().connectServer("14", mId);
    // _socket8.connect();
    // _socket8.onConnect((data) => print("connected"));

//socket1
    _socket.emit('list_room_request', {
      "mId": int.parse(mId),
    });

    _socket.on("receive_message", (data) async {
      print("receive message users ");
      onRefresh();
      // if (this.mounted) {
      //   setState(() {
      //     _socket.emit('list_room_request', {
      //       "mId": int.parse(mId),
      //     });
      //   });
      // }
    });

    _socket.on("upload_receive", (data) async {
      print("UPLOAD RECEIVE ");
      onRefresh();
    });

    _socket.on("update_message_response", (data) {
      print("update_message_response ");
      onRefresh();
    });

    _socket.on("delete_message_response", (data) {
      print("delete_message_response ");
      onRefresh();
    });

    _socket.on("list_room_response", (data) {
      print('list_room_response $data');
      if (this.mounted) {
        setState(() {
          if (data['status'] == true) {
            dataRooms = data['message'];
            print("ini data room " + dataRooms.toString());
          } else {
            BaseFunction().displayToast(data['message']);
          }
        });
      }
    });

    //personal chat

    _socket.emit('m_chatlist_req', {
      "mId": int.parse(mId),
    });

    _socket.on("receive_msg", (data) {
      print("receive_msg " + data.toString());
      onRefresh();
    });

    _socket.on("update_msg_res", (data) {
      print("update_msg_res ");
      onRefresh();
    });

    _socket.on("mupload_res", (data) {
      print("update_msg_res ");
      onRefresh();
    });

    _socket.on("delete_message_res", (data) {
      print("delete_message_res ");
      onRefresh();
    });

    _socket.on("m_chatlist_res", (data) {
      print('m_chatlist_res $data');
      if (this.mounted) {
        setState(() {
          if (data['status'] == true) {
            dataChat = data['message'];
            print("ini data chat 2 " + dataChat.toString());
          }
        });
      }
    });

    _socket.on("fail", (data) {
      print('fail $data');
      if (this.mounted) {
        setState(() {
          if (data['status'] == false) {
            BaseFunction().displayToast(data['message']);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
            title: Text("CHAT",
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: Colors.white)),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                    Color.fromRGBO(159, 28, 42, 1),
                    Color.fromRGBO(159, 28, 42, 1),
                  ])),
            )),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                dataRooms.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            if (groupTap) {
                              groupTap = false;
                            } else {
                              groupTap = true;
                            }
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.blue.shade100,
                            ),
                            margin: EdgeInsets.only(
                                left: 16, bottom: 5, right: 16, top: 10),
                            padding: new EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(Icons.group),
                                SizedBox(width: 5),
                                Text("Group Chat",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                              ],
                            )),
                      )
                    : Container(),
                groupTap
                    ? Container()
                    : Container(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: dataRooms.length,
                            itemBuilder: (context, i) {
                              String time = "";
                              if (dataRooms[i]['chatTimestamp']
                                  .toString()
                                  .isNotEmpty) {
                                DateTime timestamp = BaseFunction()
                                    .timestampToDateTime(int.parse(dataRooms[i]
                                            ['chatTimestamp']
                                        .toString()));
                                time = BaseFunction().checkTime(
                                    timestamp,
                                    int.parse(dataRooms[i]['chatTimestamp']
                                        .toString()));
                              }
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                        builder: (context) => ChatRoom(
                                            roomData: dataRooms[i],
                                            onRefresh: widget.onRefresh),
                                        settings: RouteSettings(
                                            name: "Halaman Chat'"),
                                      ))
                                      .then((value) => value == null
                                          ? onRefresh()
                                          : onRefresh());
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 16, bottom: 3, right: 16, top: 2),
                                  padding: new EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 0.0, color: Colors.white)),
                                  ),
                                  child: Row(
                                    children: [
                                      dataRooms[i]['roomLogo'] == ''
                                          ? Image.asset(
                                              "assets/images/logo_icati.png",
                                              width: ScreenUtil().setSp(50),
                                              height: ScreenUtil().setSp(50))
                                          : CachedNetworkImage(
                                              imageUrl: dataRooms[i]
                                                  ['roomLogo'],
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: ScreenUtil().setSp(50),
                                                height: ScreenUtil().setSp(50),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              placeholder: (context, i) {
                                                return Container(
                                                    height:
                                                        ScreenUtil().setSp(50),
                                                    width:
                                                        ScreenUtil().setSp(50),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/images/logo_ts_red.png"),
                                                          fit: BoxFit.cover),
                                                    ));
                                              },
                                              errorWidget: (_, __, ___) {
                                                return Container(
                                                    height:
                                                        ScreenUtil().setSp(50),
                                                    width:
                                                        ScreenUtil().setSp(50),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/images/logo_ts_red.png"),
                                                          fit: BoxFit.cover),
                                                    ));
                                              },
                                            ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    dataRooms[i]['roomName'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                dataRooms[i]['chatTimestamp']
                                                        .toString()
                                                        .isNotEmpty
                                                    ? Text(
                                                        time,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                dataRooms[i]['chatId']
                                                        .toString()
                                                        .isNotEmpty
                                                    ? Expanded(
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 16),
                                                          child: RichText(
                                                            text: TextSpan(
                                                                text: mId ==
                                                                        dataRooms[i]['senderId']
                                                                            .toString()
                                                                    ? "Anda: "
                                                                    : dataRooms[i]
                                                                            [
                                                                            'senderName'] +
                                                                        ": ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                    fontSize:
                                                                        12),
                                                                children: <
                                                                    TextSpan>[
                                                                  TextSpan(
                                                                      text: dataRooms[i]['chatType'] ==
                                                                              "text"
                                                                          ? dataRooms[i]
                                                                              [
                                                                              'chatData']
                                                                          : "Stiker",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black54,
                                                                          fontSize:
                                                                              12))
                                                                ]),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                dataRooms[i][
                                                            'totalUnreadMsg'] !=
                                                        0
                                                    ? Container(
                                                        child: CircleAvatar(
                                                          radius: 9,
                                                          child: Text(
                                                            dataRooms[i][
                                                                    'totalUnreadMsg']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 10),
                                                          ),
                                                          backgroundColor:
                                                              Colors.green[400],
                                                          foregroundColor:
                                                              Colors.white,
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                dataChat != null
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            if (personalTap) {
                              personalTap = false;
                            } else {
                              personalTap = true;
                            }
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.blue.shade100,
                            ),
                            margin: EdgeInsets.only(
                                left: 16, bottom: 5, right: 16, top: 10),
                            padding: new EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person),
                                    SizedBox(width: 5),
                                    Text("Personal Chat",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Container(
                                  height: 30,
                                  width: 120,
                                  child: FlatButton(
                                    color: Colors.blue.shade300,
                                    onPressed: () {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MenuBar(currentPage: 1)),
                                          (Route<dynamic> route) => false);
                                    },
                                    child: Text("Cari Member",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                  ),
                                ),
                              ],
                            )),
                      )
                    : Container(),
                personalTap ? Container() : Container(child: chatList())
              ],
            ),
          ),
        ));
  }

  Widget chatList() {
    print("ini data chat " + dataChat.toString());
    return dataChat != null
        ? dataChat.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: dataChat != null ? dataChat.length : 0,
                    itemBuilder: (context, i) {
                      print("ini data inisial " + dataChat[i]['mName']);
                      String colorUser =
                          BaseFunction().getUserColor(dataChat[i]['mName']);
                      String initName =
                          BaseFunction().getInitialName(dataChat[i]['mName']);
                      DateTime timestamp = BaseFunction().timestampToDateTime(
                          int.parse(dataChat[i]['mChatTimestamp'].toString()));
                      String time = BaseFunction().checkTime(timestamp,
                          int.parse(dataChat[i]['mChatTimestamp'].toString()));
                      return InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                builder: (context) => ChatMember(
                                    recipientData: dataChat[i],
                                    onRefresh: widget.onRefresh),
                                settings: RouteSettings(name: "Chat Member"),
                              ))
                              .then((value) =>
                                  value == null ? onRefresh() : onRefresh());
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 4, bottom: 2, left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 1.4,
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: BaseFunction()
                                            .convertColor(colorUser),
                                        maxRadius: 20,
                                        child: Text(initName,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12)),
                                        backgroundImage: dataChat[i]['mPic'] !=
                                                    null ||
                                                dataChat[i]['mPic']
                                                        .toString() !=
                                                    "https://icati.or.id/"
                                            ? NetworkImage(dataChat[i]['mPic'])
                                            : Colors.white,
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        maxRadius: 20,
                                        backgroundImage: dataChat[i]['mPic'] !=
                                                    null ||
                                                dataChat[i]['mPic']
                                                        .toString() !=
                                                    "https://icati.or.id/"
                                            ? NetworkImage(dataChat[i]['mPic'])
                                            : Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              dataChat[i]['mName'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                  text: mId ==
                                                          dataChat[i]
                                                                  ['mSenderId']
                                                              .toString()
                                                      ? "Anda: "
                                                      : "",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 12),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: dataChat[i][
                                                                    'mChatType'] ==
                                                                "text"
                                                            ? dataChat[i]
                                                                ['mChatData']
                                                            : "Stiker",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 12))
                                                  ]),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 10, left: 6, right: 16),
                                    child: Text(
                                      time,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                    ),
                                  ),
                                  dataChat[i]['unreadMessage'] < 1
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 16, right: 16, top: 8),
                                            decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                shape: BoxShape.circle),
                                            child: Container(
                                              child: CircleAvatar(
                                                radius: 9,
                                                child: Text(
                                                  dataChat[i]['unreadMessage']
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                                backgroundColor:
                                                    Colors.green[400],
                                                foregroundColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.message, size: 40),
                  SizedBox(height: 5),
                  Center(
                      child: Text("Belum Ada Obrolan",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400))),
                ],
              )
        : Container();
  }

  Future<Null> onRefresh() async {
    print("refresh ");
    if (this.mounted) {
      _socket.emit('list_room_request', {
        "mId": int.parse(mId),
      });
      _socket.emit('m_chatlist_req', {
        "mId": int.parse(mId),
      });
    }
  }
}
