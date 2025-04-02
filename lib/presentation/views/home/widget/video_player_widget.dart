import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _showControls = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? GestureDetector(
            onTap: _toggleControls,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),

                // Play / Pause button
                if (_showControls)
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.4),
                    ),
                    child: IconButton(
                      iconSize: 60,
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.white,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                  ),

                // Volume button
                if (_showControls)
                  Positioned(
                    bottom: 36,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black45,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: _toggleMute,
                      ),
                    ),
                  ),

                // Progress bar
                if (_showControls)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        colors: VideoProgressColors(
                          playedColor: Colors.blueAccent,
                          bufferedColor: Colors.white38,
                          backgroundColor: Colors.black26,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
