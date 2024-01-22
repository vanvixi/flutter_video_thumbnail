import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/messages.g.dart',
    // dartTestOut: 'test/test_api.g.dart',
    swiftOut: 'darwin/Classes/Messages.swift',
    swiftOptions: SwiftOptions(),
    copyrightHeader: 'pigeons/copyright.txt',
  ),
)
class GetThumbnailDataMessage {
  GetThumbnailDataMessage({
    required this.videoPath,
    this.videoDurationMs,
    this.timeMs = 0,
    this.width = 0,
    this.height = 0,
    required this.quality,
    required this.quantity,
    required this.formatIndex,
    required this.headers,
    this.receiveId,
  });

  String videoPath;
  int? videoDurationMs;
  int timeMs;
  int width;
  int height;
  int quality;
  int quantity;

  // Index of ImageFormat
  int formatIndex;
  Map<String?, String?> headers;

  String? receiveId;
}

class ThumbnailMessage {
  ThumbnailMessage(this.thumbnailData);

  Uint8List? thumbnailData;
}

@HostApi(dartHostTestHandler: 'TestHostFlutterVideoThumbnailApi')
abstract class VideoThumbnailApi {
  void dispose();

  ThumbnailMessage getThumbnailDataAsync(GetThumbnailDataMessage msg);

  void getThumbnailData(GetThumbnailDataMessage msg);
}
