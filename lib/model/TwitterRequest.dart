import 'package:icati_app/model/BaseRequest.dart';

class TwitterRequest extends BaseRequest {
  String username;
  String email;

  TwitterRequest({this.username, this.email});

  Map twitterSignInRequest() {
    var map = Map<String, dynamic>();
    map['username'] = username;
    map['email'] = email;
    return map;
  }
}
