// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:icati_app/base/BaseData.dart';
// import 'package:icati_app/base/BaseFunction.dart';
// import 'package:icati_app/base/BaseView.dart';
// import 'package:icati_app/module/othermenu/contact_us/pattern/ContactUsPresenter.dart';
// import 'package:icati_app/module/othermenu/contact_us/pattern/ContactUsView.dart';
// import 'package:icati_app/module/othermenu/contact_us/pattern/ContactUsWidgets.dart';
//
// class ContactUs extends StatefulWidget {
//   @override
//   _ContactUsState createState() => _ContactUsState();
// }
//
// class _ContactUsState extends State<ContactUs>
//     with SingleTickerProviderStateMixin
//     implements ContactUsView {
//   final ScrollController _scrollController = ScrollController();
//   Completer<GoogleMapController> _controller = Completer();
//   ContactUsPresenter _contactUsPresenter;
//
//   final _formKey = new GlobalKey<FormState>();
//
//   TextEditingController _nameCont = TextEditingController();
//   TextEditingController _phoneCont = TextEditingController();
//   TextEditingController _emailCont = TextEditingController();
//   TextEditingController _messageCont = TextEditingController();
//
//   String _infoAddress = "", _infoPhone = "", _infoEmail = "";
//
//   List<Tab> _tabList = List();
//
//   BaseData _baseData = BaseData(isSaving: false);
//
//   TabController _tabController;
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _contactUsPresenter = ContactUsPresenter();
//     _contactUsPresenter.attachView(this);
//     _contactUsPresenter.getInfoContact();
//     _tabList.add(new Tab(
//       icon: Icon(FontAwesomeIcons.directions),
//       text: 'Alamat',
//     ));
//     _tabList.add(new Tab(
//       icon: Icon(FontAwesomeIcons.mobile),
//       text: 'Telepon',
//     ));
//     _tabList.add(new Tab(
//       icon: Icon(FontAwesomeIcons.envelope),
//       text: 'Email',
//     ));
//
//     _tabController = _tabController =
//         new TabController(vsync: this, length: _tabList.length);
//     _tabController.addListener(_handleTabSelection);
//     _tabController.addListener(_handleScrollTab);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         titleSpacing: 0,
//         backgroundColor: Color(0XFF38b5d7),
//         title: Text("HUBUNGI KAMI",
//             style: GoogleFonts.roboto(fontSize: 14, color: Colors.white)),
//         elevation: 0,
//       ),
//       body: _infoAddress.isNotEmpty ||
//               _infoEmail.isNotEmpty ||
//               _infoPhone.isNotEmpty
//           ? SingleChildScrollView(
//               physics: AlwaysScrollableScrollPhysics(),
//               controller: _scrollController,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 10),
//                     ContactUsWidgets().displayContactDesc(context),
//                     SizedBox(height: 20),
//                     ContactUsWidgets()
//                         .displayTabMenu(context, _tabController, _tabList),
//                     ContactUsWidgets().displayTabMenuContent(
//                         context,
//                         _tabController,
//                         _infoAddress,
//                         _controller,
//                         _nameCont,
//                         _phoneCont,
//                         _emailCont,
//                         _messageCont,
//                         _baseData.isSaving,
//                         send,
//                         _infoEmail,
//                         _formKey,
//                         _infoPhone)
//                   ],
//                 ),
//               ),
//             )
//           : BaseView().displayLoadingScreen(context, color: Colors.black),
//     );
//   }
//
//   void send() {
//     setState(() {
//       _baseData.isSaving = true;
//       FocusScope.of(context).requestFocus(FocusNode());
//     });
//     if (_formKey.currentState.validate()) {
//       _formKey.currentState.save();
//
//       _contactUsPresenter.sendContactInfo(
//           _nameCont.text, _phoneCont.text, _emailCont.text, _messageCont.text);
//     } else {
//       setState(() {
//         _baseData.isSaving = false;
//       });
//     }
//   }
//
//   _handleTabSelection() {
//     if (_tabController.indexIsChanging) {
//       setState(() {});
//     }
//   }
//
//   _handleScrollTab() {
//     print("ini tab index click " + _tabController.index.toString());
//     setState(() {
//       Future.delayed(Duration.zero, () {
//         _scrollController.animateTo(_scrollController.position.maxScrollExtent,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOutCubic);
//       });
//     });
//   }
//
//   @override
//   onFailInfoContact(Map data) {}
//
//   @override
//   onNetworkError() {
//     // TODO: implement onNetworkError
//     throw UnimplementedError();
//   }
//
//   @override
//   onSuccessInfoContact(Map data) {
//     if (this.mounted) {
//       setState(() {
//         if (data['address'].isNotEmpty) {
//           _infoAddress = data['address'][0]['contentDesc'];
//         }
//         if (data['contact'].isNotEmpty) {
//           String _hp = data['contact'][0]['socialValue'].toString();
//           _infoPhone = _hp.replaceAll(RegExp('-'), '');
//           _infoEmail = data['contact'][1]['socialValue'];
//         }
//       });
//     }
//   }
//
//   @override
//   onFailSendContact(Map data) {
//     if (this.mounted) {
//       BaseFunction().displayToastLong(data['errorMessage']);
//     }
//   }
//
//   @override
//   onSuccessSendContact(Map data) {
//     if (this.mounted) {
//       BaseFunction().displayToastLong(data['message']);
//       Navigator.pop(context);
//     }
//   }
// }
