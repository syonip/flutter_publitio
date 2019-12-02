import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  final String url;

  const VideoPlayer({Key key, @required this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  ChewieController chewieCtrl;
  VideoPlayerController videoPlayerCtrl;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoPlayerCtrl = VideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = videoPlayerCtrl.initialize();
  }

  @override
  void dispose() {
    if (chewieCtrl != null) chewieCtrl.dispose();
    if (videoPlayerCtrl != null) videoPlayerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          ChewieController chewieCtrl;
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            chewieCtrl = ChewieController(
              videoPlayerController: videoPlayerCtrl,
              autoPlay: true,
              looping:
                  false, // TODO: why does the loop reload the video every time?
              aspectRatio: videoPlayerCtrl.value?.aspectRatio,
              autoInitialize: true,
              // placeholder: Center(
              //   child: Image.network(widget.video.coverImageUrl),
              // ),
            );
          }

          return Stack(
            children: <Widget>[
              //   AspectRatio(
              // aspectRatio: videoPlayerCtrl.value?.aspectRatio,
              // child:

              chewieCtrl == null
                  ? Center(child: CircularProgressIndicator())
                  : Chewie(
                      controller: chewieCtrl,
                    ),
              // ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
