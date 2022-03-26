import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseFunction.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/directory/DirectoryDetail.dart';
import 'package:icati_app/module/directory/pattern/DirectoryPresenter.dart';
import 'package:icati_app/module/directory/pattern/DirectoryView.dart';

class DirectorySearch extends StatefulWidget {
  DirectorySearch({this.keyword});
  final String keyword;

  @override
  _DirectorySearchState createState() => _DirectorySearchState();
}

class _DirectorySearchState extends State<DirectorySearch>
    implements DirectoryView {
  DirectoryPresenter directoryPresenter;
  TextEditingController keyword = TextEditingController();
  List dataDirectory;
  BaseData baseData = BaseData();

  @override
  void initState() {
    super.initState();
    directoryPresenter = new DirectoryPresenter();
    directoryPresenter.attachView(this);
    baseData.isSearch = false;
    baseData.isLoading = false;
    baseData.isFailed = false;
    baseData.errorMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    TextStyle appBarTextStyle =
        TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: "roboto");
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          child: Container(
            margin: EdgeInsets.only(top: 10, left: 5, right: 5),
            child: AppBar(
              foregroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.white,
              title: Text("Direktori Bisnis 企业名录", style: appBarTextStyle),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autofocus: true,
                    controller: keyword,
                    decoration: InputDecoration(
                      fillColor: Color(0xffF1F1F1),
                      filled: true,
                      hintText: 'Ketik di sini',
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.0,
                          fontFamily: "roboto"),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: baseData.isSearch
                          ? IconButton(
                              icon: Icon(Icons.cancel, color: Colors.grey),
                              onPressed: onClear,
                            )
                          : null,
                    ),
                    onChanged: onTextChanged,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: dataDirectory != null
            ? displaySearchMerchant()
            : baseData.isLoading
                ? BaseView()
                    .displayLoadingScreen(context, color: Colors.black87)
                : baseData.isFailed
                    ? displayMerchantNotFound()
                    : displaySearchPic());
  }

  Widget displayMerchantNotFound() {
    return Center(
      child: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.not_interested_rounded,
                    color: Colors.grey, size: 100),
              ),
              Text(
                baseData.errorMessage,
                style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              ),
              SizedBox(height: 60)
            ],
          ),
        ),
      ),
    );
  }

  Widget displaySearchPic() {
    return Center(
      child: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Icon(Icons.search_outlined, color: Colors.grey, size: 100),
              ),
              Text(
                "Silakan masukan kata pencarian",
                style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              ),
              SizedBox(height: 60)
            ],
          ),
        ),
      ),
    );
  }

  Widget displaySearchMerchant() {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: dataDirectory == null ? 0 : dataDirectory.length,
        itemBuilder: (context, i) {
          return new Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.all(5.0),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DirectoryDetail(
                        id: dataDirectory[i]["merchantId"].toString()),
                    settings: RouteSettings(name: "Direktori Detail"),
                  ));
                },
                child: new Container(
                  padding: new EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: [
                          FittedBox(
                            child: Container(
                              width: 100, //500,
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: dataDirectory[i]["merchantPic"]
                                      .toString(),
                                  placeholder: (context, i) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                          "assets/images/logo_ts_red.png"),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          dataDirectory[i]['merchantDiscount'].toString() == ""
                              ? Container()
                              : Positioned(
                                  top: 0,
                                  right: 0,
                                  child: dataDirectory[i]['merchantDiscount']
                                              .toString() !=
                                          "0"
                                      ? Stack(
                                          children: <Widget>[
                                            new Container(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              decoration: new BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          20.0),
                                                  color:
                                                      Colors.deepOrange[400]),
                                              child: Text(
                                                "Disc " +
                                                    dataDirectory[i]
                                                        ['merchantDiscount'] +
                                                    "%",
                                                //textAlign: TextAlign.justify,
                                                style: GoogleFonts.roboto(
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 10.0),
                              child: Text(
                                dataDirectory[i]["merchantName"].toString(),
                                style: GoogleFonts.roboto(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              margin: EdgeInsets.only(left: 10.0),
                              padding: EdgeInsets.all(2),
                              child: Text(
                                dataDirectory[i]["merchantAddress"].toString(),
                                style: GoogleFonts.roboto(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10.0),
                              padding: EdgeInsets.all(2),
                              child: Text(
                                dataDirectory[i]["merchantHp"].toString(),
                                style: GoogleFonts.roboto(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10.0),
                              padding: EdgeInsets.all(2),
                              child: Text(
                                dataDirectory[i]["merchantOperational"]
                                    .toString(),
                                style: GoogleFonts.roboto(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void onTextChanged(String value) async {
    if (mounted) {
      setState(() {
        baseData.isSearch = true;
      });
      await Future.delayed(Duration(seconds: 1));
      if (value.length > 2 && value.isNotEmpty && value == keyword.text) {
        setState(() {
          baseData.isLoading = true;
          dataDirectory = null;
        });
        await directoryPresenter.getDirectorySearch(keyword.text);
      }
      return;
    }
  }

  Future<Null> onRefresh() async {
    if (this.mounted) {
      setState(() {
        dataDirectory = null;
      });
    }
  }

  void onClear() {
    WidgetsBinding.instance.addPostFrameCallback((_) => keyword.clear());
    if (mounted) {
      setState(() {
        baseData.isSearch = false;
      });
    }
  }

  @override
  onNetworkError() {
    if (this.mounted) {
      setState(() {
        baseData.isSearch = false;
        baseData.isLoading = false;
      });
      BaseFunction()
          .displayToastLong("Conneection Failed, Please try again later");
    }
  }

  @override
  onSuccessDirectorySearch(Map data) {
    if (this.mounted) {
      setState(() {
        dataDirectory = data['message'];
        baseData.isSearch = false;
        baseData.isLoading = false;
        baseData.isFailed = false;
      });
    }
  }

  @override
  onFailDirectorySearch(Map data) {
    if (this.mounted) {
      setState(() {
        baseData.errorMessage = data['errorMessage'];
        baseData.isSearch = false;
        baseData.isLoading = false;
        baseData.isFailed = true;
      });
    }
  }

  @override
  onSuccessDirectoryCategory(Map data) {
    // TODO: implement onSuccessDirectoryCategory
  }

  @override
  onFailDirectoryCategory(Map data) {
    // TODO: implement onFailDirectoryCategory
  }

  @override
  onSuccessDirectoryDetail(Map data) {
    // TODO: implement onSuccessDirectoryDetail
  }

  @override
  onFailDirectoryDetail(Map data) {
    // TODO: implement onFailDirectoryDetail
  }

  @override
  onSuccessDirectorySubCat(Map data, String page, int tapIndex) {}

  @override
  onFailDirectorySubCat(Map data, String page, int tapIndex) {}

  @override
  onFailCity(Map data) {
    // TODO: implement onFailCity
    throw UnimplementedError();
  }

  @override
  onSuccessCity(Map data) {
    // TODO: implement onSuccessCity
    throw UnimplementedError();
  }

  @override
  onFailProvince(Map data) {
    // TODO: implement onFailProvince
    throw UnimplementedError();
  }

  @override
  onSuccessProvince(Map data) {
    // TODO: implement onSuccessProvince
    throw UnimplementedError();
  }
}
