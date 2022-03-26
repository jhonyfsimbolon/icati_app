import 'package:icati_app/model/BaseRequest.dart';

class LoginRequest extends BaseRequest {
  String mId;
  String email;
  String wa;
  String name;
  String googleId;
  String fbId;
  String twitterId;
  String appleIdentifier;
  String password;
  String lat;
  String long;

  LoginRequest(
      {this.mId,
      this.email,
      this.wa,
      this.name,
      this.googleId,
      this.fbId,
      this.twitterId,
      this.appleIdentifier,
      this.password,
      this.lat,
      this.long});

  Map toLoginByGoogleMap() {
    var map = Map<String, dynamic>();
    map['email'] = email;
    map['name'] = name;
    map['googleId'] = googleId;
    map['deviceid'] = deviceId;
    map['devicelocationlat'] = lat;
    map['devicelocationlong'] = long;
    return map;
  }

  Map toLoginByFbMap() {
    var map = Map<String, dynamic>();
    map['email'] = email;
    map['name'] = name;
    map['fbId'] = fbId;
    map['deviceid'] = deviceId;
    map['devicelocationlat'] = lat;
    map['devicelocationlong'] = long;
    return map;
  }

  Map toLoginByTwitterMap() {
    var map = Map<String, dynamic>();
    map['email'] = email;
    map['name'] = name;
    map['twitterid'] = twitterId;
    map['deviceid'] = deviceId;
    map['devicelocationlat'] = lat;
    map['devicelocationlong'] = long;
    return map;
  }

  Map toLoginByPasswordMap() {
    var map = Map<String, dynamic>();
    map['emailHpWa'] = email;
    map['password'] = password;
    map['deviceid'] = deviceId;
    map['devicelocationlat'] = lat;
    map['devicelocationlong'] = long;
    return map;
  }

  Map toLoginAppleMap() {
    var map = Map<String, dynamic>();
    map['email'] = email;
    map['name'] = name;
    map['deviceid'] = deviceId;
    map['appleidentifier'] = appleIdentifier;
    map['devicelocationlat'] = lat;
    map['devicelocationlong'] = long;
    return map;
  }

  Map toLoginByEmail() {
    var map = Map<String, dynamic>();
    map['mId'] = mId;
    map['email'] = email;
    map['deviceid'] = deviceId;
    map['devicelocationlat'] = lat;
    map['devicelocationlong'] = long;
    return map;
  }

  Map toLoginByWa() {
    var map = Map<String, dynamic>();
    map['mId'] = mId;
    map['wa'] = wa;
    map['deviceid'] = deviceId;
    map['devicelocationlat'] = lat;
    map['devicelocationlong'] = long;
    return map;
  }
}
