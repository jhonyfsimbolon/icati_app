import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icati_app/module/agenda/Agenda.dart';
import 'package:icati_app/module/gallery/photo/GalleryPhoto.dart';
import 'package:icati_app/module/gallery/video/GalleryVideo.dart';
import 'package:icati_app/module/jobvacancy/JobList.dart';
import 'package:icati_app/module/kabarduka/KabarDuka.dart';
import 'package:icati_app/module/kerjasama/KerjaSama.dart';
import 'package:icati_app/module/menubar/MenuBar.dart';
import 'package:icati_app/module/menubar/listMenu.dart';
import 'package:icati_app/module/news/News.dart';
import 'package:icati_app/module/organisasi/Organisasi.dart';
import 'package:icati_app/module/othermenu/about_us/AboutUs.dart';
import 'package:icati_app/module/othermenu/contact_us/Contact_Us.dart';
import 'package:icati_app/module/relatedLink/RelatedLink.dart';

class MenuBurger extends StatefulWidget {
  const MenuBurger({Key key}) : super(key: key);

  @override
  _MenuBurgerState createState() => _MenuBurgerState();
}

class _MenuBurgerState extends State<MenuBurger> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo_icati.png')
                      // DecorationImage(image: AssetImage('assets/images/splah.jpg')
                      ),
                ),
              ),
              // Image.asset('assets/image/logo_icati.png'),
              SizedBox(
                width: 10,
              ),
              Text("ICATI",
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: Colors.white, fontSize: 20)),
            ],
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Color.fromRGBO(159, 28, 42, 1),
                  Color.fromRGBO(159, 27, 40, 1),
                ])),
          )),
      body: ListView(
        children: <Widget>[
          ListMenu(
              title: "Tentang ICATI 关于 ICATI",
              imageIcon: "assets/images/logo_icati.png",
              icon: FontAwesomeIcons.home,
              navigateTo: AboutUs()),
          ListMenu(
              title: "Organisasi 组织",
              icon: FontAwesomeIcons.users,
              navigateTo: Organisasi()),
          ListMenu(
              title: "Berita 消息",
              icon: FontAwesomeIcons.newspaper,
              navigateTo: News()),
          ListMenu(
              title: "Agenda Kegiatan 活动议程",
              icon: FontAwesomeIcons.calendar,
              navigateTo: Agenda()),
          // ListMenu(
          //   title: "Bantuan Sosial 社会救助",
          //   icon: FontAwesomeIcons.handshake,
          //   navigateTo: () {},
          // ),
          // ListMenu(
          //   title: "E-Magazine",
          //   icon: FontAwesomeIcons.bookOpen,
          //   // navigateTo: '/ListMagazine',
          // ),
          ListMenu(
            title: "Berita Duka 讣告",
            icon: Icons.assignment_ind,
            navigateTo: KabarDuka(),
          ),
          ListMenu(
            title: "Galeri Foto 照片库",
            icon: Icons.image,
            navigateTo: GalleryPhoto(),
          ),
          ListMenu(
            title: "Galeri Video 视频库",
            icon: Icons.videocam,
            navigateTo: GalleryVideo(),
          ),
          ListMenu(
              title: "Lowongan Kerja 职位空缺",
              icon: Icons.work,
              navigateTo: JobList()),
          ListMenu(
            title: "Kerja Sama 关系",
            icon: FontAwesomeIcons.userTie,
            navigateTo: KerjaSama(),
          ),
          // ListMenu(
          //   title: "Sponsorship 赞助",
          //   icon: FontAwesomeIcons.donate,
          //   navigateTo: () {},
          // ),
          ListMenu(
            title: "Link Terkait 连接的链接",
            icon: FontAwesomeIcons.link,
            navigateTo: RelatedLink(),
            // navigateTo: '/RelatedLinkMain',
          ),
          ListMenu(
            title: "Hubungi Kami 联系我们",
            icon: Icons.info,
            navigateTo: ContactUs(),
          ),
        ],
      ),
    );
  }
}
