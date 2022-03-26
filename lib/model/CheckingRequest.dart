import 'package:icati_app/model/BaseRequest.dart';

class CheckingRequest extends BaseRequest {
  int mId;
  String mIdReference;
  String deviceOsType;
  String deviceName;
  String deviceManufacturer;
  String deviceModel;
  String deviceSdk;
  String deviceProduct;
  String deviceOsVersion;
  String deviceBoard;
  String deviceBrand;
  String deviceDisplay;
  String deviceHardware;
  String deviceHost;
  String deviceSerial;
  String deviceType;
  String deviceUser;
  String deviceImei;
  String deviceLocationLat;
  String deviceLocationLong;

  CheckingRequest(
      {this.mId,
      this.mIdReference,
      this.deviceOsType,
      this.deviceName,
      this.deviceManufacturer,
      this.deviceModel,
      this.deviceSdk,
      this.deviceProduct,
      this.deviceOsVersion,
      this.deviceBoard,
      this.deviceBrand,
      this.deviceDisplay,
      this.deviceHardware,
      this.deviceHost,
      this.deviceSerial,
      this.deviceType,
      this.deviceUser,
      this.deviceImei,
      this.deviceLocationLat,
      this.deviceLocationLong});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['mid'] = mId.toString();
    map['mIdReference'] = mIdReference;
    map['deviceid'] = deviceId;
    map['devicename'] = deviceName;
    map['devicemanufacturer'] = deviceManufacturer;
    map['devicemodel'] = deviceModel;
    map['devicesdk'] = deviceSdk;
    map['deviceproduct'] = deviceProduct;
    map['deviceosversion'] = deviceOsVersion;
    map['deviceboard'] = deviceBoard;
    map['devicebrand'] = deviceBrand;
    map['devicedisplay'] = deviceDisplay;
    map['devicehardware'] = deviceHardware;
    map['devicehost'] = deviceHost;
    map['deviceserial'] = deviceSerial;
    map['devicetype'] = deviceType;
    map['deviceuser'] = deviceUser;
    map['deviceimei'] = deviceImei;
    map['devicelocationlat'] = deviceLocationLat;
    map['devicelocationlong'] = deviceLocationLong;
    map['deviceostype'] = deviceOsType;

    return map;
  }
}
