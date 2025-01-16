import 'package:flutter/material.dart';
import 'package:rchapp_v2/sreens/authen/login.dart';
import 'package:video_player/video_player.dart';

class VideoSplashScreen extends StatefulWidget {
  const VideoSplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VideoSplashScreenState createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/Rch-2.mp4')
      ..initialize().then((_) {
        setState(() {}); // Refresh to show the first frame
        _controller.play(); // Start video playback
      })
      ..setLooping(false); // Stop looping
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        _navigateToNextScreen();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage(title: 'Rch Plus',)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_controller.value.isInitialized)
            VideoPlayer(_controller)
          else
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}


