class BaseResponse {
  bool success;
  String message;
  String errorMessage;

  BaseResponse ({this.success, this.message, this.errorMessage});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse (
        success : json ['success'],
        message: json ['message'],
        errorMessage: json ['errorMessage']
    );
  }

  Map toMap() {
    var map = Map<String, dynamic>();
    map ['success'] = success;
    map ['message'] = message;
    map ['errorMessage'] = errorMessage;

    return map;
  }
}