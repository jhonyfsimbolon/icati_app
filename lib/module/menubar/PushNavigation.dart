import 'package:flutter/material.dart';
import 'package:icati_app/module/agenda/Agenda.dart';
import 'package:icati_app/module/agenda/AgendaDetail.dart';
import 'package:icati_app/module/directory/DirectoryCategory.dart';
import 'package:icati_app/module/directory/DirectoryDetail.dart';
import 'package:icati_app/module/donasi/Donasi.dart';
import 'package:icati_app/module/donasi/DonasiDetail.dart';
import 'package:icati_app/module/gallery/photo/GalleryPhoto.dart';
import 'package:icati_app/module/gallery/video/GalleryVideo.dart';
import 'package:icati_app/module/herbal/HerbalDetail.dart';
import 'package:icati_app/module/herbal/HerbalList.dart';
import 'package:icati_app/module/jobvacancy/JobDetail.dart';
import 'package:icati_app/module/kabarduka/KabarDuka.dart';
import 'package:icati_app/module/kabarduka/KabarDukaDetail.dart';
import 'package:icati_app/module/kerjasama/KerjaSama.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
import 'package:icati_app/module/news/News.dart';
import 'package:icati_app/module/news/NewsDetail.dart';
import 'package:icati_app/module/notification/Notification.dart';
import 'package:icati_app/module/relatedLink/RelatedLink.dart';

class PushNavigation {
  void pushNavigate(context, String page, String id, String mId) async {
    print(page);
    switch (page) {
      case "home":
        {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => MenuBar(currentPage: 0),
                settings: RouteSettings(name: "Home")),
            (Route<dynamic> predicate) => false,
          );
        }
        break;
      case "agenda":
        {
          if (id != "0") {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AgendaDetail(id: id)));
          } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => Agenda()));
          }
        }
        break;
      case "direktori":
        {
          if (id != "0") {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) => DirectoryDetail(id: id)),
            );
          } else {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => MenuBar(currentPage: 3),
              ),
              (Route<dynamic> predicate) => false,
            );
          }
        }
        break;
      case "foto":
        {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => GalleryPhoto()));
        }
        break;
      case "video":
        {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => GalleryVideo()));
        }
        break;
      case "kerjasama":
        {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => KerjaSama()));
        }
        break;
      // case "relatedlink":
      //   {
      //     Navigator.of(context).push(MaterialPageRoute(
      //         builder: (BuildContext context) => RelatedLink()));
      //   }
      //   break;
      // case "beritaduka":
      //   {
      //     Navigator.of(context).push(MaterialPageRoute(
      //         builder: (BuildContext context) => KabarDuka()));
      //   }
      //   break;
      case "relatedlink":
        {
          if (id != "0") {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      RelatedLink(idLinkTerkait: id)),
            );
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => RelatedLink()));
          }
        }
        break;
      case "berita":
        {
          if (id != "0") {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) => NewsDetail(id: id)),
            );
          } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => News()));
          }
        }
        break;
      case "beritaduka":
        {
          if (id != "0") {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) => KabarDukaDetail(
                        kabardukaId: id,
                        kabardukaNama: "",
                      )),
            );
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => KabarDuka()));
          }
        }
        break;
      case "notifikasi":
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NotificationMain()));
        }
        break;
      case "loker":
        {
          if (id != "0") {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) => JobDetail(id: id)),
            );
          } else {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => MenuBar(currentPage: 4),
              ),
              (Route<dynamic> predicate) => false,
            );
          }
        }
        break;
      case "herbal":
        {
          if (id != "0") {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      HerbalDetail(herbalId: id)),
            );
          } else {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => HerbalList()),
              (Route<dynamic> predicate) => false,
            );
          }
        }
        break;
      default:
        print("default switch case");
        break;
    }
    return;
  }
}
