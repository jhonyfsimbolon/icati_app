import 'dart:io';

class Job {
  String companyName;
  String dateTime;
  String dateTimeEnd;
  String title;
  String desc;
  String cpHp;
  String provinsiId;
  String penempatan;
  String bidang;
  String cpName;
  String cpEmail;
  File pic;
  int picLength;

  Job(
      {this.companyName,
      this.dateTime,
      this.dateTimeEnd,
      this.title,
      this.desc,
      this.cpHp,
      this.provinsiId,
      this.penempatan,
      this.bidang,
      this.cpName,
      this.cpEmail});

  // set provinsiId(String provinsiId) {}

  Map toAddJobMap() {
    var map = new Map<String, String>();
    map['companyname'] = companyName;
    map['datetime'] = dateTime;
    map['datetimeend'] = dateTimeEnd;
    map['title'] = title;
    map['desc'] = desc;
    map['cphp'] = cpHp;
    map['provinsiId'] = provinsiId;
    map['penempatan'] = penempatan;
    map['bidang'] = bidang;
    map['cpName'] = cpName;
    map['cpemail'] = cpEmail;
    return map;
  }
}
