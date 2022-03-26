import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketHelper {
  // String url = "http://192.168.1.13";
  // String url = "http://chaticati.webby.digital";
  String url = "http://chat.icati.or.id";
  // String url = "mmm";

  IO.Socket socket;
  IO.Socket connectServer(String roomID, String personID) {
    // return socket = IO.io(url + ":3000", <String, dynamic>{
    return socket = IO.io(url + ":5001", <String, dynamic>{
      "query": "chatRoomID=$roomID",
      "query": {"chatRoomID": roomID, "personID": personID},
      "transports": ['websocket', 'polling'],
      "autoConnect": false,
      'forceNew': true
    });
  }
}
