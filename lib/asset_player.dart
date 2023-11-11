import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'video_player.dart';

class AssetPlayerWidget extends StatefulWidget {
  final String asset;

  AssetPlayerWidget({required this.asset});

  @override
  _AssetPlayerWidgetState createState() => _AssetPlayerWidgetState();
}

class _AssetPlayerWidgetState extends State<AssetPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.asset)
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(false)
      ..initialize().then((_) {
        _controller.setVolume(0);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayerWidget(controller: _controller);
  }
}
