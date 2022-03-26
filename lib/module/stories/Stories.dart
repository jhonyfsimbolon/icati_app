import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:icati_app/module/home/pattern/HomeWidgets.dart';
import 'package:icati_app/module/stories/SubStories.dart';
import 'package:icati_app/module/stories/pattern/StoryPresenter.dart';
import 'package:icati_app/module/stories/pattern/StoryView.dart';
import 'package:icati_app/module/stories/pattern/StoryWidgets.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class Stories extends StatefulWidget {
  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> implements StoriesView {
  final StoryController controller = StoryController();
  List dataMember;
  StoryPresenter storyPresenter;
  String text;

  @override
  void initState() {
    storyPresenter = new StoryPresenter();
    storyPresenter.attachView(this);
    // storyPresenter.getEvent("168");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Delicious Ghanaian Meals"),
        ),
        body: text == null
            ? Container()
            : ListView(
                children: [
                  Html(
                    shrinkWrap: true,
                    data: text,
                    style: {
                      "span": Style(
                          fontSize: FontSize.medium, fontFamily: 'Poppins'),
                      "div": Style(
                          fontSize: FontSize.medium, fontFamily: 'Poppins'),
                    },
                  ),
                ],
              ));
  }

  onSuccessMember(Map data) {
    if (this.mounted) {
      setState(() {
        dataMember = data['message'];
      });
      print("data member " + dataMember.toString());
    }
  }

  onFailMember(Map data) {}

  @override
  onSuccessEvent(Map data) {
    if (this.mounted) {
      setState(() {
        text = data['message'][0]['eventDesc'];
      });
    }
  }

  @override
  onFailEvent(Map data) {
    // TODO: implement onFailEvent
  }
}
