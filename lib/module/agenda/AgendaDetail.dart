import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/model/Member.dart';
import 'package:icati_app/module/agenda/pattern/AgendaPresenter.dart';
import 'package:icati_app/module/agenda/pattern/AgendaView.dart';
import 'package:icati_app/module/agenda/pattern/AgendaWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgendaDetail extends StatefulWidget {
  AgendaDetail({this.id});

  final String id;

  @override
  _AgendaDetailState createState() => _AgendaDetailState();
}

class _AgendaDetailState extends State<AgendaDetail> implements AgendaView {
  AgendaPresenter agendaPresenter;
  List dataAgenda;
  BaseData baseData = BaseData();
  Member member = Member();
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    agendaPresenter = new AgendaPresenter();
    agendaPresenter.attachView(this);
    baseData.isFailed = false;
    baseData.isSaving = false;
    baseData.autoValidate = false;
    baseData.errorMessage = "";
    baseData.lat = "";
    baseData.long = "";
    agendaPresenter.getAgendaDetail(widget.id);
    getCredential();
    super.initState();
  }

  getCredential() async {
    if (!mounted) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      baseData.isLogin =
          prefs.containsKey("IS_LOGIN") ? prefs.getBool("IS_LOGIN") : false;
      if (baseData.isLogin) {
        final user = prefs.getString("member");
        final List data = jsonDecode(user);
        member.mId = data[0]['mId'].toString();
        member.mName = data[0]['mName'].toString();
        member.mEmail = data[0]['mEmail'].toString();
      }
    });
    await getCurrentLocation();
  }

  getCurrentLocation() async {
    var loc = await new Location().getLocation();
    setState(() {
      baseData.lat = loc.latitude.toString();
      baseData.long = loc.longitude.toString();
    });
  }

  Future<Null> onRefresh() async {
    setState(() {
      dataAgenda = null;
    });
    agendaPresenter.getAgendaDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle appBarTextStyle =
        TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: "roboto");
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: -10,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          title: Text("Agenda Kegiatan 活动议程", style: appBarTextStyle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: dataAgenda == null || baseData.lat == "" || baseData.long == ""
            ? baseData.isFailed
                ? BaseView().displayErrorMessage(
                    context, onRefresh, baseData.errorMessage)
                : BaseView()
                    .displayLoadingScreen(context, color: Colors.blueAccent)
            : agendaDetail());
  }

  Widget agendaDetail() {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        child: Column(
          children: [
            AgendaWidgets().displayBoxPic(
                context, dataAgenda[0]['akPic'], dataAgenda[0]['akPicCaption']),
            AgendaWidgets().displayBoxDate(
                context,
                dataAgenda[0]['akTitle'],
                dataAgenda[0]['akAddedOn'],
                dataAgenda[0]['akPlace'],
                dataAgenda[0]['provinsiName'],
                dataAgenda[0]['akDate'],
                dataAgenda[0]['akHideTime']),
            AgendaWidgets().displayBoxInfo(context, dataAgenda[0]['akDesc']),
            AgendaWidgets().displayMaps(
                context,
                double.parse(baseData.lat),
                double.parse(baseData.long),
                _controller,
                dataAgenda[0]['akId'],
                dataAgenda[0]['akCoordinateLat'],
                dataAgenda[0]['akCoordinateLong']),
          ],
        ),
      ),
    );
  }

  @override
  onNetworkError() {
    BaseFunction()
        .displayToastLong("Connection failed, please try again later");
    Navigator.of(context).pop();
  }

  @override
  onSuccessAgendaDetail(Map data) {
    if (this.mounted) {
      setState(() {
        dataAgenda = data['message'];
        baseData.isFailed = false;
      });
    }
  }

  @override
  onFailAgendaDetail(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.isFailed = true;
      });
      BaseFunction().displayToastLong(data['errorMessage']);
    }
  }

  @override
  onSuccessAgendaList(Map data) {
    // TODO: implement onSuccessAgendaList
  }

  @override
  onFailAgendaList(Map data) {
    // TODO: implement onFailAgendaList
  }

  @override
  onSuccessAgendaListMore(Map data, int tabIndex) {
    // TODO: implement onSuccessAgendaListMore
  }

  @override
  onFailAgendaListMore(Map data, int tabIndex) {
    // TODO: implement onFailAgendaListMore
  }
}
