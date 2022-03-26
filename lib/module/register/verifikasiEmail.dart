import 'package:flutter/material.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';

class VerifikasiEmail extends StatefulWidget {
  const VerifikasiEmail({key, this.dataLink, this.isLogin}) : super(key: key);

  final List dataLink;
  final bool isLogin;

  @override
  _VerifikasiEmailState createState() => _VerifikasiEmailState();
}

class _VerifikasiEmailState extends State<VerifikasiEmail> {
  bool isFailed = true;

  bool isLoading = true;
  //  isFailed = true;

  String _mId, codeEmail;

  String messageFailed = "Link verifikasi salah atau sudah kadaluarsa";

  String messageSuccess = "Verifikasi Email Berhasil";

  @override
  Widget build(BuildContext context) {
    TextStyle appBarTextStyle = TextStyle(fontSize: 18.0, color: Colors.white);
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorDark,
          title: Text(
            "Verifikasi Email",
            style: appBarTextStyle,
          ),
        ),
        body:
            // !isLoading ?
            Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Icon(
                  //   // isFailed ? Icons.warning : Icons.check_circle,
                  //   isFailed ? Icons.warning : Icons.check_circle,
                  //   color: isFailed ? Colors.orange : Colors.greenAccent,
                  //   size: 100,
                  // ),
                  SizedBox(height: 8.0),
                  Text(
                      // isFailed ? messageFailed : messageSuccess,
                      messageFailed,
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8.0),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacement(new MaterialPageRoute(
                        builder: (context) => MenuBar(currentPage: 0),
                      ));
                    },
                    color: Theme.of(context).primaryColorDark,
                    child: Text("KE HALAMAN UTAMA"),
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        )
        // : Center(child: CircularProgressIndicator()
        // )
        );
  }
}
