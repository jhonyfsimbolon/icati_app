import 'dart:convert';
import 'dart:io';

class Directory {
  String merchantName;
  String merchantHp;
  String merchantType;
  String provinsiId;
  String kabupatenId;
  String contactPerson;
  String contactPersonHp;
  String contactPersonEmail;
  String address;
  String watermark;
  String merchantStatus;
  String merchantEmail;
  String merchantDesc;
  String merchantSpecialNote;
  String merchantDiscount;
  String merchantDiscountTerms;
  String merchantWeb;
  String merchantOperational;
  String merchantLine;
  String merchantYoutube;
  String merchantFacebook;
  String merchantWhatsApp;
  String merchantTwitter;
  String merchantInstagram;
  String merchantTelegram;
  List<int> merchantCategory;
  File pic;
  int picLength;

  Directory(
      {this.merchantName,
      this.merchantHp,
      this.merchantType,
      this.provinsiId,
      this.kabupatenId,
      this.contactPerson,
      this.contactPersonHp,
      this.contactPersonEmail,
      this.address,
      this.watermark,
      this.merchantStatus,
      this.merchantEmail,
      this.merchantDesc,
      this.merchantSpecialNote,
      this.merchantDiscount,
      this.merchantDiscountTerms,
      this.merchantWeb,
      this.merchantOperational,
      this.merchantLine,
      this.merchantYoutube,
      this.merchantFacebook,
      this.merchantWhatsApp,
      this.merchantTwitter,
      this.merchantInstagram,
      this.merchantTelegram,
      this.merchantCategory,
      this.pic,
      this.picLength});

  Map toAddDirectory() {
    var map = new Map<String, String>();
    map['merchantName'] = merchantName;
    map['merchantHp'] = merchantHp;
    map['merchantType'] = merchantType;
    map['provinsiId'] = provinsiId;
    map['kabupatenId'] = kabupatenId;
    map['contactPerson'] = contactPerson;
    map['contactPersonHp'] = contactPersonHp;
    map['contactPersonEmail'] = contactPersonEmail;
    map['address'] = address;
    // map['watermark'] = watermark;
    // map['merchantStatus'] = merchantStatus;
    map['email'] = merchantEmail;
    map['merchantDesc'] = merchantDesc;
    map['merchantSpecialNote'] = merchantSpecialNote;
    map['merchantDiscount'] = merchantDiscount;
    map['merchantDiscountTerms'] = merchantDiscountTerms;
    map['merchantWeb'] = merchantWeb;
    map['merchantOperational'] = merchantOperational;
    map['merchantLine'] = merchantLine;
    map['merchantYoutube'] = merchantYoutube;
    map['merchantFacebook'] = merchantFacebook;
    map['merchantWa'] = merchantWhatsApp;
    map['merchantTwitter'] = merchantTwitter;
    map['merchantInstagram'] = merchantInstagram;
    map['merchantTelegram'] = merchantTelegram;
    map['merchantCategory'] = jsonEncode(merchantCategory);
    return map;
  }
}
