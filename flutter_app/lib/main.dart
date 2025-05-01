import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String apiKey = 'TU_API_KEY';
  final String channelId = 'UC4R8DWoMoI7CAwX8_LjQHig';

  const MyApp({super.key}); 

  Future<String?> fetchLiveVideoId() async {
  final url =
      'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&eventType=live&type=video&key=$apiKey';

  final response = await http.get(Uri.parse(url));

  print('STATUS CODE: ${response.statusCode}');
  print('RESPONSE BODY: ${response.body}'); 

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['items'].isNotEmpty) {
      return data['items'][0]['id']['videoId'];
    }
  }
  return null;
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Live Viewer',
      home: Scaffold(
        appBar: AppBar(title: Text('Live Stream')),
        body: FutureBuilder<String?>(
          future: fetchLiveVideoId(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No hay transmisiones en vivo.'));
            }

            YoutubePlayerController controller = YoutubePlayerController(
              initialVideoId: snapshot.data!,
              flags: YoutubePlayerFlags(autoPlay: true, mute: false),
            );

            return YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: true,
            );
          },
        ),
      ),
    );
  }
}
