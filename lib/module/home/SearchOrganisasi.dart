import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icati_app/module/home/pattern/HomePresenter.dart';
import 'package:icati_app/module/home/pattern/HomeView.dart';

class SearchOrganisasi extends StatefulWidget {
  String _currentOrganisasi;

  SearchOrganisasi(this._currentOrganisasi);

  @override
  _SearchOrganisasiState createState() => _SearchOrganisasiState();
}

class _SearchOrganisasiState extends State<SearchOrganisasi>
    implements HomeView {
  HomePresenter homePresenter = HomePresenter();
  TextEditingController search_cont = TextEditingController();
  List dataOrganisasi;
  bool isLoading = false;
  bool isSearch = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    homePresenter.attachView(this);
    homePresenter.getOrganisasiList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          autofocus: true,
          controller: search_cont,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Ketik nama organisasi ...',
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            suffixIcon: isSearch
                ? IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: onClear,
                  )
                : null,
          ),
          onChanged: onTextChanged,
        ),
      ),
      body: dataOrganisasi != null
          ? displaySearchOrganisasi()
          : !isLoading && errorMessage.isNotEmpty
              ? displayOrganisasiNotFound()
              : isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Container(),
    );
  }

  Widget displaySearchOrganisasi() {
    List organisasiSearch = [];
    return ListView.separated(
      itemCount: dataOrganisasi == null ? 0 : dataOrganisasi.length,
      separatorBuilder: (_, __) => Divider(height: 1.0, color: Colors.white),
      itemBuilder: (context, i) {
        return InkWell(
          onTap: () {
            organisasiSearch.add(dataOrganisasi[i]['organizationId']);
            organisasiSearch
                .add(dataOrganisasi[i]['organizationName'].toString());
            Navigator.pop(context, organisasiSearch);
          },
          child: Container(
            decoration: BoxDecoration(
                color: widget._currentOrganisasi ==
                        dataOrganisasi[i]['organizationId'].toString()
                    ? Colors.red[900]
                    : Colors.white,
                border: Border(
                    bottom: BorderSide(color: Theme.of(context).dividerColor))),
            padding: new EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                dataOrganisasi[i]['organizationName'],
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'expressway',
                                    color: widget._currentOrganisasi ==
                                            dataOrganisasi[i]['organizationId']
                                                .toString()
                                        ? Colors.white
                                        : Colors.black87),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget displayOrganisasiNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.users,
                    size: 48.0, color: Colors.black45),
              ),
              Icon(Icons.cancel, size: 24.0)
            ],
          ),
          Text(errorMessage, style: TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }

  void onTextChanged(String value) async {
    if (!mounted) return;
    setState(() {
      isSearch = true;
    });
    await Future.delayed(Duration(seconds: 1));
    if (value.isNotEmpty && value == search_cont.text) {
      setState(() {
        isLoading = true;
        dataOrganisasi = null;
      });
      await homePresenter.searchOrganisasiHome(value);
    }
    if (search_cont.text == null || search_cont.text.toString().isEmpty) {
      setState(() {
//        isLoading = true;
        dataOrganisasi = null;
      });
      await homePresenter.getOrganisasiList();
    }
    return;
  }

  void onClear() {
    WidgetsBinding.instance.addPostFrameCallback((_) => search_cont.clear());
    if (mounted) {
      setState(() {
        isSearch = false;
      });
    }
  }

  @override
  onSuccessSearchOrganisasi(Map data) {
    if (!mounted) return;
    setState(() {
      dataOrganisasi = data['message'];
      isLoading = false;
    });
    print("search sukses: " + data['message'].toString());
  }

  @override
  onFailSearchOrganisasi(Map data) {
    if (!mounted) return;
    setState(() {
      dataOrganisasi = null;
      errorMessage = data['errorMessage'].toString();
      isLoading = false;
    });
    print("search gagal");
  }

  @override
  onSuccessRegister(Map data) {}

  @override
  onFailRegister(Map data) {}

  @override
  onSuccessOrganisasi(Map data) {
    if (!mounted) return;
    setState(() {
      this.dataOrganisasi = data['message'];
      isLoading = false;
    });
    print("Organisasi sukses");
  }

  @override
  onFailOrganisasi(Map data) {
    if (!mounted) return;
    setState(() {
      this.dataOrganisasi = null;
      errorMessage = data['errorMessage'].toString();
      isLoading = false;
    });
    print("Organisasi gagal");
  }

  @override
  onNetworkError() {}

  @override
  onFailHomeContent(Map data) {
    // TODO: implement onFailHomeContent
    throw UnimplementedError();
  }

  @override
  onFailLogout(Map data) {
    // TODO: implement onFailLogout
    throw UnimplementedError();
  }

  @override
  onFailMemberCard(Map data) {
    // TODO: implement onFailMemberCard
    throw UnimplementedError();
  }

  @override
  onFailPopUp(Map data) {
    // TODO: implement onFailPopUp
    throw UnimplementedError();
  }

  @override
  onFailProfile(Map data) {
    // TODO: implement onFailProfile
    throw UnimplementedError();
  }

  @override
  onFailUnreadNotification(Map data) {
    // TODO: implement onFailUnreadNotification
    throw UnimplementedError();
  }

  @override
  onSuccessHomeContent(Map data) {
    // TODO: implement onSuccessHomeContent
    throw UnimplementedError();
  }

  @override
  onSuccessLogout(Map data) {
    // TODO: implement onSuccessLogout
    throw UnimplementedError();
  }

  @override
  onSuccessMemberCard(Map data) {
    // TODO: implement onSuccessMemberCard
    throw UnimplementedError();
  }

  @override
  onSuccessPopUp(Map data) {
    // TODO: implement onSuccessPopUp
    throw UnimplementedError();
  }

  @override
  onSuccessProfile(Map data) {
    // TODO: implement onSuccessProfile
    throw UnimplementedError();
  }

  @override
  onSuccessUnreadNotification(Map data) {
    // TODO: implement onSuccessUnreadNotification
    throw UnimplementedError();
  }

  @override
  onFailCheckCompleteData(Map data) {
    // TODO: implement onFailCheckCompleteData
    throw UnimplementedError();
  }

  @override
  onSuccessCheckCompleteData(Map data) {
    // TODO: implement onSuccessCheckCompleteData
    throw UnimplementedError();
  }
}
