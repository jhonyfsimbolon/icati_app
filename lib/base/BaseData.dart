import 'package:location/location.dart';

class BaseData {
  String deviceId;
  String lat = "";
  String long = "";
  String errorMessage = "";
  String message;
  String codeOtp = "";

  int page;
  int dataLength;

  bool isLogin;
  bool isFailed;
  bool isSaving;
  bool autoValidate;
  bool passwordVisible;
  bool rePasswordVisible;
  bool serviceEnabled;
  bool hpValidate;
  bool nameValidate;
  bool emailValidate;
  bool otpValidate;
  bool resendOTP;
  bool isSavingResend;
  bool isSearch;
  bool showCursor;
  bool isCheckedWa;
  bool isCheckedEmail;
  bool isLoading;

  double appBarHeight;

  PermissionStatus permissionGranted;
  LocationData locationData;

  BaseData(
      {this.deviceId,
      this.lat,
      this.long,
      this.errorMessage,
      this.message,
      this.page,
      this.dataLength,
      this.isLogin,
      this.isFailed,
      this.isSaving,
      this.autoValidate,
      this.passwordVisible,
      this.rePasswordVisible,
      this.serviceEnabled,
      this.hpValidate,
      this.nameValidate,
      this.emailValidate,
      this.otpValidate,
      this.resendOTP,
      this.appBarHeight,
      this.permissionGranted,
      this.locationData,
      this.codeOtp,
      this.isSearch,
      this.showCursor,
      this.isCheckedEmail,
      this.isCheckedWa,
      this.isLoading,
      this.isSavingResend});
}
