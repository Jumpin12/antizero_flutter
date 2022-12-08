import 'dart:async';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/screens/dashboard/dashboard.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController controller;

  @override
  void initState() {
    loadVideoPlayer();
    controller.play();
    super.initState();
  }

  loadVideoPlayer(){
    controller = VideoPlayerController.asset('assets/videos/jumpin_video.mp4');
    controller.addListener(() {
      setState(() {});
    });
    controller.initialize().then((value) => {
      controller.addListener(() {                       //custom Listner
        setState(() {
          if (!controller.value.isPlaying &&controller.value.isInitialized &&
              (controller.value.duration ==controller.value.position)) { //checking the duration and position every time
            //Video Completed//
            setState(() {
              gotoDashboard();
            });
          }
        });
      })
    });

  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     resizeToAvoidBottomInset: true,
     backgroundColor: bluelite,
      body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
          Container(
              height: 10,
              child: VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  colors:VideoProgressColors(
                    backgroundColor: Colors.lightBlueAccent,
                    playedColor: Colors.blue,
                    bufferedColor: Colors.grey,
                  )
              )
          ),
        ]
    )
    ));
  }

  void gotoDashboard() async {
    JumpInUser user = await getUser(context);
    if (user != null) {
      Navigator.of(context).push(PageTransition(
          child: DashBoardScreen(),
          type: PageTransitionType.fade));
    } else {
      showToast('Error in getting user');
    }
  }
}
