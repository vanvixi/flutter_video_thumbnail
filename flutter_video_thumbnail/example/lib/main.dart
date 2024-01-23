import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_thumbnail/flutter_video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Flutter Video Thumbnail Example',
    home: VideoPickerScreen(),
  ));
}

class VideoPickerScreen extends StatefulWidget {
  const VideoPickerScreen({super.key});

  @override
  State<VideoPickerScreen> createState() => _VideoPickerScreenState();
}

class _VideoPickerScreenState extends State<VideoPickerScreen> {
  final ImagePicker _picker = ImagePicker();

  void _pickVideo() async {
    final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);

    if (file == null || !mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => VideoThumbnailScreen(file: File(file.path)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Picker")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Click on the button to select video"),
            ElevatedButton(
              onPressed: _pickVideo,
              child: const Text("Pick Video From Gallery"),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoThumbnailScreen extends StatefulWidget {
  const VideoThumbnailScreen({required this.file, super.key});

  final File file;

  @override
  State<VideoThumbnailScreen> createState() => _VideoThumbnailScreenState();
}

class _VideoThumbnailScreenState extends State<VideoThumbnailScreen> {
  static const String receiveId = 'FlutterVideoThumbnailID';
  final FlutterVideoThumbnail _videoThumbnail = FlutterVideoThumbnail();
  final List<Uint8List> _thumbnailData = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _videoThumbnail.getThumbnailDataStream(
        videoPath: widget.file.path,
        quantity: 24,
        quality: 10,
        thumbnailFormat: ImageFormat.WEBP_LOSSLESS,
        receiveId: receiveId,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _videoThumbnail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Video Thumbnail")),
      body: StreamBuilder<VideoThumbnailResponseEvent>(
        stream: _videoThumbnail.videoThumbnailResponses(),
        builder: (context, snapshot) {
          final data = snapshot.data;

          if (data == null) return const Center(child: CircularProgressIndicator());

          if (data.thumbnailData == null || data.receiveId != receiveId) {
            return const SizedBox.shrink();
          }

          _thumbnailData.add(data.thumbnailData!);

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, index) {
              try {
                final thumbnail = _thumbnailData[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => ThumbnailDetailScreen(
                          index: index,
                          data: thumbnail,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Hero(
                        tag: 'thumbnail + $index',
                        child: Image.memory(thumbnail, height: 100),
                      ),
                    ),
                  ),
                );
              } catch (e) {
                return const SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}

class ThumbnailDetailScreen extends StatelessWidget {
  const ThumbnailDetailScreen({
    required this.index,
    required this.data,
    super.key,
  });

  final int index;
  final Uint8List data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thumbnail Detail")),
      body: Hero(
        tag: 'thumbnail + $index',
        child: Center(child: Image.memory(data)),
      ),
    );
  }
}
