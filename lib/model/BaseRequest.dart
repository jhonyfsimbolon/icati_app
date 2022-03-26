class BaseRequest {
  String deviceId;
  String token;

  BaseRequest({this.deviceId, this.token});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['deviceid'] = deviceId;
    map['token'] = token;

    return map;
  }
}
