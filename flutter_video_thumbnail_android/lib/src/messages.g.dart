// ignore_for_file: constant_identifier_names
// 
// Autogenerated from Pigeon (v15.0.3), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

PlatformException _createConnectionError(String channelName) {
  return PlatformException(
    code: 'channel-error',
    message: 'Unable to establish connection on channel: "$channelName".',
  );
}

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

  int formatIndex;

  Map<String?, String?> headers;

  String? receiveId;

  Object encode() {
    return <Object?>[
      videoPath,
      videoDurationMs,
      timeMs,
      width,
      height,
      quality,
      quantity,
      formatIndex,
      headers,
      receiveId,
    ];
  }

  static GetThumbnailDataMessage decode(Object result) {
    result as List<Object?>;
    return GetThumbnailDataMessage(
      videoPath: result[0]! as String,
      videoDurationMs: result[1] as int?,
      timeMs: result[2]! as int,
      width: result[3]! as int,
      height: result[4]! as int,
      quality: result[5]! as int,
      quantity: result[6]! as int,
      formatIndex: result[7]! as int,
      headers: (result[8] as Map<Object?, Object?>?)!.cast<String?, String?>(),
      receiveId: result[9] as String?,
    );
  }
}

class ThumbnailMessage {
  ThumbnailMessage({
    this.thumbnailData,
  });

  Uint8List? thumbnailData;

  Object encode() {
    return <Object?>[
      thumbnailData,
    ];
  }

  static ThumbnailMessage decode(Object result) {
    result as List<Object?>;
    return ThumbnailMessage(
      thumbnailData: result[0] as Uint8List?,
    );
  }
}

class _VideoThumbnailApiCodec extends StandardMessageCodec {
  const _VideoThumbnailApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is GetThumbnailDataMessage) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is ThumbnailMessage) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return GetThumbnailDataMessage.decode(readValue(buffer)!);
      case 129: 
        return ThumbnailMessage.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class VideoThumbnailApi {
  /// Constructor for [VideoThumbnailApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  VideoThumbnailApi({BinaryMessenger? binaryMessenger})
      : __pigeon_binaryMessenger = binaryMessenger;
  final BinaryMessenger? __pigeon_binaryMessenger;

  static const MessageCodec<Object?> pigeonChannelCodec = _VideoThumbnailApiCodec();

  Future<void> dispose() async {
    const String __pigeon_channelName = 'dev.flutter.pigeon.flutter_video_thumbnail_android.VideoThumbnailApi.dispose';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(null) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<ThumbnailMessage> getThumbnailDataAsync(GetThumbnailDataMessage msg) async {
    const String __pigeon_channelName = 'dev.flutter.pigeon.flutter_video_thumbnail_android.VideoThumbnailApi.getThumbnailDataAsync';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[msg]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else if (__pigeon_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (__pigeon_replyList[0] as ThumbnailMessage?)!;
    }
  }

  Future<void> getThumbnailData(GetThumbnailDataMessage msg) async {
    const String __pigeon_channelName = 'dev.flutter.pigeon.flutter_video_thumbnail_android.VideoThumbnailApi.getThumbnailData';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[msg]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return;
    }
  }
}