import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loadmore/loadmore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

Color mainColor = Color(0xffededed);
Color baseColor = Color(0xffEEEFF1);
TextStyle mainFont =
    GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w500);

class BaseFunction {
  void displaySnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(seconds: 3),
    ));
  }

  Widget displayLoadingScreen(BuildContext context,
      {Color color = Colors.white}) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  String indonesianText(LoadMoreStatus status) {
    String text;
    switch (status) {
      case LoadMoreStatus.fail:
        text = "Loading Gagal, Silakan coba lagi.";
        break;
      case LoadMoreStatus.idle:
        text = "Loading";
        break;
      case LoadMoreStatus.loading:
        text = "Loading, wait a moment";
        break;
      case LoadMoreStatus.nomore:
        text = "";
        break;
      default:
        text = "";
    }
    return text;
  }

  String convertToDate(int data, String formatDate) {
    initializeDateFormatting();
    final String result = DateFormat(formatDate, "id")
        .format(DateTime.fromMillisecondsSinceEpoch(data * 1000));
    return result;
  }

  void displayToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[700],
        textColor: Colors.white,
        fontSize: 14.0);
  }

  void displayToastLong(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[700],
        textColor: Colors.white,
        fontSize: 14.0);
  }

  sendWhatsApp(String phone, String message) async {
    String whatsAppPhone;
    String countryCode = "62";
    String url;
    if (phone.isNotEmpty) {
      if (phone.substring(0, 2) != countryCode) {
        whatsAppPhone = countryCode + phone.substring(1, phone.length);
      } else {
        whatsAppPhone = phone;
      }
      url =
          "whatsapp://send?phone=$whatsAppPhone&text=${Uri.encodeComponent(message)}";
    } else {
      url = "whatsapp://send?text=${Uri.encodeComponent(message)}";
    }
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      if (phone.isNotEmpty) {
        url =
            "https://wa.me/$whatsAppPhone/?text=${Uri.encodeComponent(message)}";
      } else {
        url = "https://wa.me/?text=${Uri.encodeComponent(message)}";
      }
      await launch(url, forceSafariVC: true);
    }
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      return;
    }
  }

  phoneCall(String number) async {
    // Android
    var uri = 'tel:$number';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      var uri = 'tel:$number';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  launchMail(String url) async {
    var uri = 'mailto:$url?subject=ICATI Member&body=Dear,%20...';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  DateTime timestampToDateTime(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return date;
  }

  String checkTodayYesterday(DateTime time, int timeStamp) {
    final now = DateTime.now();
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    if (now.day == time.day &&
        now.month == time.month &&
        now.year == time.year) {
      return 'Hari Ini';
    } else if (time.day == yesterday.day &&
        time.month == yesterday.month &&
        time.year == yesterday.year) {
      return 'Kemarin';
    } else {
      var date = BaseFunction().convertToDate(timeStamp, "EEEE, dd MMM yyyy");
      return date.toString();
    }
  }

  String checkTime(DateTime time, int timeStamp) {
    final now = DateTime.now();
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    if (now.day == time.day &&
        now.month == time.month &&
        now.year == time.year) {
      var hour = BaseFunction().convertToDate(timeStamp, "HH:mm");
      return hour.toString();
    } else if (time.day == yesterday.day &&
        time.month == yesterday.month &&
        time.year == yesterday.year) {
      return 'Kemarin';
    } else {
      var date = BaseFunction().convertToDate(timeStamp, "EEEE, dd MMM yyyy");
      return date.toString();
    }
  }

  String getInitialName(String name) {
    List initial = name.trim().split(" ");
    List data = [];
    for (int i = 0; i < initial.length; i++) {
      print("loop initial " + name);
      print(initial[i][0].toString());
      data.add(initial[i][0].toString());
    }
    return data.join("");
  }

  Color convertColor(String dColor) {
    String colorCode = dColor.toString().toUpperCase();
    String catColor = colorCode.replaceAll("#", "0xFF");
    Color color = Color(int.parse(catColor));
    return color;
  }

  String getUserColor(String name) {
    List initial = name.split(" ");
    String firstL = initial[0][0].toString();
    List names = [
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H",
      "I",
      "J",
      "K",
      "L",
      "M",
      "N",
      "O",
      "P",
      "Q",
      "R",
      "S",
      "T",
      "U",
      "V",
      "W",
      "X",
      "Y",
      "Z",
      "a",
      "b",
      "c",
      "d",
      "e",
      "f",
      "g",
      "h",
      "i",
      "j",
      "k",
      "l",
      "m",
      "n",
      "o",
      "p",
      "q",
      "r",
      "s",
      "t",
      "u",
      "v",
      "w",
      "x",
      "y",
      "z"
    ];
    List color = [
      "#337ab7",
      "#5cb85c",
      "#f0ad4e",
      "#5bc0de",
      "#d9534f",
      "#ba78c8",
      "#a94189",
      "#337ab7",
      "#5cb85c",
      "#f0ad4e",
      "#5bc0de",
      "#d9534f",
      "#ba78c8",
      "#a94189",
      "#337ab7",
      "#5cb85c",
      "#f0ad4e",
      "#5bc0de",
      "#d9534f",
      "#ba78c8",
      "#a94189",
      "#337ab7",
      "#5cb85c",
      "#f0ad4e",
      "#5bc0de",
      "#d9534f",
      "#ba78c8",
      "#a94189",
      "#f0ad4e",
      "#337ab7",
      "#5cb85c",
      "#f0ad4e",
      "#337ab7",
      "#5cb85c",
      "#f0ad4e",
      "#5bc0de",
      "#d9534f",
      "#ba78c8",
      "#a94189",
      "#337ab7",
      "#5cb85c",
      "#f0ad4e",
      "#5bc0de",
      "#d9534f",
      "#ba78c8",
      "#a94189",
      "#337ab7",
      "#5cb85c",
      "#f0ad4e",
      "#5bc0de",
      "#d9534f",
      "#ba78c8"
    ];
    int idxName = names.indexOf(firstL);
    String selectedColor = color.elementAt(idxName);
    return selectedColor;
  }
}
