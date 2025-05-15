import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MaterialApp(
    title: 'Sports Streaming',
    theme: ThemeData.dark(),
    home: StreamMenuPage(),
  ));
}

// -----------------------
// Página principal (menú)
// -----------------------
class StreamMenuPage extends StatelessWidget {
  final List<Map<String, String>> streams = [
    {
      'title': 'ESPN Premium',
      'url': 'https://8852.crackstreamslivehd.com/espn/index.m3u8?token=da157f12843ff01daeafc13e83e432da0c6a2fb3-1a-1747289614-1747257214&ip=191.156.233.21',
    },
    {
      'title': 'Win Sports+',
      'url': 'https://m1.merichunidya.com:999/hls/winsportsplus.m3u8?md5=mTiRAnOxwm3AI7y7Su8pvQ&expires=1746658184',
    },
    {
      'title': 'TNT Argentina',
      'url': 'https://m3.merichunidya.com:999/hls/captntarg.m3u8?md5=SDm5ZTfZvahfJ63lLnhzPg&expires=1746659610',
    },
    {
      'title': 'Gol Perú',
      'url': 'https://m1.merichunidya.com:999/hls/capgolperu.m3u8?md5=d5njHJebNPBwIH-ugZRTxg&expires=1746659670',
    },
    {
  'title': 'Fox Sports',
  'url': 'https://m4.merichunidya.com:999/hls/foxsports.m3u8?md5=abc123&expires=1746660000',
    },
    {
      'title': 'Big Buck Bunny',
      'url': 'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', // MP4 de prueba
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sports Streaming')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: streams.length,
        itemBuilder: (context, index) {
          final stream = streams[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
              child: Text(stream['title']!, style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPage(
                      title: stream['title']!,
                      videoUrl: stream['url']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// -----------------------
// Página del reproductor
// -----------------------
class VideoPage extends StatefulWidget {
  final String title;
  final String videoUrl;

  VideoPage({required this.title, required this.videoUrl});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;

  final Map<String, String> customHeaders = {
  'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.5672.126 Safari/537.36',
  'Accept': '*/*',
  'Accept-Language': 'en-US,en;q=0.9',
  'Referer': 'https://capo5play.com/',
};


  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
      httpHeaders: customHeaders,
    )
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
