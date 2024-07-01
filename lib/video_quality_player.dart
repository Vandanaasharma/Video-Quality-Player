import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VideoPlayerScreen(
        videoUrls: [
          'https://mangalmaydigital.com/rd_paid/2024/Feb/pc/02_kaise_karen_sukh_duhkh_ka_upayog.mp4',
          'https://mangalmaydigital.com/rd_paid/2024/Feb/480/02_kaise_karen_sukh_duhkh_ka_upayog.mp4'
        ],
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final List<String> videoUrls;

  const VideoPlayerScreen({Key? key, required this.videoUrls}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  int _selectedQualityIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrls[_selectedQualityIndex])
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.videoUrls.length,
                  (index) => ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedQualityIndex = index;
                    _controller = VideoPlayerController.network(widget.videoUrls[_selectedQualityIndex])
                      ..initialize().then((_) {
                        setState(() {});
                      });
                  });
                },
                child: Text(_getQualityText(index)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    return index == _selectedQualityIndex ? Colors.blue : Colors.grey;
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getQualityText(int index) {
    // You can implement your logic to determine the quality from the URL
    // For this example, let's just show index as quality
    return 'Quality ${index + 1}';
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
