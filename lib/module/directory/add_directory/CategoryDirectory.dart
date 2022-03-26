import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icati_app/base/BaseData.dart';
import 'package:icati_app/base/BaseView.dart';
import 'package:icati_app/module/directory/add_directory/pattern/AddDirectoryPresenter.dart';

class CategoryDirectory extends StatefulWidget {
  List dataCat;
  var selectedCat;
  CategoryDirectory({@required this.dataCat, this.selectedCat});
  @override
  _CategoryDirectoryState createState() => _CategoryDirectoryState();
}

class _CategoryDirectoryState extends State<CategoryDirectory> {
  AddDirectoryPresenter addDirectoryPresenter;
  BaseData baseData = BaseData();
  var selectedCat = [];

  @override
  void initState() {
    this.selectedCat = widget.selectedCat;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Color(0XFF38b5d7),
        title: Text("Kategori Direktori (目录类别)",
            style: GoogleFonts.roboto(fontSize: 14, color: Colors.white)),
        elevation: 0,
      ),
      body: displayCategoryList(),
      bottomNavigationBar: Row(
        children: [
          SizedBox(width: 8),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 6),
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context, selectedCat);
                  print("POP " + jsonEncode(selectedCat));
                },
                padding: const EdgeInsets.all(16.0),
                color: Color(0XFF38b5d7),
                child: Text("Simpan (保存)", style: TextStyle(color: Colors.white)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  Future<Null> onRefresh() async {}

  void selectCategory(Map dataCat) {
    if (this.mounted) {
      setState(() {
        if (selectedCat.contains(dataCat)) {
          print("remove " + selectedCat.toString());
          selectedCat.removeWhere((element) => element == dataCat);
        } else {
          print("add " + selectedCat.toString());
          selectedCat.add(dataCat);
        }
      });
    }
  }

  Widget displayCategoryList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.builder(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: widget.dataCat != null ? widget.dataCat.length : 0,
          itemBuilder: (context, i) {
            return InkWell(
              onTap: () {
                print("selecting cat (选择类别)");
                selectCategory(widget.dataCat[i]);
              },
              child: Card(
                child: Container(
                  padding: EdgeInsets.only(top: 4, bottom: 4, right: 4),
                  decoration: BoxDecoration(
                    color: selectedCat.contains(widget.dataCat[i])
                        ? Colors.green[50]
                        : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: widget.dataCat[i]['mCatParentId'] == 0 ? 0 : 20),
                    child: Row(
                      children: [
                        widget.dataCat[i]['mCatParentId'] != 0 ?
                        Checkbox(
                          value: selectedCat.contains(widget.dataCat[i])
                              ? true
                              : false,
                          onChanged: (bool) {
                            selectCategory(widget.dataCat[i]);
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ):Text(""),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.dataCat[i]['mCatName'],
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight:
                                    widget.dataCat[i]['mCatParentId'] == 0
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
