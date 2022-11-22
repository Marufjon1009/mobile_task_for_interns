import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoService {
  late final VideoPlayerController? videoPlayerController;

  static final _intence = VideoService._init();
  late final ChewieController? _chewie;

  VideoService._init() {
    videoPlayerController = VideoPlayerController.network(
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true));

    initialize();
    assert(videoPlayerController != null);
    _chewie = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: true,
        looping: true);
    log('Video Player INITED');
  }
  factory VideoService() => _intence;

  void initialize() async {
    try {
      await videoPlayerController!.initialize();
    } catch (e) {
      log(e.toString());
    }
  }

  ChewieController get chewie => _chewie!;

  void dispose() {
    videoPlayerController!.dispose();
    _chewie!.dispose();
  }
}
