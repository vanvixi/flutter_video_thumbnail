import 'package:flutter/services.dart';
import 'package:flutter_video_thumbnail_android/src/messages.g.dart';
import 'package:flutter_video_thumbnail_platform_interface/flutter_video_thumbnail_platform_interface.dart';

const String eventChannelName = 'vanvixi/flutter_video_thumbnail';

class AndroidVideoThumbnail extends FlutterVideoThumbnailPlatform {
  final VideoThumbnailApi _api = VideoThumbnailApi();
  final EventChannel _eventChannel = const EventChannel(eventChannelName);

  /// Registers this class as the default instance of [PathProviderPlatform].
  static void registerWith() {
    FlutterVideoThumbnailPlatform.instance = AndroidVideoThumbnail();
  }

  @override
  Future<void> dispose() => _api.dispose();

  @override
  Future<Uint8List?> getThumbnailData({
    required String videoPath,
    required int timeMs,
    int width = 0,
    int height = 0,
    required int quality,
    required ImageFormat thumbnailFormat,
    Map<String, String>? headers,
  }) async {
    assert(timeMs >= 0 && width >= 0 && height >= 0, "timeMs, width, height must be greater than 0");

    final msg = await _api.getThumbnailDataAsync(GetThumbnailDataMessage(
      videoPath: videoPath,
      timeMs: timeMs,
      width: width,
      height: height,
      quantity: 1,
      quality: quality,
      formatIndex: thumbnailFormat.index,
      headers: headers ?? {},
    ));

    return msg.thumbnailData;
  }

  @override
  void getThumbnailDataStream({
    required String videoPath,
    int? videoDurationMs,
    int width = 0,
    int height = 0,
    required int quantity,
    required int quality,
    required ImageFormat thumbnailFormat,
    Map<String, String>? headers,
    String? receiveId,
  }) {
    assert(quantity >= 0 && width >= 0 && height >= 0, "timeMs, width, height must be greater than 0");

    _api.getThumbnailData(GetThumbnailDataMessage(
      videoPath: videoPath,
      videoDurationMs: videoDurationMs,
      width: width,
      height: height,
      quantity: quantity,
      quality: quality,
      formatIndex: thumbnailFormat.index,
      headers: headers ?? {},
      receiveId: receiveId,
    ));
  }

  @override
  Stream<VideoThumbnailResponseEvent> videoThumbnailResponses() {
    return _eventChannel.receiveBroadcastStream().map((event) {
      final Map<dynamic, dynamic> map = event as Map<dynamic, dynamic>;
      switch (map['event']) {
        case 'thumbnailDataResponse':
          return VideoThumbnailResponseEvent(
            eventType: VideoThumbnailEventType.thumbnailDataResponse,
            thumbnailData: map['value'] as Uint8List,
            receiveId: map['receiveId'] as String?,
          );

        default:
          return const VideoThumbnailResponseEvent(eventType: VideoThumbnailEventType.unknown);
      }
    });
  }
}
