import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:icati_app/model/CheckingRequest.dart';
import 'package:icati_app/model/Directory.dart';
import 'package:icati_app/model/Job.dart';
import 'package:icati_app/model/LoginRequest.dart';
import 'package:icati_app/model/Member.dart';
import 'package:path/path.dart';

class ApiHelper {
  // final String baseUrl = "https://paramitafoundationriau.com/api/public";
  final String baseUrl = "https://www.icati.or.id/api/public";
  Map<String, String> requestHeaders = {
    'X-Salt': '5b45841a23e2bf0e61aa747e0739455579c73148',
    'X-App-Version': '1',
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  Future searchOrganisasiHome(String searchOrganisasi) async {
    var response = await http.post(
        Uri.parse("$baseUrl/member/search/organisasi_home"),
        headers: requestHeaders,
        body: <String, String>{"searchOrganisasi": searchOrganisasi});
    return response;
  }

  Future versionChecking(String token, CheckingRequest checkingRequest) async {
    requestHeaders.addAll({'X-Token': token});
    var response = await http.post(
      Uri.parse("$baseUrl/member/versionchecking"),
      headers: requestHeaders,
      body: checkingRequest.toMap(),
    );
    return response;
  }

  Future getIndex(String mId, String locationLat, String locationLong) async {
    final String url = "$baseUrl/member/index";
    var response = await http.post(
      Uri.parse(url),
      headers: requestHeaders,
      body: <String, String>{
        "mid": mId == null || mId == "" ? 0.toString() : mId,
        "locationlat": locationLat,
        "locationlong": locationLong,
      },
    );
    return response;
  }

  Future register(Member member) async {
    http.Response response = await http.post(
      Uri.parse("$baseUrl/member/register"),
      headers: requestHeaders,
      body: member.toRegisterMap(),
    );
    return response;
  }

  Future loginByGoogle(LoginRequest loginRequest) async {
    var response = await http.post(Uri.parse("$baseUrl/member/login/google"),
        headers: requestHeaders, body: loginRequest.toLoginByGoogleMap());
    return response;
  }

  Future loginByFb(LoginRequest loginRequest) async {
    var response = await http.post(Uri.parse("$baseUrl/member/login/fb"),
        headers: requestHeaders, body: loginRequest.toLoginByFbMap());
    return response;
  }

  Future loginByTwitter(LoginRequest loginRequest) async {
    var response = await http.post(Uri.parse("$baseUrl/member/login/twitter"),
        headers: requestHeaders, body: loginRequest.toLoginByTwitterMap());
    return response;
  }

  Future loginByPassword(LoginRequest loginRequest) async {
    var response = await http.post(Uri.parse("$baseUrl/member/login/password"),
        headers: requestHeaders, body: loginRequest.toLoginByPasswordMap());
    return response;
  }

  Future loginByApple(LoginRequest loginRequest) async {
    var response = await http.post(Uri.parse("$baseUrl/member/login/apple"),
        headers: requestHeaders, body: loginRequest.toLoginAppleMap());
    return response;
  }

  // Future signinApple(LoginRequest loginRequest) async {
  //   var response = await http.post(Uri.parse("$baseUrl/member/login/apple"),
  //       headers: requestHeaders, body: <String, String>{"appleidentifier": loginRequest.appleIdentifier, "email": loginRequest.email, "name":loginRequest.name, "deviceid":loginRequest.deviceId,});
  //   return response;
  // }

  Future getProfile(String mid) async {
    var response = await http.get(Uri.parse("$baseUrl/member/profile/$mid"),
        headers: requestHeaders);
    return response;
  }

  Future editProfile(Member member) async {
    final String url = "$baseUrl/member/edit/profile";
    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);
    if (member.pic != null) {
      var stream =
          http.ByteStream(DelegatingStream.typed(member.pic.openRead()));
      var multipartFile = http.MultipartFile('file', stream, member.picLength,
          filename: basename(member.pic.path));
      request.files.add(multipartFile);
    }
    request.headers.addAll(requestHeaders);
    request.fields.addAll(member.toEditProfileMap());

    var response = await request.send();
    return response;
  }

  Future logout(String mId, String deviceId) async {
    var response = await http.post(Uri.parse("$baseUrl/member/logout"),
        headers: requestHeaders,
        body: <String, String>{"mid": mId, "deviceid": deviceId});
    return response;
  }

  Future editSetPassword(Member member) async {
    var response = await http.post(
        Uri.parse("$baseUrl/member/editset/password"),
        headers: requestHeaders,
        body: member.toEditSetPassMap());
    return response;
  }

  Future getWaKeyword(String mId) async {
    var response = await http.get(Uri.parse("$baseUrl/number/wa/keyword/$mId"),
        headers: requestHeaders);
    return response;
  }

  Future getNewNotification(String mId) async {
    var response = await http.get(
        Uri.parse("$baseUrl/checknew/notification/$mId"),
        headers: requestHeaders);
    return response;
  }

  Future checkCompleteData(String mId) async {
    var response = await http.get(
        Uri.parse("$baseUrl/member/check/completedata/$mId"),
        headers: requestHeaders);
    return response;
  }

  Future phoneVerification(String mId, String hp) async {
    var response = await http.post(Uri.parse("$baseUrl/member/hp/verification"),
        headers: requestHeaders, body: <String, String>{"mid": mId, "hp": hp});
    return response;
  }

  Future sendOtpEmail(String email, String id) async {
    var response = await http.post(Uri.parse("$baseUrl/member/otpemail"),
        headers: requestHeaders,
        body: <String, String>{"email": email, "mid": id});
    return response;
  }

  Future updateStatusEmail(String email, String id) async {
    var response = await http.post(
        Uri.parse("$baseUrl/member/updatestatusemail"),
        headers: requestHeaders,
        body: <String, String>{"email": email, "mid": id});
    return response;
  }

  Future sendLoginOtpEmail(String email) async {
    var response = await http.post(
        Uri.parse("$baseUrl/member/login/send/otpemail"),
        headers: requestHeaders,
        body: <String, String>{"email": email});
    return response;
  }

  Future loginOtpEmail(LoginRequest loginRequest) async {
    var response = await http.post(Uri.parse("$baseUrl/member/login/otpemail"),
        headers: requestHeaders, body: loginRequest.toLoginByEmail());
    return response;
  }

  Future resendLoginOtpEmail(
      String email, String mId, String otp, String expTime) async {
    var response = await http.post(
        Uri.parse("$baseUrl/member/login/resend/otpemail"),
        headers: requestHeaders,
        body: <String, String>{
          "mEmail": email,
          "mId": mId,
          "otpcode": otp,
          "exptime": expTime
        });
    return response;
  }

  Future checkHp(String mId, String hp) async {
    var response = await http.post(Uri.parse("$baseUrl/member/check/hp"),
        headers: requestHeaders,
        body: <String, String>{"mid": mId, "newphone": hp});
    return response;
  }

  Future editHp(String mId, String hp) async {
    var response = await http.post(Uri.parse("$baseUrl/member/change/hp"),
        headers: requestHeaders,
        body: <String, String>{"mid": mId, "newphone": hp});
    return response;
  }

  Future sendLoginOtpWa(String wa) async {
    var response = await http.post(
        Uri.parse("$baseUrl/member/login/send/otpwa"),
        headers: requestHeaders,
        body: <String, String>{"nowa": wa});
    return response;
  }

  Future loginOtpWa(LoginRequest loginRequest) async {
    var response = await http.post(Uri.parse("$baseUrl/member/login/otpwa"),
        headers: requestHeaders, body: loginRequest.toLoginByWa());
    return response;
  }

  Future notificationList(String mId) async {
    var response = await http.get(Uri.parse("$baseUrl/notification/$mId"),
        headers: requestHeaders);
    return response;
  }

  Future notificationReadAll(String mId) async {
    var response = await http.get(Uri.parse("$baseUrl/read/notification/$mId"),
        headers: requestHeaders);
    return response;
  }

  Future notificationNew(String mId) async {
    var response = await http.get(
        Uri.parse("$baseUrl/checknew/notification/$mId"),
        headers: requestHeaders);
    return response;
  }

  Future notificationReadItem(String mId, String notificationId) async {
    var response = await http.get(
        Uri.parse("$baseUrl/readitem/$mId/$notificationId"),
        headers: requestHeaders);
    return response;
  }

  Future getMemberCardList() async {
    var response = await http.get(Uri.parse("$baseUrl/member/carddesign"),
        headers: requestHeaders);
    return response;
  }

  // Future getMemberCardList() async {
  //   var response = await http.get(Uri.parse("$baseUrl/member/membercard"),
  //       headers: requestHeaders);
  //   return response;
  // }

  Future getVerifyEmail(String mId) async {
    var response = await http.get(Uri.parse("$baseUrl/member/verifymail/$mId"),
        headers: requestHeaders);
    return response;
  }

  Future checkHPLoginSMS(String hp) async {
    var response = await http.get(
        Uri.parse("$baseUrl/member/login/sms/check/$hp"),
        headers: requestHeaders);
    return response;
  }

  Future loginSMS(String hp, String deviceId, String lat, String long) async {
    var response = await http.post(Uri.parse("$baseUrl/member/login/sms"),
        headers: requestHeaders,
        body: <String, String>{
          "hp": hp,
          "deviceid": deviceId,
          "devicelocationlat": hp,
          "devicelocationlong": hp,
        });
    return response;
  }

  Future sendVerifyEmailChange(String mId, String email) async {
    var response = await http.post(
        Uri.parse("$baseUrl/member/sendverify/changemail"),
        headers: requestHeaders,
        body: <String, String>{"mid": mId, "newemail": email});
    return response;
  }

  Future editEmail(String mId, String email) async {
    var response = await http.post(Uri.parse("$baseUrl/member/change/email"),
        headers: requestHeaders,
        body: <String, String>{"mId": mId, "email": email});
    return response;
  }

  Future reSendVerifyEmail(String mId) async {
    var response = await http.get(
        Uri.parse("$baseUrl/member/resendverifyemail/$mId"),
        headers: requestHeaders);
    return response;
  }

  Future checkWaExist(String mId) async {
    var response = await http.get(Uri.parse("$baseUrl/member/exist/wa/$mId"),
        headers: requestHeaders);
    return response;
  }

  Future checkEmail(String mId, String email) async {
    var response = await http.post(Uri.parse("$baseUrl/member/check/email"),
        headers: requestHeaders,
        body: <String, String>{"mid": mId, "email": email});
    return response;
  }

  Future getAboutUs() async {
    var response = await http.get(
      Uri.parse("$baseUrl/member/tentangkami"),
      headers: requestHeaders,
    );
    return response;
  }

  Future getInfoContact() async {
    var response = await http.get(
      Uri.parse("$baseUrl/member/hubungikami"),
      headers: requestHeaders,
    );
    return response;
  }

  Future getOrganisasiListHome() async {
    var response = await http.get(
      Uri.parse("$baseUrl/member/organisasi_listhome"),
      headers: requestHeaders,
    );
    return response;
  }

  Future sendContactInfo(
      String name, String hp, String email, String message) async {
    final String url = "$baseUrl/member/addcontactinformation";
    return await http
        .post(Uri.parse(url), headers: requestHeaders, body: <String, String>{
      "name": name,
      "email": email,
      "hp": hp,
      "message": message,
    });
  }

  Future homeContent(String organisasiId) async {
    var response = await http.post(Uri.parse("$baseUrl/member/homecontent"),
        headers: requestHeaders,
        body: <String, String>{"organisasi": organisasiId});
    return response;
  }

  Future getNewsList(String page) async {
    var response = await http.post(Uri.parse("$baseUrl/member/newslist"),
        headers: requestHeaders, body: <String, String>{"page": page});
    return response;
  }

  Future getNewsDetail(String newsId) async {
    var response = await http.post(Uri.parse("$baseUrl/member/newsdetail"),
        headers: requestHeaders, body: <String, String>{"newsId": newsId});
    return response;
  }

  Future addCommentNews(
      String newsId, String name, String email, String message) async {
    var response = await http.post(Uri.parse("$baseUrl/member/news/addcomment"),
        headers: requestHeaders,
        body: <String, String>{
          "id": newsId,
          "name": name,
          "email": email,
          "message": message
        });
    return response;
  }

  Future getAgendaList(String page) async {
    var response = await http.post(
        Uri.parse("$baseUrl/member/agendakegiatanlist"),
        headers: requestHeaders,
        body: <String, String>{"page": page});
    return response;
  }

  Future getAgendaListMore(String kabupatenId, String page) async {
    var response = await http.post(Uri.parse("$baseUrl/member/agendalistmore"),
        headers: requestHeaders,
        body: <String, String>{"kabupatenId": kabupatenId, "page": page});
    return response;
  }

  Future getAgendaDetail(String agendaId) async {
    var response = await http.post(Uri.parse("$baseUrl/member/agendadetail"),
        headers: requestHeaders, body: <String, String>{"akId": agendaId});
    return response;
  }

  Future getProvince() async {
    final String url = "$baseUrl/member/provinsi";
    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    return response;
  }

  Future getJobType() async {
    final String url = "$baseUrl/member/jobtype";
    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    return response;
  }

  Future getNegaraReg() async {
    final String url = "$baseUrl/member/negara";
    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    return response;
  }

  Future getProvinceReg() async {
    final String url = "$baseUrl/member/provinsireg";
    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    return response;
  }

  Future getCity(String provinceId) async {
    var response = await http.post(Uri.parse("$baseUrl/member/kabupaten"),
        headers: requestHeaders,
        body: <String, String>{"provinsiId": provinceId});
    return response;
  }

  Future getCityReg(String provinceId) async {
    var response = await http.post(Uri.parse("$baseUrl/member/kabupatenreg"),
        headers: requestHeaders,
        body: <String, String>{"provinsiId": provinceId});
    return response;
  }

  Future completeProfile(Member member) async {
    http.Response response = await http.post(
      Uri.parse("$baseUrl/member/complete/profile"),
      headers: requestHeaders,
      body: member.toCompleteProfileMap(),
    );
    return response;
  }

  Future getDirectoryDetail(String directoryId) async {
    var response = await http.get(
        Uri.parse("$baseUrl/member/directorydetail/$directoryId"),
        headers: requestHeaders);
    return response;
  }

  Future searchExplore(String search, String type) async {
    var response = await http.post(Uri.parse("$baseUrl/member/search/explore"),
        headers: requestHeaders,
        body: <String, String>{
          "search": search,
          "type": type,
        });
    return response;
  }

  Future getDirectoryCategory(String provinsiId, String kabupatenId) async {
    var response = await http.get(
        Uri.parse("$baseUrl/member/directorycategory/$provinsiId/$kabupatenId"),
        headers: requestHeaders);
    return response;
  }

  Future getSosMed(String mId) async {
    var response = await http.get(
      Uri.parse("$baseUrl/member/detail/socialmedia/$mId"),
      headers: requestHeaders,
    );
    return response;
  }

  Future editSosMed(Member member) async {
    var response = await http.post(
        Uri.parse("$baseUrl/member/edit/socialmedia"),
        headers: requestHeaders,
        body: member.toEditSosMedMap());
    return response;
  }

  Future getDirectorySubCat(String page, String catId, String subCatId,
      String provinsiId, String kabupatenId) async {
    var response = await http.post(
        Uri.parse(
            "$baseUrl/member/directorysubcategory/$provinsiId/$kabupatenId"),
        headers: requestHeaders,
        body: <String, String>{
          "page": page,
          "catid": catId,
          "subcatid": subCatId,
        });
    return response;
  }

  Future getDirectorySearch(String keyword) async {
    var response = await http.post(
        Uri.parse("$baseUrl/member/search/directory"),
        headers: requestHeaders,
        body: <String, String>{
          "keyword": keyword,
        });
    return response;
  }

  Future getUnreadNotification(String mId) async {
    var response = await http.get(
        Uri.parse("$baseUrl/notifications/unread/$mId"),
        headers: requestHeaders);
    return response;
  }

  Future sendForgotPass(String emailForgot) async {
    var response = await http.post(Uri.parse("$baseUrl/member/forgotpassword"),
        headers: requestHeaders,
        body: <String, String>{
          "email": emailForgot,
        });
    return response;
  }

  Future getJobDetail(String jobId) async {
    var response = await http.get(Uri.parse("$baseUrl/member/jobdetail/$jobId"),
        headers: requestHeaders);
    return response;
  }

  Future getJobList(String page, String kabupatenId) async {
    var response = await http.post(Uri.parse("$baseUrl/member/joblist"),
        headers: requestHeaders,
        body: <String, String>{
          "page": page.toString(),
          "kabupatenid": kabupatenId.toString()
        });
    return response;
  }

  Future getJobSearch(String keyword) async {
    var response = await http.post(Uri.parse("$baseUrl/member/job/search"),
        headers: requestHeaders,
        body: <String, String>{
          "keyword": keyword.toString(),
        });
    return response;
  }

  Future resetPassword(String mId, String password, String rePassword) async {
    var response = await http.post(Uri.parse("$baseUrl/member/resetpassword"),
        headers: requestHeaders,
        body: <String, String>{
          "mid": mId,
          "password": password,
          'repassword': rePassword
        });
    return response;
  }

  Future getDonasiList(int page) async {
    var response = await http.post(
        Uri.parse("$baseUrl/member/social_assistance_list"),
        headers: requestHeaders,
        body: <String, String>{
          "page": page.toString(),
        });
    return response;
  }

  Future getDonasiDetail(String donasiId) async {
    var response = await http.get(
        Uri.parse("$baseUrl/member/social_assistance_detail/$donasiId"),
        headers: requestHeaders);
    return response;
  }

  Future getHerbalList(String page) async {
    var response = await http.get(Uri.parse("$baseUrl/herblist/$page"),
        headers: requestHeaders);
    return response;
  }

  Future getGalleryPhoto() async {
    var response = await http.get(
      Uri.parse("$baseUrl/member/albumfoto"),
      headers: requestHeaders,
    );
    return response;
  }

  Future getGalleryPhotoDetail(String albId) async {
    var response = await http.post(Uri.parse("$baseUrl/member/foto"),
        headers: requestHeaders,
        body: <String, String>{
          "albId": albId,
        });
    return response;
  }

  Future getGalleryVideo() async {
    var response = await http.get(
      Uri.parse("$baseUrl/member/albumvideo"),
      headers: requestHeaders,
    );
    return response;
  }

  Future getPundi() async {
    var response = await http.get(
      Uri.parse("$baseUrl/member/pundi"),
      headers: requestHeaders,
    );
    return response;
  }

  Future getJobField() async {
    var response = await http.get(
      Uri.parse("$baseUrl/member/bidanglist"),
      headers: requestHeaders,
    );
    return response;
  }

  Future getKabarDuka() async {
    var response = await http.get(
      Uri.parse("$baseUrl/member/kabarduka"),
      headers: requestHeaders,
    );
    return response;
  }

  Future getKabarDukaDetail(String kabardukaId) async {
    var response = await http.get(
      Uri.parse("$baseUrl/member/kabardukadetail/$kabardukaId"),
      headers: requestHeaders,
    );
    return response;
  }

  Future getGridKerjaSama() async {
    var response = await http.get(
      Uri.parse("$baseUrl/member/gridviewkerjasama"),
      headers: requestHeaders,
    );
    return response;
  }

  Future getOrganisasiList() async {
    var response = await http.get(
      Uri.parse("$baseUrl/member/organisasi_list"),
      headers: requestHeaders,
    );
    return response;
  }

  Future posOrganisasiDetail(String organizationId) async {
    var response = await http.post(
        Uri.parse("$baseUrl/member/organisasi_detail"),
        headers: requestHeaders,
        body: <String, String>{"organisasiId": organizationId});
    return response;
  }

  Future getLinkTerkaitGridView() async {
    var response = await http.get(
      Uri.parse("$baseUrl/member/gridviewrelatedlink"),
      headers: requestHeaders,
    );
    // body: <String, String>{"provinsiId": "", "kabupatenId": ""});
    return response;
  }

  Future addJob(Job job) async {
    final String url = "$baseUrl/member/job/add";
    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);
    if (job.pic != null) {
      var stream = http.ByteStream(DelegatingStream.typed(job.pic.openRead()));
      var multipartFile = http.MultipartFile('file', stream, job.picLength,
          filename: basename(job.pic.path));
      request.files.add(multipartFile);
    }
    request.headers.addAll(requestHeaders);
    request.fields.addAll(job.toAddJobMap());

    var response = await request.send();
    return response;
  }

  Future getCategoryOptionList() async {
    var response = await http.get(
        Uri.parse("$baseUrl/member/directoryallcategory/option"),
        headers: requestHeaders);
    return response;
  }

  Future addDirectory(Directory directory) async {
    final String url = "$baseUrl/member/directory/add";
    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);
    if (directory.pic != null) {
      print("ada gambar direktori");
      var stream =
          http.ByteStream(DelegatingStream.typed(directory.pic.openRead()));
      var multipartFile = http.MultipartFile(
          'file', stream, directory.picLength,
          filename: basename(directory.pic.path));
      request.files.add(multipartFile);
    }
    request.headers.addAll(requestHeaders);
    request.fields.addAll(directory.toAddDirectory());
    var response = await request.send();
    return response;
  }

  Future checkRegister(Member member) async {
    var response = await http.post(Uri.parse("$baseUrl/member/check/register"),
        headers: requestHeaders, body: member.toCheckRegisterMap());
    return response;
  }

  Future getCategoryJob() async {
    var response = await http.get(
      Uri.parse("$baseUrl/member/categoryjob"),
      headers: requestHeaders,
    );
    return response;
  }

  Future getJobListAll(String provinsiId, String cityId, String page) async {
    var response = await http.get(
      Uri.parse("$baseUrl/member/joblistall/$provinsiId/$cityId/$page"),
      headers: requestHeaders,
    );
    return response;
  }

  Future memberStories() async {
    var response = await http.get(Uri.parse("$baseUrl/member/stories"),
        headers: requestHeaders);
    return response;
  }

  Future herbalDetail(String herbalId) async {
    var response = await http.get(
      Uri.parse("$baseUrl/herbal/detail/$herbalId"),
      headers: requestHeaders,
    );
    return response;
  }

  // Future getDetailEvent(String id) async {
  //   var response = await http.get(
  //     Uri.parse(
  //         "https://api.brosispku.com/brosispku/public/member/event/detail/$id"),
  //     headers: requestHeaders,
  //   );
  //   return response;
  // }

  Future getPopUp() async {
    final String url = "$baseUrl/member/popup";
    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    return response;
  }

  Future getChatNotif(String mId, String kabupatenId) async {
    var response = await http.get(
      Uri.parse("$baseUrl/member/allchatnotif/$mId/$kabupatenId"),
      headers: requestHeaders,
    );
    return response;
  }
}
