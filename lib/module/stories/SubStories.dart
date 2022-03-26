import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icati_app/module/stories/Stories.dart';
import 'package:icati_app/module/stories/pattern/StoryView.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class SubStories extends StatefulWidget {
  List dataStory, dataMember;
  int index;
  SubStories({this.dataStory, this.dataMember, this.index});

  @override
  _SubStoriesState createState() => _SubStoriesState();
}

class _SubStoriesState extends State<SubStories> implements StoriesView {
  List<StoryItem> stories = [];

  final storyController = StoryController();

  @override
  void initState() {
    for (int i = 0; i < widget.dataStory.length; i++) {
      stories.add(
        StoryItem.pageImage(
          url: widget.dataStory[i],
          caption: "Still sampling",
          controller: storyController,
        ),
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Stories()),
          (Route<dynamic> predicate) => false,
        );
        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
          body: Stack(
        children: [
          StoryView(
            storyItems: stories,
            onStoryShow: (s) {
              print("Showing a story");
            },
            onComplete: () {
              print("Completed a cycle");
              print(widget.index);
              print(widget.dataMember.length);
              print(widget.index < widget.dataMember.length);
              if (widget.index < widget.dataMember.length - 1) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => SubStories(
                            dataMember: widget.dataMember,
                            dataStory: widget.dataMember[widget.index]['story'],
                            index: widget.index + 1,
                          )),
                  (Route<dynamic> predicate) => false,
                );
              } else {
                // Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Stories()),
                  (Route<dynamic> predicate) => false,
                );
              }
            },
            progressPosition: ProgressPosition.top,
            repeat: false,
            controller: storyController,
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.dataMember[widget.index]['pic'],
                  imageBuilder: (context, imageProvider) => Container(
                    width: ScreenUtil().setSp(30),
                    height: ScreenUtil().setSp(30),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, i) {
                    return Container(
                        height: ScreenUtil().setSp(30),
                        width: ScreenUtil().setSp(30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/images/logo_ts_red.png"),
                              fit: BoxFit.cover),
                        ));
                  },
                  errorWidget: (_, __, ___) {
                    return Container(
                        height: ScreenUtil().setSp(30),
                        width: ScreenUtil().setSp(30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/images/logo_ts_red.png"),
                              fit: BoxFit.cover),
                        ));
                  },
                ),
                Container(
                  width: ScreenUtil().setSp(80),
                  child: Padding(
                    padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                    child: Center(
                      child: Text(
                        widget.dataMember[widget.index]['mName'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }

  onSuccessMember(Map data) {}

  onFailMember(Map data) {}

  @override
  onSuccessEvent(Map data) {
    // TODO: implement onSuccessEvent
  }

  @override
  onFailEvent(Map data) {
    // TODO: implement onFailEvent
  }
}
