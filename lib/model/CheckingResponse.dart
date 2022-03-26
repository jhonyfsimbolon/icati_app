import 'package:icati_app/model/BaseResponse.dart';

class CheckingResponse extends BaseResponse {
  String token;
  bool status_update;
  String status_member;
  bool force_update;

  CheckingResponse(
      {this.token, this.status_update, this.status_member, this.force_update});

  factory CheckingResponse.fromJson(Map<String, dynamic> json) {
    return CheckingResponse(
      token: json['token'],
      status_update: json['status_update'],
      status_member: json['status_member'],
      force_update: json['force_update'],
    );
  }

  Map toMap() {
    var map = Map<String, dynamic>();
    map['token'] = token;
    map['status_update'] = status_update;
    map['status_member'] = status_member;
    map['force_update'] = force_update;

    return map;
  }
}
