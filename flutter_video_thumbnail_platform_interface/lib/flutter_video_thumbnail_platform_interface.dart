import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _PlaceholderImplementation extends FlutterVideoThumbnailPlatform {}

abstract class FlutterVideoThumbnailPlatform extends PlatformInterface {
  /// Constructs a FlutterVideoThumbnailPlatform.
  FlutterVideoThumbnailPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterVideoThumbnailPlatform _instance = _PlaceholderImplementation();

  /// The default instance of [FlutterVideoThumbnailPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterVideoThumbnailPlatform].
  static FlutterVideoThumbnailPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterVideoThumbnailPlatform] when
  /// they register themselves.
  static set instance(FlutterVideoThumbnailPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> dispose() => throw UnimplementedError('dispose() has not been implemented.');

  Future<Uint8List?> getThumbnailData({
    required String videoPath,
    required int timeMs,
    int width = 0,
    int height = 0,
    required int quality,
    required ImageFormat thumbnailFormat,
    Map<String, String>? headers,
  }) {
    throw UnimplementedError('getThumbnailData() has not been implemented.');
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
    throw UnimplementedError('getThumbnailDataStream() has not been implemented.');
  }

  /// Returns a Stream of [VideoThumbnailResponseEvent]s.
  Stream<VideoThumbnailResponseEvent> videoThumbnailResponses() {
    throw UnimplementedError('videoThumbnailResponses() has not been implemented.');
  }
}

enum ImageFormat {
  JPG,
  PNG,
  WEBP_LOSSY,
  WEBP_LOSSLESS,
}

@immutable
class VideoThumbnailResponseEvent {
  /// Creates an instance of [VideoThumbnailResponseEvent].
  ///
  /// The [eventType] argument is required.
  ///
  const VideoThumbnailResponseEvent({
    required this.eventType,
    this.thumbnailData,
    this.receiveId,
  });

  /// The type of the event.
  final VideoThumbnailEventType eventType;

  /// The Thumbnail Data of video
  final Uint8List? thumbnailData;

  final String? receiveId;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is VideoThumbnailResponseEvent &&
            runtimeType == other.runtimeType &&
            eventType == other.eventType &&
            thumbnailData == other.thumbnailData &&
            receiveId == other.receiveId;
  }

  @override
  int get hashCode => Object.hash(eventType, thumbnailData, receiveId);
}

enum VideoThumbnailEventType {
  /// The Thumbnail Data response
  thumbnailDataResponse,

  /// An unknown event has been received.
  unknown,
}
