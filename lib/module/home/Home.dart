import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:icati_app/module/register/Register.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/home/DetailPopup.dart';
import 'package:icati_app/module/home/pattern/HomePresenter.dart';
import 'package:icati_app/module/home/pattern/HomeView.dart';
import 'package:icati_app/module/home/pattern/HomeWidgets.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';

import 'SearchOrganisasi.dart';

class Home extends StatefulWidget {
  List dataComplete;
  final Function handleBottomBarChanged;
  String type;

  Home({this.dataComplete, this.handleBottomBarChanged, this.type});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> implements HomeView {
  GlobalKey _keyCard = GlobalKey();
  List _dataOrganisasi, organisasiResult;
  String _currentOrganisasi = "0";
  List dataCard,
      dataProfile,
      dataOrganitation = [],
      dataJob = [],
      // dataDonasi = [],
      dataNews = [],
      dataAgenda = [],
      dataMember = [],
      dataBanner = [],
      dataKerjasama = [],
      dataKabarduka = [],
      dataLink = [],
      dataDirectory = [],
      dataPhoto = [],
      dataVideo = [],
      dataHerb = [],
      dataPopUp;
  // dataPundiBerkah,
  // datapundiKasih,
  // dataPundiAmal;
  HomePresenter homePresenter;
  BaseData _baseData = BaseData(isLogin: false);
  Member member = Member();
  int directoryTap = 0, unreadNotification = 0;
  var card, sizeCard, box;
  // var box;
  SharedPreferences prefs;
  TextEditingController searchCont = TextEditingController();
  bool isFilterTaped = false;
  dynamic page;

  @override
  void initState() {
    homePresenter = new HomePresenter();
    homePresenter.attachView(this);
    print("initstate");
    _getCredential();
    // if (widget.type == "dynamicLink") {
    //   Navigator.of(context).push(MaterialPageRoute(
    //       builder: (context) => Register(
    //           name: "",
    //           email: "",
    //           googleId: "",
    //           fbId: "",
    //           appleId: "",
    //           twitterId: "",
    //           emailVerification: 'n'),
    //       settings: RouteSettings(name: "Register")));
    // }
    super.initState();
  }

  void _getCredential() async {
    if (this.mounted) {
      prefs = await SharedPreferences.getInstance();
      box = await Hive.openBox("homeCache");
      _baseData.isLogin =
          prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
      // homePresenter.getpundi();
      homePresenter.getPopUp();
      homePresenter.getOrganisasiList();

      if (_baseData.isLogin) {
        //cache profile member shared preference
        if (prefs.containsKey("member")) {
          if (this.mounted) {
            setState(() {
              final user = prefs.getString("member");
              dataProfile = jsonDecode(user);
              print("ini data profile akun cache " + dataProfile.toString());

              member.deviceId = prefs.getString("deviceid");
              member.mId = dataProfile[0]['mId'].toString();
              member.mName = dataProfile[0]['mName'].toString();
              member.mFirstName = dataProfile[0]['mFirstName'].toString();
              member.mCard = dataProfile[0]['mCard'].toString();
              member.mIdReference = dataProfile[0]['mIdReference'];
              member.mEmail = dataProfile[0]['mEmail'].toString();
              member.urlSource = dataProfile[0]['urlSource'];
              member.mDir = dataProfile[0]['mDir'];
              member.mPic = dataProfile[0]['mPic'];
              print("ini mid" + member.mId.toString());
            });
          }
        }

        //call api
        homePresenter.getMemberCardList();
        homePresenter.getUnreadNotification(member.mId);
        homePresenter.getProfile(member.mId);
      } else {
        page = Register(
            name: "",
            email: "",
            googleId: "",
            fbId: "",
            appleId: "",
            twitterId: "",
            emailVerification: 'n');
      }

      //cache home hive
      if (await Hive.boxExists("homeCache")) {
        if (this.mounted) {
          if (box.get("homeCache") != null) {
            final dataBox = box.get("homeCache");
            print("ini data home cache " + dataBox.toString());

            Map data = jsonDecode(dataBox);
            dataNews = data['news'];
            dataOrganitation = data['organization'];
            // dataDonasi = data['donasi'];
            dataAgenda = data['agenda'];
            dataMember = data['newmember'];
            dataBanner = data['banner'];
            // dataHerb = data['herb'];
            dataDirectory = data['directory'];
            dataKabarduka = data['kabarduka'];
            dataKerjasama = data['kerjasama'];
            dataLink = data['relatedlink'];
            dataJob = data['job'];
            dataPhoto = data['photo'];
            dataVideo = data['video'];
          }
        }
      }

      homePresenter.getHomeContent(
          _currentOrganisasi != "0" && _currentOrganisasi != null
              ? _currentOrganisasi
              : "");
    }
  }

  Future<void> completeDataHome() async {
    await homePresenter.checkCompleteData(member.mId);
  }

  Future<Null> onRefresh() async {
    homePresenter.getOrganisasiList();
    if (_baseData.isLogin) {
      // homePresenter.getMemberCardList();
      homePresenter.getUnreadNotification(member.mId);
      homePresenter.getProfile(member.mId);
    }
    searchCont.text = "";
    homePresenter.getHomeContent(
        _currentOrganisasi != "0" && _currentOrganisasi != null
            ? _currentOrganisasi
            : "");
  }

  void onChangeDirectory(int index) {
    if (this.mounted) {
      setState(() {
        directoryTap = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    //print("ini shortSide " + shortestSide.toString());
    final bool useMobileLayout = shortestSide < 500;
    // if (dataCard != null) {
    //   final ImageStreamListener listener =
    //       ImageStreamListener((ImageInfo imageInfo, bool s) {
    //     WidgetsBinding.instance.addPostFrameCallback(_getSizes);
    //   });
    //   if (card != null) {
    //     card.image.resolve(new ImageConfiguration()).addListener(listener);
    //   }
    // }
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => Register(
    //         name: "",
    //         email: "",
    //         googleId: "",
    //         fbId: "",
    //         appleId: "",
    //         twitterId: "",
    //         emailVerification: 'n'),
    //     settings: RouteSettings(name: "Register")));
    print("ini widget dataComplete: " + widget.dataComplete.toString());
    return Scaffold(
      backgroundColor: baseColor,
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              HomeWidgets().displayHomeWallpaper(
                  context,
                  _baseData.isLogin,
                  dataCard,
                  member,
                  unreadNotification,
                  widget.handleBottomBarChanged,
                  // _currentOrganisasi,
                  // _selectOrganisasi,
                  // _dataOrganisasi,
                  displayQR,
                  widget.dataComplete != null
                      ? widget.dataComplete[0]['qr'].toString()
                      : "noQR",
                  useMobileLayout,
                  card,
                  sizeCard,
                  _onFilterTap),
              widget.dataComplete != null
                  ? HomeWidgets().displayProfileBar(
                      context, widget.dataComplete, completeDataHome)
                  : SizedBox.shrink(),
              // _baseData.isLogin ? SizedBox(height: 14) : SizedBox(),
              // _baseData.isLogin ? SizedBox() : SizedBox(),
              isFilterTaped
                  ? Padding(
                      padding: const EdgeInsets.only(
                          right: 10, left: 10, bottom: 10, top: 0),
                      child: HomeWidgets().displaySearchBox(
                        context,
                        _currentOrganisasi,
                        _selectOrganisasi,
                        _dataOrganisasi,
                      ))
                  : SizedBox(),
              dataBanner.length > 0
                  ? HomeWidgets()
                      .displayBanner(context, dataBanner, _baseData.isLogin)
                  : Container(),
              // dataDonasi.length > 0
              //     ? HomeWidgets().displayDonasi(context, dataDonasi)
              //     : SizedBox(),
              dataOrganitation.length > 0
                  ? HomeWidgets().displayOrganitation(context, dataOrganitation)
                  : Container(),
              _baseData.isLogin
                  ? HomeWidgets().displayNewMember(
                      context, dataMember, member.mId.toString())
                  : Container(),
              dataNews.length > 0
                  ? HomeWidgets().displayNews(context, dataNews)
                  : Container(),
              dataAgenda.length > 0
                  ? HomeWidgets().displayAgenda(context, dataAgenda)
                  : Container(),
              // dataJob.length > 0
              //     ? HomeWidgets().displayJob(context, dataJob)
              //     : Container(),
              dataDirectory.length > 0
                  ? HomeWidgets().displayDirectory(
                      context, dataDirectory, directoryTap, onChangeDirectory)
                  : Container(),
              // dataHerb.length > 0
              //     ? HomeWidgets().displayHerb(context, dataHerb)
              //     : Container(),
              dataPhoto.length > 0
                  ? HomeWidgets().displayPhoto(context, dataPhoto)
                  : Container(),
              dataVideo.length > 0
                  ? HomeWidgets().displayVideo(context, dataVideo)
                  : Container(),
              dataJob.length > 0
                  ? HomeWidgets().displayJob(context, dataJob)
                  : Container(),
              dataKabarduka.length > 0
                  ? HomeWidgets().displayKabarDuka(context, dataKabarduka)
                  : Container(),
              dataKerjasama.length > 0
                  ? HomeWidgets()
                      .displayKerjasama(context, dataKerjasama, kerjasamaDialog)
                  : Container(),
              // dataKabarduka.length > 0
              //     ? HomeWidgets()
              //         .displayKabarduka(context, dataKabarduka, kabardukaDialog)
              //     : Container(),
              dataLink.length > 0
                  ? HomeWidgets().displayRelatedLink(context, dataLink)
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  _getSizes(_) async {
    final RenderBox renderBox = _keyCard.currentContext.findRenderObject();
    final size = renderBox.size;
    setState(() {
      sizeCard = size;
      print("SIZE of card: $sizeCard");
    });
  }

  Future<void> displayQR() async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Container(
              width: 250.0,
              margin: EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: Image(
                  fit: BoxFit.contain,
                  image: NetworkImage(widget.dataComplete[0]['qr'].toString()),
                ),
              ),
            ),
          ]),
        );
      },
    );
  }

  navigateToSearch(BuildContext context) async {
    organisasiResult = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SearchOrganisasi(this._currentOrganisasi)),
    );
    if (organisasiResult != null) {
      // currentMarga = organisasiResult[1].toString();
      _currentOrganisasi = organisasiResult[0].toString();
      searchCont.text = _currentOrganisasi;
      _dataOrganisasi = null;
      homePresenter.getHomeContent(_currentOrganisasi);
    }
  }

  _onFilterTap() {
    navigateToSearch(context);
    // if(isFilterTaped){
    //   setState(() {
    //     isFilterTaped = false;
    //   });
    // }
    // else{
    //   setState(() {
    //     isFilterTaped= true;
    //   });
    // }
  }

  Future<void> kerjasamaDialog(BuildContext context, String nama, String desc,
      String link, String image) async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 200.0,
                margin: EdgeInsets.only(bottom: 20.0),
                child: Center(
                  child: Image(
                    fit: BoxFit.contain,
                    image: NetworkImage(image),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 0.0, bottom: 20.0),
                  child: Text(
                    nama,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              desc.length < 400
                  ? Container(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(0),
                          margin: EdgeInsets.only(bottom: 20),
                          child: Html(
                            data: desc,
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Container(
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(0),
                            margin: EdgeInsets.only(bottom: 20),
                            child: Html(
                              data: desc,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Kunjungi Website',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onPressed: () {
                BaseFunction().launchURL(link);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> kabardukaDialog(BuildContext context, String kabardukanama,
      String kabardukadesc, String kabardukalink, String kabardukaimage) async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 200.0,
                margin: EdgeInsets.only(bottom: 20.0),
                child: Center(
                  child: Image(
                    fit: BoxFit.contain,
                    image: NetworkImage(kabardukaimage),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 0.0, bottom: 20.0),
                  child: Text(
                    kabardukanama,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              kabardukadesc.length < 400
                  ? Container(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(0),
                          margin: EdgeInsets.only(bottom: 20),
                          child: Html(
                            data: kabardukadesc,
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Container(
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(0),
                            margin: EdgeInsets.only(bottom: 20),
                            child: Html(
                              data: kabardukadesc,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Kunjungi Website',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onPressed: () {
                // BaseFunction().launchURL(kabardukalink);
              },
            ),
          ],
        );
      },
    );
  }

  showPromo(List dataPopUp) async {
    if (!mounted || dataPopUp == null) return;
    prefs = await SharedPreferences.getInstance();
    bool isTap = false;
    if (!prefs.containsKey("popupTime")) {
      for (int i = 0; i < dataPopUp.length; i++) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isTap = true;
                      });
                      print("Alert is tapped !!");
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailPopup(
                            id: dataPopUp[i]['popId'].toString(),
                            title: dataPopUp[i]['popName'],
                            desc: dataPopUp[i]['popDesc'].toString(),
                            pic: dataPopUp[i]['popPic'],
                          ),
                        ),
                      );
                      return;
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: dataPopUp[i]['popPic'],
                        placeholder: (context, i) {
                          return Image.asset("assets/images/logo_ts_red.png",
                              height: 100, width: 100);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                        child: IconButton(
                          padding: const EdgeInsets.all(0.0),
                          iconSize: 30,
                          icon: Icon(Icons.cancel, color: Colors.grey[200]),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
        await Future.delayed(Duration(milliseconds: 500));
        if (isTap) {
          return;
        }
      }
      prefs.setString("popupTime", DateTime.now().toString());
    } else {
      String popupTime = prefs.getString("popupTime");
      print(DateTime.parse(popupTime).difference(DateTime.now()).abs());
      print(DateTime.now()
          .difference(DateTime.parse(popupTime))
          .abs()
          .compareTo(Duration(days: 1)));
      if (DateTime.now()
              .difference(DateTime.parse(popupTime))
              .abs()
              .compareTo(Duration(days: 1)) >
          0) {
        prefs.remove("popupTime");
        showPromo(dataPopUp);
      }
    }
  }

  // void showPundi(BuildContext context, dataPundi, iconData) {
  //   showGeneralDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       barrierLabel:
  //           MaterialLocalizations.of(context).modalBarrierDismissLabel,
  //       barrierColor: Colors.black45,
  //       transitionDuration: const Duration(milliseconds: 200),
  //       pageBuilder: (BuildContext buildContext, Animation animation,
  //           Animation secondaryAnimation) {
  //         return Center(
  //           child: Container(
  //             width: MediaQuery.of(context).size.width - ScreenUtil().setSp(50),
  //             height:
  //                 MediaQuery.of(context).size.height / ScreenUtil().setSp(3),
  //             padding: EdgeInsets.all(20),
  //             decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                     begin: Alignment.topCenter,
  //                     end: Alignment.bottomCenter,
  //                     colors: [
  //                   Color.fromRGBO(22, 50, 88, 1),
  //                   Color.fromRGBO(5, 129, 174, 1)
  //                 ])),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 Align(
  //                   alignment: Alignment.topRight,
  //                   child: GestureDetector(
  //                       onTap: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: Icon(
  //                         Icons.close,
  //                         size: 30,
  //                         color: Colors.white,
  //                       )),
  //                 ),
  //                 SizedBox(height: ScreenUtil().setSp(10)),
  //                 Icon(
  //                   iconData,
  //                   size: 50,
  //                   color: Colors.lightBlueAccent,
  //                 ),
  //                 SizedBox(height: ScreenUtil().setSp(10)),
  //                 Text(dataPundi[0]['socialName'].toUpperCase(),
  //                     style: Theme.of(context).textTheme.headline2.copyWith(
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.w500,
  //                         color: Colors.white)),
  //                 SizedBox(height: 10),
  //                 Text(dataPundi[0]['socialDesc'],
  //                     style: Theme.of(context)
  //                         .textTheme
  //                         .bodyText2
  //                         .copyWith(fontSize: 14, color: Colors.white),
  //                     textAlign: TextAlign.center),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  @override
  onNetworkError() {}

  @override
  onFailProfile(Map data) {
    if (this.mounted) {
      print("ini device Id " + member.deviceId.toString());
      print("ini member id  " + member.mId.toString());
      homePresenter.logout(member.mId, member.deviceId);
    }
  }

  @override
  onSuccessProfile(Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        dataProfile = data['message'];
        prefs.setString("member", jsonEncode(dataProfile));
        print("ini data profile " + dataProfile.toString());

        if (prefs.containsKey("member")) {
          final user = prefs.getString("member");
          dataProfile = jsonDecode(user);
        }
      });
    }
  }

  @override
  onSuccessMemberCard(Map data) {
    if (this.mounted) {
      setState(() {
        dataCard = data['message'];

        card = Image.network(
          dataCard[0]['cardurl'].toString(),
          key: _keyCard,
          scale: 0.1,
          fit: BoxFit.contain,
          // placeholder: (context, i) {
          //   return Container();
          // },
        );

        if (dataCard != null) {
          final ImageStreamListener listener =
              ImageStreamListener((ImageInfo imageInfo, bool s) {
            WidgetsBinding.instance.addPostFrameCallback(_getSizes);
          });
          if (card != null) {
            card.image.resolve(new ImageConfiguration()).addListener(listener);
          }
        }
      });
    }
  }

  @override
  onFailMemberCard(Map data) {
    // TODO: implement onFailMemberCard
  }

  @override
  onSuccessHomeContent(Map data) async {
    box = await Hive.openBox("homeCache");
    if (this.mounted) {
      setState(() {
        dataNews = data['news'];
        dataOrganitation = data['organization'];
        // dataDonasi = data['donasi'];
        dataAgenda = data['agenda'];
        dataMember = data['newmember'];
        dataBanner = data['banner'];
        dataDirectory = data['directory'];
        dataKerjasama = data['kerjasama'];
        dataKabarduka = data['kabarduka'];
        dataLink = data['relatedlink'];
        dataJob = data['job'];
        // dataHerb = data['herb'];
        dataPhoto = data['photo'];
        dataVideo = data['video'];
        box.put("homeCache", jsonEncode(data));
        print("ini data home get api " + jsonEncode(data).toString());
      });
    }
  }

  onFailHomeContent(Map data) {}

  @override
  onFailUnreadNotification(Map data) {}

  @override
  onSuccessUnreadNotification(Map data) {
    if (this.mounted) {
      setState(() {
        unreadNotification = data['message'];
      });
    }
  }

  // @override
  // onSuccessPundi(Map data) {
  //   if (this.mounted) {
  //     setState(() {
  //       dataPundiBerkah = data['pundiberkah'];
  //       datapundiKasih = data['pundikasih'];
  //       dataPundiAmal = data['pundiamal'];
  //     });
  //   }
  // }

  @override
  onFailLogout(Map data) {}

  @override
  onSuccessLogout(Map data) async {
    if (this.mounted) {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      // final LoginResult facebookLogin = await FacebookAuth.instance.logOut();
      // var facebookLogin = new FacebookLogin();
      // facebookLogin.logOut();
      FacebookAuth.instance.logOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("IS_LOGIN", false);
      prefs.remove('member');
      await _auth.signOut();
      OneSignal.shared.deleteTags(["mId", "deviceId"]).then((value) {});
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MenuBar(currentPage: 0)),
        (Route<dynamic> predicate) => false,
      );
    }
  }

  @override
  onSuccessPopUp(Map data) {
    if (mounted) {
      setState(() {
        dataPopUp = data['message'];
      });
      SchedulerBinding.instance
          .addPostFrameCallback((_) => showPromo(dataPopUp));
    }
  }

  @override
  onFailPopUp(Map data) {
    // TODO: implement onFailPopUp
  }

  @override
  onFailOrganisasi(Map data) {
    if (this.mounted) {
      setState(() {
        _dataOrganisasi = data['errorMessage'];
      });
    }
  }

  @override
  onSuccessOrganisasi(Map data) {
    if (this.mounted) {
      setState(() {
        _dataOrganisasi = data['message'];
      });
    }
  }

  void _selectOrganisasi(value) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      // _dataOrganisasi = null;
      this._currentOrganisasi = value;
      print("current province select " + _currentOrganisasi);
    });
    _onFilterTap();
    homePresenter.getHomeContent(
        _currentOrganisasi != "0" && _currentOrganisasi != null
            ? _currentOrganisasi
            : "");
  }

  @override
  onSuccessCheckCompleteData(Map data) {
    // print(_member.mId.toString());
    print("COMPLETE DATA " + data['message'][0].toString());
    if (this.mounted) {
      setState(() {
        widget.dataComplete = data['message'];
      });
    }
  }

  @override
  onFailCheckCompleteData(Map data) {
    // menuBarPresenter.logout(_member.mId, _member.deviceId);
  }

  @override
  onFailSearchOrganisasi(Map data) {
    // TODO: implement onFailSearchOrganisasi
    throw UnimplementedError();
  }

  @override
  onSuccessSearchOrganisasi(Map data) {
    // TODO: implement onSuccessSearchOrganisasi
    throw UnimplementedError();
  }
}
