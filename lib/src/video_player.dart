import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart' as lib;
import 'package:video_player/video_player.dart' as lib;

class VideoPlayer extends StatefulWidget {
  final String url;

  final double aspectRatio;
  final bool autoResize;
  final bool autoplay;
  final bool controls;
  final bool loop;

  VideoPlayer(
    this.url, {
    this.aspectRatio,
    this.autoResize = true,
    this.autoplay = false,
    this.controls = false,
    this.loop = false,
    Key key,
  })  : assert(url != null),
        assert(aspectRatio != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoPlayerState();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) =>
      "[VideoPlayer:url=$url,"
      "aspectRatio=${aspectRatio.toStringAsFixed(2)},"
      "autoResize=${autoResize ? 1 : 0},"
      "autoplay=${autoplay ? 1 : 0},"
      "controls=${controls ? 1 : 0},"
      "loop=${loop ? 1 : 0}"
      ']';
}

class _VideoPlayerState extends State<VideoPlayer> {
  _Controller _controller;

  @override
  void initState() {
    super.initState();
    _controller = _Controller(this);

    if (widget.autoResize == true) {
      _controller._autoResize(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => lib.Chewie(controller: _controller);
}

class _Controller extends lib.ChewieController {
  final VideoPlayer widget;

  double _aspectRatio;

  _Controller(_VideoPlayerState vps)
      : widget = vps.widget,
        super(
          autoInitialize: true,
          autoPlay: vps.widget.autoplay == true,
          looping: vps.widget.loop == true,
          showControls: vps.widget.controls == true,
          videoPlayerController:
              lib.VideoPlayerController.network(vps.widget.url),
        );

  @override
  double get aspectRatio => _aspectRatio ?? widget.aspectRatio;

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  void _autoResize(VoidCallback f) {
    VoidCallback listener;

    listener = () {
      if (_aspectRatio == null) {
        final vpv = videoPlayerController.value;
        if (!vpv.initialized) return;

        _aspectRatio = vpv.aspectRatio;
        f();
      }

      videoPlayerController.removeListener(listener);
    };

    videoPlayerController.addListener(listener);
  }
}
