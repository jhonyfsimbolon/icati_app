import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/chat/PlayAudio.dart';
import 'package:icati_app/module/chat/PreviewImageChat.dart';
import 'package:icati_app/module/chat/StickerList.dart';
import 'package:icati_app/network/SocketHelper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:path/path.dart' as path;

class ChatMember extends StatefulWidget {
  Map recipientData;
  Function onRefresh;

  ChatMember({this.recipientData, this.onRefresh});

  @override
  _ChatMemberState createState() => _ChatMemberState();
}

class _ChatMemberState extends State<ChatMember> {
  List messages = [], infoRoom = [], dataPressMsg = [];
  List dataMember;
  double height, width;
  TextEditingController chatController = TextEditingController();
  ScrollController scrollController = ScrollController();
  IO.Socket socket;
  SharedPreferences prefs;
  String mId,
      typeLongPressMsg = "",
      chatFileType = "",
      stickerOn = "",
      chatRoomId = "";
  Map chatParent;
  var data;
  bool isLogin = false,
      pressEdit = false,
      pressDelete = false,
      isLoading = false;

  List<File> pickedFile;
  String _gif;

  @override
  void initState() {
    super.initState();
    getMember();
    print("ini passing room chat " + widget.recipientData.toString());
  }

  void getMember() async {
    prefs = await SharedPreferences.getInstance();
    isLogin = prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
    if (isLogin) {
      if (this.mounted) {
        setState(() {
          final member = prefs.getString("member");
          dataMember = jsonDecode(member);
          mId = dataMember[0]['mId'].toString();
          print("profile chat " + dataMember.toString());
        });
      }
      listenEvents();
    } else {
      print("Anda belum login");
    }
  }

  void listenEvents() async {
    if (int.parse(mId) < int.parse(widget.recipientData['mId'].toString())) {
      chatRoomId = "$mId-${widget.recipientData['mId']}";
    } else {
      chatRoomId = "${widget.recipientData['mId']}-$mId";
    }
    print("chat room id ---------------------------------------------" +
        chatRoomId);

    socket = SocketHelper().connectServer(chatRoomId, "");
    socket.connect();
    socket.onConnect((data) => print("connected to socket"));

    print("KIRIM IDS ");
    print(mId);
    print(widget.recipientData.toString());
    print("mName--------------------" + widget.recipientData['mName']);

    socket.emit("all_message_req", {
      "mId": int.parse(mId),
      "mSenderId": int.parse(mId),
      "mRecipientId": int.parse(widget.recipientData['mId'].toString()),
    });

    socket.on("all_message_res", (data) {
      print('-------------------all_message_res $data');
      if (this.mounted) {
        setState(() {
          messages.addAll(data['message']);
          if (messages.isNotEmpty) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(microseconds: 1),
                curve: Curves.easeOut,
              );
            });
          }
        });
      }
    });

    socket.emit('minfo_req', "0");

    socket.on("minfo_res", (data) {
      print('minfo_res $data');
      if (this.mounted) {
        setState(() {
          infoRoom = data;
          print("ini info room " + infoRoom.toString());
        });
      }
    });

    socket.on("delete_message_res", (data) async {
      print("delete message res " + data.toString());

      print("ini delete response " + data.toString());
      if (chatRoomId.toString() == data['mChatRoomId'].toString()) {
        print("masuk sini 0");
        setState(() {
          //kalau delete message, messages di remove
          for (int i = 0; i < messages.length; i++) {
            print("masuk sini 1");
            if (messages[i]['mChatId'].toString() ==
                data['mChatId'].toString()) {
              print("masuk sini 2");
              messages.removeAt(i);
            }
          }
        });
      }
    });

    socket.on("receive_msg", (data) async {
      print("RECEIVE NEW MSG " + data.toString());

      if (data['status'] == true &&
          chatRoomId.toString() == data['mChatRoomId'].toString()) {
        setState(() {
          //kalau sebagai pengirim, messages di replace
          if (mId == data['message'][0]['mSenderId'].toString()) {
            for (int i = 0; i < messages.length; i++) {
              if (messages[i]['mChatId'] == 0 &&
                  messages[i]['mChatData'] == data['message'][0]['mChatData']) {
                messages[i] = data['message'][0];
                print("PLUTO " + messages[i].toString());
              }
            }
          }
          //kalau sebagai penerima langsung ditambah
          else {
            print("BUMI " + messages[0].toString());
            messages.add(data['message'][0]);
            socket.emit("chat_read_req", {
              "mChatId": data['message'][0]['mChatId'].toString(),
              "mChatRoomId": chatRoomId.toString(),
              "mSenderId": data['message'][0]['mSenderId'].toString(),
              "mRecipientId": data['message'][0]['mRecipientId'].toString(),
            });
          }
        });
        await scrollMax();
      } else {
        BaseFunction().displayToast(data['errorMessage']);
      }
    });

    socket.on("update_msg_res", (data) async {
      print("update_msg_res " + data.toString());
      if (chatRoomId.toString() == data['mChatRoomId'].toString()) {
        setState(() {
          //kalau edit message, messages di replace
          for (int i = 0; i < messages.length; i++) {
            if (messages[i]['mChatId'] == data['message'][0]['mChatId']) {
              messages[i]['mChatData'] = data['message'][0]['mChatData'];
            }
          }
        });
      }
    });

    socket.on("mupload_res", (data) async {
      print("UPLOAD RECEIVE CHAT MEMBER " + data.toString());

      if (chatRoomId.toString() == data['mChatRoomId'].toString()) {
        setState(() {
          messages.add(data['message'][0]);
          // socket.emit("read_item_request", {
          //   "chatId": data['message'][0]['chatId'].toString(),
          //   "roomId": widget.roomData['roomId'].toString(),
          //   "mId": int.parse(mId)
          // });
          isLoading = false;
        });
        await scrollMax();
        print("ini messages upload " + messages.toString());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    socket.dispose();
    if (widget.onRefresh != null) {
      widget.onRefresh();
    }
  }

  Future scrollMax() async {
    return SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(microseconds: 1),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    print("ini long press " + dataPressMsg.toString());
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    TextStyle appBarTextStyle = TextStyle(fontSize: 16.0, color: Colors.white);
    String colorUser =
        BaseFunction().getUserColor(widget.recipientData['mName']);
    String initName =
        BaseFunction().getInitialName(widget.recipientData['mName']);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: (pressEdit == false && dataPressMsg.isEmpty) ||
                pressEdit == true
            ? AppBar(
                titleSpacing: 0,
                backgroundColor: Theme.of(context).primaryColorDark,
                leading: new IconButton(
                  icon: new Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (this.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                title: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              width: 1.4,
                              color: Colors.transparent,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  BaseFunction().convertColor(colorUser),
                              maxRadius: 20,
                              child: Text(initName,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                              backgroundImage:
                                  NetworkImage(widget.recipientData['mPic']),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              maxRadius: 20,
                              backgroundImage:
                                  NetworkImage(widget.recipientData['mPic']),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.recipientData['mName'],
                              style: appBarTextStyle),
                          SizedBox(height: 3),
                        ],
                      ),
                    ],
                  ),
                ),
                bottom: infoRoom.isNotEmpty
                    ? PreferredSize(
                        preferredSize: Size.fromHeight(55),
                        child: GestureDetector(
                          onTap: () {
                            showInfoRoom(infoRoom);
                          },
                          child: Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            height: 55,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(infoRoom[0]['rcInfoTitle'],
                                      style: TextStyle(
                                          fontSize: 12.5, color: Colors.blue),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1),
                                  SizedBox(height: 5),
                                  Expanded(
                                    child: Html(
                                      data: infoRoom[0]['rcInfoData'],
                                      style: {
                                        '#': Style(
                                            fontSize: FontSize(11),
                                            maxLines: 1,
                                            textOverflow: TextOverflow.ellipsis,
                                            margin: EdgeInsets.zero),
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : null,
              )
            : AppBar(
                titleSpacing: 0,
                backgroundColor: Theme.of(context).primaryColorDark,
                leading: new IconButton(
                  icon: new Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (this.mounted) {
                      setState(() {
                        dataPressMsg.clear();
                      });
                    }
                  },
                ),
                title: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            if (this.mounted) {
                              setState(() {
                                dataPressMsg.forEach((item) {
                                  chatParent = item;
                                });
                                dataPressMsg.clear();
                                print(
                                    "ini chat parent " + chatParent.toString());
                              });
                            }
                          },
                          child: Icon(FontAwesomeIcons.reply,
                              size: 20, color: Colors.white)),
                      SizedBox(width: 16),
                      dataPressMsg[0]['file'].isEmpty &&
                              dataPressMsg[0]['mChatType'] == "text"
                          ? InkWell(
                              onTap: () {
                                if (this.mounted) {
                                  setState(() {
                                    pressEdit = true;
                                  });
                                }
                              },
                              child: Icon(Icons.edit, color: Colors.white))
                          : SizedBox(),
                      SizedBox(width: 16),
                      InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Hapus Pesan?"),
                                  content: Text(
                                      "Apakah anda yakin ingin hapus pesan ini ?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("BATAL"),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        deleteMessage();
                                      },
                                      highlightColor: Colors.red[100],
                                      child: Text(
                                        "HAPUS",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Icon(FontAwesomeIcons.trashAlt,
                              size: 20, color: Colors.white)),
                      SizedBox(width: 16),
                    ],
                  ),
                )),
        body: Stack(
          children: [
            messages.isNotEmpty
                ? Container(
                    height: height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 8.0,
                          bottom: MediaQuery.of(context).viewInsets.bottom > 0.0
                              ? MediaQuery.of(context).viewInsets.bottom +
                                  height / 10
                              : height / 10),
                      child: buildMessageList(),
                    ),
                  )
                : Container(
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.forum,
                          color: Colors.grey[700],
                          size: 64,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Belum Ada Obrolan. \nKirim Pesan Pertama Anda',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )),
                  ),
            (pressEdit == false && dataPressMsg.isEmpty) || pressEdit == true
                ? Positioned(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 0,
                    right: 0,
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                              color: Colors.white, child: buildInputArea()),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ));
  }

  void sendMessage(String type) async {
    print("masuk send");
    if (chatController.text == "" && type == 'text') return;
    var now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    print("time " + now.toString());
    String colorUser = BaseFunction().getUserColor(dataMember[0]['mName']);
    if (this.mounted) {
      setState(() {
        socket.emit("send_msg", {
          "mChatRoomId": chatRoomId,
          "mSenderId": dataMember[0]['mId'].toString(),
          "mRecipientId": widget.recipientData['mId'].toString(),
          "mChatData": type == "giphy"
              ? _gif
              : type == "sticker"
                  ? stickerOn
                  : chatController.text,
          "mChatType": type,
          "mChatColor": colorUser,
          "mChatParentId":
              chatParent == null ? "0" : chatParent['mChatId'].toString()
        });

        messages.add({
          "mChatId": 0,
          "mSenderId": dataMember[0]['mId'].toString(),
          "mName": dataMember[0]['mName'],
          "mChatRoomId": chatRoomId.toString(),
          "mChatData": type == "giphy"
              ? _gif
              : type == "sticker"
                  ? stickerOn
                  : chatController.text,
          "mChatTimestamp": now,
          "mChatColor": colorUser,
          "mChatType": type,
          "mPic": dataMember[0]['urlSource'] +
              "" +
              dataMember[0]['mDir'].toString() +
              "/" +
              dataMember[0]['mPic'],
          "file": []
        });
        if (chatParent != null) {
          messages[messages.length - 1]['parentData'] = [chatParent];
        }
        print("PARENT TEST " +
            messages[messages.length - 1]['parentData'].toString());
        chatController.clear();
        chatParent = null;
      });
    }
    print("latest data " + messages[messages.length - 1].toString());
    print("messagesss " + messages.toString());
  }

  void sendFile() async {
    var now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    print("time " + now.toString());
    if (this.mounted) {
      setState(() {
        String colorUser = BaseFunction().getUserColor(dataMember[0]['mName']);
        List pickFile = [];
        List pickedFileName = [];
        for (int i = 0; i < pickedFile.length; i++) {
          pickFile.add(base64Encode(pickedFile[i].readAsBytesSync()));
          pickedFileName.add(pickedFile[i].path.split('/').last);
        }
        data = {
          "mChatParentId":
              chatParent == null ? "0" : chatParent['mChatId'].toString(),
          "mSenderId": dataMember[0]['mId'].toString(),
          "mRecipientId": widget.recipientData['mId'].toString(),
          "mChatRoomId": chatRoomId,
          "mChatData": chatController.text == ""
              ? "A file from ${dataMember[0]['mName']}"
              : chatController.text,
          "mChatType": "text",
          "mChatColor": colorUser,
          "mChatFile": jsonEncode(pickFile),
          "mChatFileType": chatFileType,
          "mChatFileName": jsonEncode(pickedFileName),
        };
        print("ini data file " + data['mChatFile'].toString());
        print("ini data file name" + data['mChatFileName'].toString());
        socket.emit("mupload_req", data);
        isLoading = true;
        chatController.clear();
        pickedFile = null;
        chatParent = null;
        pickedFileName.clear();
        pickFile.clear();
        chatFileType = "";
      });
      await scrollMax();
    }
  }

  void deleteMessage() async {
    if (this.mounted) {
      print("masukk");
      setState(() {
        socket.emit("delete_message_req", {
          "mChatId": dataPressMsg[0]['mChatId'].toString(),
          "mChatRoomId": chatRoomId
        });
        dataPressMsg.clear();
        Navigator.pop(context);
      });
    }
  }

  void editMessage() async {
    if (chatController.text == "") return;
    if (this.mounted) {
      setState(() {
        socket.emit("update_msg_req", {
          "mChatId": dataPressMsg[0]['mChatId'].toString(),
          "mChatData": chatController.text,
          "mChatRoomId": chatRoomId.toString()
        });
        chatController.clear();
        dataPressMsg.clear();
        pressEdit = false;
      });
    }
  }

  Widget buildMessageList() {
    return Container(
      height: height,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        controller: scrollController,
        itemCount: messages.length > 0 ? messages.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return buildSingleMessage(index);
        },
      ),
    );
  }

  Widget buildSingleMessage(int index) {
    print("PESAN " + messages.toString());
    // mPic = messages[index]['urlSource']+""+messages[index]['mDir'].toString()+"/"+messages[index]['mPic'];
    BorderRadiusGeometry sender = BorderRadius.only(
        topRight: Radius.circular(16.0),
        topLeft: Radius.circular(16.0),
        bottomLeft: Radius.circular(16.0));
    BorderRadiusGeometry recipient = BorderRadius.only(
        topRight: Radius.circular(16.0),
        topLeft: Radius.circular(16.0),
        bottomRight: Radius.circular(16.0));

    DateTime timestamp =
        BaseFunction().timestampToDateTime(messages[index]['mChatTimestamp']);
    String date = BaseFunction()
        .checkTodayYesterday(timestamp, messages[index]['mChatTimestamp']);
    var time = BaseFunction()
        .convertToDate(messages[index]['mChatTimestamp'], "HH:mm");
    String initName =
        BaseFunction().getInitialName(widget.recipientData['mName']);
    return Container(
      child: Column(
        children: [
          _showDate(messages, index)
              ? Container(
                  margin: const EdgeInsets.only(
                      top: 16, left: 10.0, right: 10.0, bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 4),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          color: Colors.lightGreen[100],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            date.toString(),
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          Container(
            padding: EdgeInsets.all(5),
            color: (dataPressMsg.isNotEmpty || pressEdit == true)
                ? pressEdit == false &&
                        messages[index]['mChatId'].toString() ==
                            dataPressMsg[0]['mChatId'].toString()
                    ? Colors.green.shade50
                    : null
                : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: mId == messages[index]['mSenderId'].toString()
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                (dataPressMsg.isNotEmpty || pressEdit == true)
                    ? pressEdit == false &&
                            messages[index]['mChatId'].toString() ==
                                dataPressMsg[0]['mChatId'].toString()
                        ? Container(
                            width: 20,
                            height: 20,
                            decoration: new BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white)),
                            child: new Icon(
                              Icons.check,
                              size: 10,
                              color: Colors.white,
                            ),
                          )
                        : Container()
                    : Container(),
                SizedBox(width: 12),
                mId != messages[index]['mSenderId'].toString()
                    ? displayMemberPhoto(
                        initName,
                        widget.recipientData['mPic'],
                        messages[index]['mChatColor'],
                        messages[index]['mSenderId'].toString())
                    : Container(),
                Flexible(
                  child: InkWell(
                    onLongPress: () {
                      print("INI PESAN SELECT " + messages[index].toString());
                      setState(() {
                        if (this.mounted) {
                          if (messages[index]['mSenderId'].toString() == mId) {
                            dataPressMsg.add(messages[index]);
                          } else {
                            chatParent = messages[index];
                          }
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      margin: mId == messages[index]['mSenderId'].toString()
                          ? const EdgeInsets.only(
                              top: 8, left: 40.0, right: 12.0)
                          : const EdgeInsets.only(
                              top: 8, left: 12.0, right: 40.0),
                      decoration: BoxDecoration(
                        color: mId == messages[index]['mSenderId'].toString()
                            ? Colors.blueGrey.withOpacity(0.15)
                            : Colors.blue[50],
                        borderRadius:
                            mId == messages[index]['mSenderId'].toString()
                                ? sender
                                : recipient,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                !messages[index].containsKey('parentData')
                                    ? SizedBox()
                                    : messages[index]['parentData'].isEmpty
                                        ? SizedBox()
                                        : Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                    color: BaseFunction()
                                                        .convertColor(messages[
                                                                    index]
                                                                ['parentData']
                                                            [0]['mChatColor']),
                                                    width: 4),
                                              ),
                                            ),
                                            child: Container(
                                              margin: EdgeInsets.only(left: 6),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    messages[index]
                                                            ['parentData'][0]
                                                        ['mName'],
                                                    style: TextStyle(
                                                        color: BaseFunction()
                                                            .convertColor(messages[
                                                                        index][
                                                                    'parentData'][0]
                                                                ['mChatColor']),
                                                        fontSize: 10.0,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(height: 4),
                                                  messages[index]['parentData']
                                                                  [0]
                                                              ['mChatType'] ==
                                                          'text'
                                                      ? Text(
                                                          messages[index]
                                                                  ['parentData']
                                                              [0]['mChatData'],
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 10.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )
                                                      : Stack(
                                                          children: [
                                                            CachedNetworkImage(
                                                                imageUrl: messages[
                                                                            index]
                                                                        [
                                                                        'parentData'][0]
                                                                    [
                                                                    'mChatData'],
                                                                placeholder:
                                                                    (context,
                                                                        i) {
                                                                  return Container(
                                                                    width: 150,
                                                                    height: 150,
                                                                    color: Colors
                                                                        .white,
                                                                  );
                                                                },
                                                                errorWidget: (_,
                                                                    __, ___) {
                                                                  return Image
                                                                      .asset(
                                                                          "assets/images/logo_ts_red.png");
                                                                }),
                                                            Positioned(
                                                                child:
                                                                    Image.asset(
                                                              'assets/images/PoweredBy_Giphy_Logo.gif',
                                                              height: 20,
                                                            ))
                                                          ],
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                SizedBox(
                                    height: !messages[index]
                                            .containsKey('parentData')
                                        ? 0
                                        : 10),
                                Text(
                                  mId == messages[index]['mSenderId'].toString()
                                      ? dataMember[0]['mName'].toString()
                                      : widget.recipientData['mName'],
                                  style: TextStyle(
                                      color: BaseFunction().convertColor(
                                          messages[index]['mChatColor']),
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 4),
                                messages[index]['mChatType'] == "text"
                                    ? Text(
                                        messages[index]['mChatData'],
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : Stack(
                                        children: [
                                          CachedNetworkImage(
                                              imageUrl: messages[index]
                                                  ['mChatData'],
                                              placeholder: (context, i) {
                                                return Container(
                                                  width: 150,
                                                  height: 150,
                                                  color: Colors.white,
                                                );
                                              },
                                              errorWidget: (_, __, ___) {
                                                return Image.asset(
                                                    "assets/images/logo_ts_red.png");
                                              }),
                                          messages[index]['mChatType'] ==
                                                  "sticker"
                                              ? Container()
                                              : Positioned(
                                                  child: Image.asset(
                                                  'assets/images/PoweredBy_Giphy_Logo.gif',
                                                  height: 20,
                                                ))
                                        ],
                                      ),
                                SizedBox(height: 5),
                                messages[index]['file'].isNotEmpty
                                    ? messages[index]['file'][0]
                                                ['mChatFileType'] ==
                                            "images"
                                        ? GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount:
                                                        messages[index]['file']
                                                                    .length ==
                                                                1
                                                            ? 1
                                                            : 2),
                                            itemCount:
                                                messages[index]['file'].length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, i) {
                                              print("ini file " +
                                                  messages[index]['file'][i]
                                                          ['mFileUrl']
                                                      .toString());
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => PreviewImageChat(
                                                              url: messages[index]
                                                                          ['file'][i]
                                                                      [
                                                                      'mFileUrl']
                                                                  .toString(),
                                                              senderName: mId ==
                                                                      messages[index]['mSenderId']
                                                                          .toString()
                                                                  ? "Anda"
                                                                  : messages[index]
                                                                      ['mName'],
                                                              dateMessage:
                                                                  messages[index]
                                                                      ['mChatTimestamp'])));
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: messages[index]
                                                        ['file'][i]['mFileUrl'],
                                                    placeholder: (context, i) {
                                                      return Image.asset(
                                                          "assets/images/logo_ts_red.png");
                                                    },
                                                    errorWidget: (_, __, ___) {
                                                      return Image.asset(
                                                          "assets/images/img_not_available.jpeg",
                                                          width: 30,
                                                          height: 30);
                                                    },
                                                  ),
                                                ),
                                              );
                                            })
                                        : PlayAudio(
                                            url: messages[index]['file'][0]
                                                ['mFileUrl'],
                                            fileName: messages[index]['file'][0]
                                                ['mChatFileName'])
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 4),
                            child: Text(
                              time.toString(),
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 9.0,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // mId == messages[index]['mSenderId'].toString() ?
                // displayMemberPhoto(initName, widget.recipientData['mPic'], messages[index]['mChatColor'], messages[index]['mSenderId'].toString())
                //     : Container(),
                SizedBox(width: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputArea() {
    print("ini chat parent " + chatParent.toString());
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          chatParent == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(
                      left: 14.0, right: 14.0, bottom: 12.0, top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      color: Colors.orangeAccent.withOpacity(0.08),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: Icon(
                              Icons.reply,
                              size: 26,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chatParent['mName'],
                                  style: TextStyle(
                                      color: BaseFunction().convertColor(
                                          chatParent['mChatColor']),
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 4),
                                chatParent['mChatType'] == 'text'
                                    ? Text(
                                        chatParent['mChatData'],
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : Stack(
                                        children: [
                                          CachedNetworkImage(
                                              imageUrl: chatParent['mChatData'],
                                              placeholder: (context, i) {
                                                return Container(
                                                  width: 150,
                                                  height: 150,
                                                  color: Colors.white,
                                                );
                                              },
                                              errorWidget: (_, __, ___) {
                                                return Image.asset(
                                                    "assets/images/logo_ts_red.png");
                                              }),
                                          Positioned(
                                              child: Image.asset(
                                            'assets/images/PoweredBy_Giphy_Logo.gif',
                                            height: 20,
                                          ))
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (this.mounted) {
                                setState(() {
                                  chatParent = null;
                                });
                              }
                            },
                            child: Icon(
                              Icons.clear_rounded,
                              size: 24,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          pickedFile == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16, right: 16, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              child: ListView.builder(
                                itemCount: pickedFile.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, i) {
                                  print("ini type file chat " + chatFileType);
                                  return Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: chatFileType == "images"
                                          ? Image(
                                              image: FileImage(pickedFile[i]))
                                          : Row(children: [
                                              Icon(FontAwesomeIcons.fileAudio,
                                                  size: 15),
                                              SizedBox(width: 5),
                                              Text(
                                                pickedFile[i]
                                                    .path
                                                    .split('/')
                                                    .last,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            ]));
                                },
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (this.mounted) {
                                setState(() {
                                  pickedFile = null;
                                  chatFileType = "";
                                  print("ini type file chat " + chatFileType);
                                });
                              }
                            },
                            child: Icon(
                              Icons.clear_rounded,
                              size: 24,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Container(
                          width: width / 2,
                          child: Text(
                            chatFileType == "images"
                                ? pickedFile.length.toString() + " Image File"
                                : pickedFile.length.toString() + " Audio File",
                            style: TextStyle(color: Colors.blue),
                          ))
                    ],
                  ),
                ),
          pressEdit == true && dataPressMsg.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(
                      left: 14.0, right: 14.0, bottom: 12.0, top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      color: Colors.orangeAccent.withOpacity(0.08),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: Icon(
                              Icons.edit,
                              size: 26,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ubah Pesan",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  dataPressMsg[0]['mChatData'],
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (this.mounted) {
                                setState(() {
                                  chatController.text = "";
                                  dataPressMsg.clear();
                                  pressEdit = false;
                                });
                              }
                            },
                            child: Icon(
                              Icons.clear_rounded,
                              size: 24,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
          Row(
            children: <Widget>[
              Expanded(child: buildChatInput()),
              SizedBox(
                width: 16,
              ),
              buildSendButton(),
              SizedBox(
                width: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSendButton() {
    return isLoading
        ? BaseView().displayLoadingScreen(context, color: Colors.blue)
        : FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColorDark,
            onPressed: () {
              if (pressEdit == true && dataPressMsg.isNotEmpty) {
                editMessage();
              } else {
                if (pickedFile == null) {
                  sendMessage('text');
                } else {
                  sendFile();
                }
              }
            },
            child: Icon(
              Icons.send,
              size: 30,
            ),
          );
  }

  Widget buildChatInput() {
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: 100),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            color: Colors.black12.withOpacity(0.08),
          ),
          // width: width / 2,
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.only(left: 16, top: 8),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 10),
            child: Scrollbar(
              child: TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration.collapsed(
                    hintText: 'Pesan...', hintStyle: TextStyle(fontSize: 14)),
                controller: chatController,
              ),
            ),
          ),
        ),
        dataPressMsg.isNotEmpty && dataPressMsg[0]['mChatType'] == "text"
            ? SizedBox()
            : Positioned(
                bottom: 17,
                left: 23,
                child: InkWell(
                  onTap: () async {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (builder) => stickerSheet(context));
                  },
                  child: Icon(
                    Icons.face,
                    size: 23,
                    color: Colors.black54,
                  ),
                )),
        dataPressMsg.isNotEmpty && dataPressMsg[0]['mChatType'] == "text"
            ? SizedBox()
            : Positioned(
                bottom: 15,
                right: 0,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (builder) => fileSheet(context));
                  },
                  child: Icon(
                    Icons.attach_file,
                    size: 24,
                    color: Colors.black54,
                  ),
                ))
      ],
    );
  }

  Widget displayMemberPhoto(
      String initName, String mPic, String chatColor, String senderId) {
    return InkWell(
      onTap: () {
        print("ini senderId " + senderId);
        socket.emit('profile_request', senderId);

        socket.on("profile_response", (data) {
          print("profile_response " + data['message'].toString());
          setState(() {
            if (data['status'] == true) {
              List dataProfile = data['message'];
              displayProfile(dataProfile);
              socket.off("profile_response");
            } else {
              BaseFunction().displayToast(data['errorMessage']);
            }
          });
        });
      },
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: BaseFunction().convertColor(chatColor),
            maxRadius: 20,
            child: Text(initName,
                style: TextStyle(color: Colors.white, fontSize: 12)),
            backgroundImage: NetworkImage(mPic),
          ),
          CircleAvatar(
            backgroundColor: Colors.transparent,
            maxRadius: 20,
            backgroundImage: NetworkImage(mPic),
          ),
        ],
      ),
    );
  }

  bool _showDate(List data, int index) {
    if (data.length > 1) {
      if (index == 0) {
        return true;
      }
      final String dateRecentIndex = BaseFunction()
          .convertToDate(data[index]['mChatTimestamp'], 'd MMMM yyyy');
      final String datePrev = BaseFunction()
          .convertToDate(data[index - 1]['mChatTimestamp'], 'd MMMM yyyy');
      if (dateRecentIndex == datePrev) {
        return false;
      }
      return true;
    }
    return true;
  }

  void displayProfile(List dataProfile) {
    const double dialogPadding = 8.0, avatarRadius = 60.0;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dialogPadding),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: dialogPadding + avatarRadius,
                  bottom: dialogPadding,
                  left: dialogPadding,
                  right: dialogPadding,
                ),
                width: double.infinity,
                margin: EdgeInsets.only(top: avatarRadius),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(dialogPadding),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // T
                  children: <Widget>[
                    Text(
                      dataProfile[0]['mName'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    dataProfile[0]['bio'].isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: 6, bottom: 6, left: 12, right: 12),
                            child: Text(
                              dataProfile[0]['bio'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 11.0,
                                  fontFamily: 'expressway',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87),
                            ),
                          )
                        : Container(),
                    dataProfile[0]['kabupatenName'].isNotEmpty
                        ? Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: InputChip(
                              onPressed: () {},
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              label: Text(
                                dataProfile[0]['kabupatenName'],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11),
                                overflow: TextOverflow.ellipsis,
                              ),
                              avatar: Icon(Icons.location_city_outlined,
                                  color: Colors.white, size: 15),
                              backgroundColor: Colors.blue,
                              elevation: 2,
                            ),
                          )
                        : SizedBox(),
                    SizedBox(height: 5),
                    dataProfile[0]['waShow'] == "n"
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0),
                            child: InkWell(
                              onTap: () {
                                BaseFunction().sendWhatsApp(
                                    dataProfile[0]['mWa'].toString(), "");
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 12),
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(4.0),
                                //   border: Border.all(color: Colors.grey[300]),
                                // ),
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.whatsapp,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      dataProfile[0]['mWa'],
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    dataProfile[0]['emailShow'] == "n"
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                BaseFunction()
                                    .launchMail(dataProfile[0]['mEmail']);
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 12),
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(4.0),
                                //   border: Border.all(color: Colors.grey[300]),
                                // ),
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.envelope,
                                      size: 14,
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(dataProfile[0]['mEmail'],
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: 5),
                    Divider(height: 0),
                    SizedBox(height: 5),
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification:
                            (OverscrollIndicatorNotification overscroll) {
                          overscroll.disallowGlow();
                        },
                        child: GridView.count(
                          childAspectRatio: 4,
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                if (dataProfile[0]['fb'].toString() != "") {
                                  BaseFunction().launchURL(
                                      dataProfile[0]['fb'].toString());
                                }
                              },
                              child: Container(
                                child: Center(
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.facebook,
                                        color: dataProfile[0]['fb'] == ""
                                            ? Colors.grey
                                            : Colors.blue,
                                        size: 13,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Facebook",
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: dataProfile[0]['fb'] == ""
                                                ? Colors.grey
                                                : Colors.blue,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (dataProfile[0]['instagram'].toString() !=
                                    "") {
                                  BaseFunction().launchURL(
                                      dataProfile[0]['instagram'].toString());
                                }
                              },
                              child: Container(
                                child: Center(
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.instagram,
                                        color: dataProfile[0]['instagram'] == ""
                                            ? Colors.grey
                                            : Colors.blue,
                                        size: 13,
                                      ),
                                      SizedBox(width: 6),
                                      Text("Instagram",
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: dataProfile[0]
                                                          ['instagram'] ==
                                                      ""
                                                  ? Colors.grey
                                                  : Colors.blue,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (dataProfile[0]['website'].toString() !=
                                    "") {
                                  BaseFunction().launchURL(
                                      dataProfile[0]['website'].toString());
                                }
                              },
                              child: Center(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.globe,
                                        color: dataProfile[0]['website'] == ""
                                            ? Colors.grey
                                            : Colors.blue,
                                        size: 13,
                                      ),
                                      SizedBox(width: 6),
                                      Text("Website",
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: dataProfile[0]
                                                          ['website'] ==
                                                      ""
                                                  ? Colors.grey
                                                  : Colors.blue,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (dataProfile[0]['tiktok'].toString() != "") {
                                  BaseFunction().launchURL(
                                      dataProfile[0]['tiktok'].toString());
                                }
                              },
                              child: Center(
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.tiktok,
                                      size: 13,
                                      color: dataProfile[0]['tiktok'] == ""
                                          ? Colors.grey
                                          : Colors.blue,
                                    ),
                                    SizedBox(width: 6),
                                    Text("Tik Tok",
                                        style: TextStyle(
                                            fontSize: 11,
                                            color:
                                                dataProfile[0]['tiktok'] == ""
                                                    ? Colors.grey
                                                    : Colors.blue,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (dataProfile[0]['twitter'].toString() !=
                                    "") {
                                  BaseFunction().launchURL(
                                      dataProfile[0]['twitter'].toString());
                                }
                              },
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.twitter,
                                      color: dataProfile[0]['twitter'] == ""
                                          ? Colors.grey
                                          : Colors.blue,
                                      size: 13,
                                    ),
                                    SizedBox(width: 6),
                                    Text("Twitter",
                                        style: TextStyle(
                                            fontSize: 11,
                                            color:
                                                dataProfile[0]['twitter'] == ""
                                                    ? Colors.grey
                                                    : Colors.blue,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (dataProfile[0]['youtube'].toString() !=
                                    "") {
                                  BaseFunction().launchURL(
                                      dataProfile[0]['youtube'].toString());
                                }
                              },
                              child: Center(
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.youtube,
                                      size: 11,
                                      color: dataProfile[0]['youtube'] == ""
                                          ? Colors.grey
                                          : Colors.blue,
                                    ),
                                    SizedBox(width: 6),
                                    Text("Youtube",
                                        style: TextStyle(
                                            fontSize: 11,
                                            color:
                                                dataProfile[0]['youtube'] == ""
                                                    ? Colors.grey
                                                    : Colors.blue,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (dataProfile[0]['linkedin'].toString() !=
                                    "") {
                                  BaseFunction().launchURL(
                                      dataProfile[0]['linkedin'].toString());
                                }
                              },
                              child: Center(
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.linkedin,
                                      size: 11,
                                      color: dataProfile[0]['linkedin'] == ""
                                          ? Colors.grey
                                          : Colors.blue,
                                    ),
                                    SizedBox(width: 6),
                                    Text("LinkedIn",
                                        style: TextStyle(
                                            fontSize: 11,
                                            color:
                                                dataProfile[0]['linkedin'] == ""
                                                    ? Colors.grey
                                                    : Colors.blue,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Divider(),
                  ],
                ),
              ),
              Positioned(
                left: dialogPadding,
                right: dialogPadding,
                child: CircleAvatar(
                  radius: avatarRadius,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.all(Radius.circular(avatarRadius)),
                    child: CachedNetworkImage(
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                        imageUrl: dataProfile[0]['mPic'],
                        width: avatarRadius * 2,
                        height: avatarRadius * 2,
                        placeholder: (context, i) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(avatarRadius),
                            child: Image.asset(
                              "assets/images/account_picture_default.png",
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        errorWidget: (_, __, ___) {
                          return Image.asset(
                              "assets/images/account_picture_default.png");
                        }),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  showInfoRoom(List dataInfo) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          child: Container(
            margin: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(infoRoom[0]['rcInfoTitle'],
                      style: TextStyle(fontSize: 14, color: Colors.blue)),
                  SizedBox(height: 5),
                  Html(
                    data: infoRoom[0]['rcInfoData'],
                    style: {
                      '#': Style(
                          fontSize: FontSize(12), margin: EdgeInsets.zero),
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget stickerSheet(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(18.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () async {
                      print("ini masuk giphy");
                      final gif = await GiphyPicker.pickGif(
                        context: context,
                        fullScreenDialog: false,
                        showPreviewPage: true,
                        apiKey: 'jp9FxIMdh5TdH5tJ1XKnT6hOM2ti6RT5',
                        decorator: GiphyDecorator(
                          showAppBar: false,
                          searchElevation: 4,
                          giphyTheme: ThemeData.dark(),
                        ),
                      );
                      if (gif != null) {
                        setState(() {
                          _gif = gif.images.original.url;
                          sendMessage('giphy');
                          Navigator.pop(context);
                          print("ini gif " + _gif.toString());
                        });
                      }
                    },
                    child: Icon(Icons.gif, size: 60)),
                SizedBox(
                  width: 40,
                ),
                InkWell(
                    onTap: () async {
                      final information = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StickerList(),
                          settings: RouteSettings(name: "Sticker Page"),
                        ),
                      );
                      if (information != null) {
                        print("picked sticker " + information.toString());
                        if (this.mounted) {
                          setState(() {
                            stickerOn = information;
                            Navigator.of(context).pop();
                          });
                        }
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (builder) => stickerSend(context));
                      }
                    },
                    child: Icon(FontAwesomeIcons.stickyNote, size: 30)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget stickerSend(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(18.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: ClipOval(
                child: Image.network(
                  stickerOn,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 100),
            InkWell(
                onTap: () {
                  sendMessage("sticker");
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.send,
                  size: 40,
                  color: Colors.blue,
                )),
          ],
        ),
      ),
    );
  }

  Widget fileSheet(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(18.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconCreation(context, Icons.camera_alt, Colors.pink, "Camera"),
                SizedBox(
                  width: 40,
                ),
                iconCreation(
                    context, Icons.insert_photo, Colors.purple, "Gallery"),
                SizedBox(
                  width: 40,
                ),
                iconCreation(context, Icons.headset, Colors.orange, "Audio"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget iconCreation(
      BuildContext context, IconData icons, Color color, String text) {
    return InkWell(
      onTap: () {
        if (text == 'Camera') {
          uploadImage(context, ImageSource.camera, 1);
        } else if (text == 'Gallery') {
          uploadImage(context, ImageSource.gallery, 2);
        } else if (text == 'Audio') {
          uploadImage(context, ImageSource.gallery, 3);
        }
        Navigator.pop(context);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }

  Future uploadImage(BuildContext context, ImageSource source, int code) async {
    //code 1 = from camera, code 2 =  from gallery photo, code 3 = from gallery audio
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();

    if (statuses[Permission.camera] == PermissionStatus.granted &&
        statuses[Permission.storage] == PermissionStatus.granted) {
      var imageFile, _image;
      if (code == 1) {
        //upload image from camera
        imageFile = await ImagePicker()
            .getImage(source: source, maxHeight: 480, maxWidth: 640);
        _image =
            await FlutterExifRotation.rotateAndSaveImage(path: imageFile.path);
        setState(() {
          pickedFile = [_image];
        });
        checkExtSizeFile(code);
      } else if (code == 2) {
        //upload images from gallery
        FilePickerResult result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: [
            'jpg',
            'jpeg',
            'png',
            'gif',
          ],
        );
        if (result != null) {
          setState(() {
            pickedFile = result.paths.map((path) => File(path)).toList();
          });
          checkExtSizeFile(code);
        }
      } else if (code == 3) {
        //upload audio from gallery
        FilePickerResult result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: [
            'm4a',
            'm4a',
            'mp3',
            'm4p',
            'wav',
            'wma',
            'aac',
            'aiff',
            'ogg',
            'oga',
            'mogg',
            'alac'
          ],
        );
        if (result != null) {
          setState(() {
            pickedFile = result.paths.map((path) => File(path)).toList();
          });
          checkExtSizeFile(code);
        }
      }
    } else if (statuses[Permission.camera] != PermissionStatus.granted &&
        statuses[Permission.storage] != PermissionStatus.granted) {
      BaseFunction().displayToast(
          'Akses kamera dan penyimpanan dibutuhkan untuk fitur ini');
    } else if (statuses[Permission.camera] != PermissionStatus.granted) {
      BaseFunction().displayToast('Akses kamera dibutuhkan untuk fitur ini');
    } else if (statuses[Permission.storage] != PermissionStatus.granted) {
      BaseFunction()
          .displayToast('Akses penyimpanan dibutuhkan untuk fitur ini');
    }
  }

  void checkExtSizeFile(int code) {
    //code 1 = from camera,
    // code 2 =  from gallery photo,
    // code 3 = from gallery audio
    if (pickedFile != null) {
      for (int i = 0; i < pickedFile.length; i++) {
        chatFileType = checkExtension(pickedFile[i].path);
        if (chatFileType != "images" && (code == 1 || code == 2)) {
          BaseFunction().displayToast("File anda bukan gambar");
          setState(() {
            pickedFile = null;
            chatFileType = "";
          });
        } else if (chatFileType != "audio" && code == 3) {
          BaseFunction().displayToast("File anda bukan audio");
          setState(() {
            pickedFile = null;
            chatFileType = "";
          });
        } else {
          int sizeInBytes = pickedFile[i].lengthSync();
          double sizeInMb = sizeInBytes / (1024 * 1024);
          print("ini size " + sizeInMb.toString());
          if (sizeInMb > 10) {
            BaseFunction().displayToast('File maksimum adalah 10MB');
            setState(() {
              pickedFile = null;
              chatFileType = "";
            });
          }
        }
      }
    }
  }

  String checkExtension(String file) {
    //check extension file and get type
    var imageExt = ['.jpg', '.jpeg', '.png', '.gif'];
    var audioExt = [
      '.m4a',
      '.m4a',
      '.mp3',
      '.m4p',
      '.wav',
      '.wma',
      '.aac',
      '.aiff',
      '.ogg',
      '.oga',
      '.mogg',
      '.alac'
    ];

    final _extension = path.extension(file);

    if (imageExt.contains(_extension)) {
      return "images";
    } else if (audioExt.contains(_extension)) {
      return "audio";
    }
    print("ini ext " + _extension);
    print("ini file data " + file);
  }
}
