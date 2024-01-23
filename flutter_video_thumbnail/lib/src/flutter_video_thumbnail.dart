import 'package:flutter/foundation.dart';
import 'package:flutter_video_thumbnail_platform_interface/flutter_video_thumbnail_platform_interface.dart';

FlutterVideoThumbnailPlatform? _lastVideoThumbnailPlatform;

FlutterVideoThumbnailPlatform get _videoThumbnailPlatform {
  final FlutterVideoThumbnailPlatform currentInstance = FlutterVideoThumbnailPlatform.instance;
  if (_lastVideoThumbnailPlatform != currentInstance) {
    _lastVideoThumbnailPlatform = currentInstance;
  }
  return currentInstance;
}

class FlutterVideoThumbnail {
  void dispose() {
    _videoThumbnailPlatform.dispose();
  }

  Future<Uint8List?> getThumbnailData({
    required String videoPath,
    required int timeMs,
    int width = 0,
    int height = 0,
    required int quality,
    required ImageFormat thumbnailFormat,
    Map<String, String>? headers,
  }) async {
    return await _videoThumbnailPlatform.getThumbnailData(
      videoPath: videoPath,
      timeMs: timeMs,
      width: width,
      height: height,
      quality: quality,
      thumbnailFormat: thumbnailFormat,
      headers: headers,
    );
  }

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
    _videoThumbnailPlatform.getThumbnailDataStream(
      videoPath: videoPath,
      videoDurationMs: videoDurationMs,
      width: width,
      height: height,
      quantity: quantity,
      quality: quality,
      thumbnailFormat: thumbnailFormat,
      headers: headers,
      receiveId: receiveId,
    );
  }

  Stream<VideoThumbnailResponseEvent> videoThumbnailResponses() {
    return _videoThumbnailPlatform.videoThumbnailResponses();
  }
}
