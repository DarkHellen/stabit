import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class LectureListPage extends StatelessWidget {
  final String courseName;
  final List Videos;

  LectureListPage({required this.courseName, required this.Videos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Lectures for $courseName'), // Display the course name
      ),
      body: LectureList(
        courseName: courseName,
        Videos: Videos,
      ),
    );
  }
}

class LectureList extends StatelessWidget {
  final String courseName;
  final List Videos;

  LectureList({required this.courseName, required this.Videos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Videos.length,
      itemBuilder: (context, index) {
        final lecture = Videos[index];
        final lectureName =
            "Lecture ${index + 1}"; // You can customize this naming
        final dataSource = lecture; // Assuming 'dataSource' is the field name

        return ListTile(
          title: Text(lectureName),
          onTap: () {
            // Navigate to the video player page with the selected lecture's data
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Video_Player(
                  lecture: lectureName,
                  datasource: dataSource,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class VideoPlayerPage extends StatelessWidget {
  final String lectureName;
  final String dataSource;

  VideoPlayerPage({required this.lectureName, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    // Implement your video player page as needed using the provided lectureName and dataSource
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(lectureName),
      ),
      body: Center(
        child: Text('$dataSource'),
      ),
    );
  }
}

class Video_Player extends StatefulWidget {
  final String datasource;
  final String lecture;

  const Video_Player(
      {Key? key, required this.datasource, required this.lecture})
      : super(key: key);

  @override
  _Video2ImpState createState() => _Video2ImpState();
}

class _Video2ImpState extends State<Video_Player> {
  late VideoPlayerController _controller;
  bool isLandscape = false;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.network(Uri.parse(widget.datasource).toString())
          ..initialize().then((_) {
            setState(() {});
          });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller.addListener(() {
      if (_controller.value.isPlaying && !isLandscape) {
        // Check if the video is playing and not in landscape mode
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        isLandscape = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
              overlays: []);
          return Scaffold(
            body: Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
          );
        } else {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
              overlays: []);
        }

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: Text(widget.lecture),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
                      overlays: []);
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                  ]);
                  Navigator.pop(context);
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : Container(),
                  VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors:
                        const VideoProgressColors(playedColor: Colors.purple),
                    padding: const EdgeInsets.all(0.0),
                  ),
                  SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (_controller.value.isPlaying) {
                              // Rewind by 10 seconds (adjust the duration as needed)
                              Duration newPosition =
                                  _controller.value.position -
                                      const Duration(seconds: 10);
                              // Ensure the new position is not negative
                              if (newPosition.isNegative) {
                                newPosition = Duration.zero;
                              }
                              _controller.seekTo(newPosition);
                              _controller.play();
                            }
                          },
                          icon: const Icon(
                            Icons.skip_previous_sharp,
                          ),
                          color: Colors.pink,
                        ),
                        IconButton(
                          onPressed: () {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          },
                          icon: const Icon(Icons.play_arrow_sharp),
                          color: Colors.pink,
                        ),
                        IconButton(
                          onPressed: () {
                            if (_controller.value.isPlaying) {
                              // Forward by 10 seconds (adjust the duration as needed)
                              Duration newPosition =
                                  _controller.value.position +
                                      const Duration(seconds: 10);
                              // Ensure the new position is not negative
                              if (newPosition.isNegative) {
                                newPosition = Duration.zero;
                              }
                              _controller.seekTo(newPosition);
                              _controller.play();
                            }
                          },
                          icon: const Icon(Icons.skip_next_sharp),
                          color: Colors.pink,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.lecture,
                    style: const TextStyle(fontSize: 20, color: Colors.pink),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
