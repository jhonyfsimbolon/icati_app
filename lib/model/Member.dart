import 'dart:io';

class Member {
  String mId;
  String mName;
  //tambahan
  String mNameMandarin;
  String mNameUniv;
  String mThnMasuk;
  String mAlamat;
  String mTemLahir;
  String mJob;
  String negaraid;
  //batas
  String mGender;
  String mFirstName;
  String mLastName;
  String mAppleId;
  String mGoogleId;
  String mFbId;
  String mTwitterId;
  String mCard;
  String mEmail;
  String emailVerification;
  String mHp;
  String urlSource;
  String mDir;
  String mPic;
  String deviceId;
  File pic;
  int picLength;
  String lat;
  String long;
  String newPass;
  String confirmPass;
  String mPassword;
  String provinsiId;
  String kabupatenId;
  String kecamatanId;
  String kelurahanId;
  String mReligion;
  String mBlood;
  String birthDate;
  String referenceNumber;
  String mIdReference;

  //media social
  String fb;
  String twitter;
  String ig;
  String youtube;
  String linkedIn;
  String tikTok;
  String website;
  String bio;
  String waShow;
  String emailShow;

  Member(
      {this.mName,
      //tambahan
      this.mNameMandarin,
      this.mNameUniv,
      this.mThnMasuk,
      this.mAlamat,
      this.mTemLahir,
      this.mJob,
      this.negaraid,
      //batas

      this.mGender,
      this.mFirstName,
      this.mLastName,
      this.mAppleId,
      this.mFbId,
      this.mGoogleId,
      this.mTwitterId,
      this.mCard,
      this.mEmail,
      this.emailVerification,
      this.mId,
      this.urlSource,
      this.mDir,
      this.mPic,
      this.deviceId,
      this.lat,
      this.long,
      this.pic,
      this.mHp,
      this.mPassword,
      this.confirmPass,
      this.newPass,
      this.picLength,
      this.provinsiId,
      this.kabupatenId,
      this.kecamatanId,
      this.kelurahanId,
      this.mReligion,
      this.mBlood,
      this.birthDate,
      this.referenceNumber,
      this.twitter,
      this.emailShow,
      this.waShow,
      this.bio,
      this.website,
      this.linkedIn,
      this.youtube,
      this.fb,
      this.ig,
      this.tikTok,
      this.mIdReference});

  Map toRegisterMap() {
    var map = new Map<String, String>();
    map['name'] = mName;
    //tambahan
    map['mandarinname'] = mNameMandarin;
    map['universityname'] = mNameUniv;
    map['universityyear'] = mThnMasuk;
    // map['address'] = mAlamat;
    // map['placeBirth'] = mTemLahir;
    //batas
    // map['gender'] = mGender;
    // map['religion'] = mReligion;
    map['provinsiId'] = provinsiId;
    map['kabupatenId'] = kabupatenId;
    map['negaraid'] = negaraid;
    // map['bloodType'] = mBlood;
    // map['birthDate'] = birthDate;
    map['email'] = mEmail;
    map['password'] = mPassword;
    map['noreferensi'] = referenceNumber;
    map['devicelocationlat'] = lat;
    map['devicelocationlong'] = long;
    map['emailVerification'] = emailVerification;
    map["deviceid"] = deviceId;
    map["googleId"] = mGoogleId;
    map["appleId"] = mAppleId;
    map["fbId"] = mFbId;
    map["twitterId"] = mTwitterId;
    return map;
  }

  Map toCheckRegisterMap() {
    var map = Map<String, dynamic>();
    map['email'] = mEmail;
    map['name'] = mName;
    map['deviceid'] = deviceId;
    map['devicelocationlat'] = lat;
    map['devicelocationlong'] = long;
    return map;
  }

  Map toEditSetPassMap() {
    var map = new Map<String, String>();
    map['mid'] = mId;
    map['eachpassword'] = mPassword;
    map['newpassword'] = newPass;
    map['re_newpassword'] = confirmPass;
    return map;
  }

  Map toEditProfileMap() {
    var map = new Map<String, String>();
    map['mid'] = mId;
    map['name'] = mName;
    //
    map['mandarinname'] = mNameMandarin;
    map['universityname'] = mNameUniv;
    map['universityyear'] = mThnMasuk;
    map['negaraid'] = negaraid;
    //
    map['address'] = mAlamat;
    map['placeBirth'] = mTemLahir;
    map['mJob'] = mJob;
    //
    map['gender'] = mGender;
    map['provinsiId'] = provinsiId;
    map['kabupatenId'] = kabupatenId;
    map['noreferensi'] = referenceNumber;
    map['date'] = birthDate;
    map['religion'] = mReligion;
    map['bloodtype'] = mBlood;
    return map;
  }

  Map toCompleteProfileMap() {
    var map = new Map<String, String>();
    map['mid'] = mId;
    map['gender'] = mGender;
    map['religion'] = mReligion;
    map['provinsiId'] = provinsiId;
    map['kabupatenId'] = kabupatenId;
    map['bloodtype'] = mBlood;
    map['noreferensi'] = referenceNumber;
    map['date'] = birthDate;
    return map;
  }

  Map toEditSosMedMap() {
    var map = new Map<String, String>();
    map['mId'] = mId;
    map['facebook'] = fb;
    map['twitter'] = twitter;
    map['instagram'] = ig;
    map['youtube'] = youtube;
    map['linkedIn'] = linkedIn;
    map['tiktok'] = tikTok;
    map['website'] = website;
    map['bio'] = bio;
    map['waShow'] = waShow;
    map['emailShow'] = emailShow;
    return map;
  }
}
