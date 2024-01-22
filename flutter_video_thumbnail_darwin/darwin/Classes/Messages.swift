// ignore_for_file: constant_identifier_names
// 
// Autogenerated from Pigeon (v15.0.3), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)"
  ]
}

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

/// Generated class from Pigeon that represents data sent in messages.
struct GetThumbnailDataMessage {
  var videoPath: String
  var videoDurationMs: Int64? = nil
  var timeMs: Int64
  var width: Int64
  var height: Int64
  var quality: Int64
  var quantity: Int64
  var formatIndex: Int64
  var headers: [String?: String?]
  var receiveId: String? = nil

  static func fromList(_ list: [Any?]) -> GetThumbnailDataMessage? {
    let videoPath = list[0] as! String
    let videoDurationMs: Int64? = isNullish(list[1]) ? nil : (list[1] is Int64? ? list[1] as! Int64? : Int64(list[1] as! Int32))
    let timeMs = list[2] is Int64 ? list[2] as! Int64 : Int64(list[2] as! Int32)
    let width = list[3] is Int64 ? list[3] as! Int64 : Int64(list[3] as! Int32)
    let height = list[4] is Int64 ? list[4] as! Int64 : Int64(list[4] as! Int32)
    let quality = list[5] is Int64 ? list[5] as! Int64 : Int64(list[5] as! Int32)
    let quantity = list[6] is Int64 ? list[6] as! Int64 : Int64(list[6] as! Int32)
    let formatIndex = list[7] is Int64 ? list[7] as! Int64 : Int64(list[7] as! Int32)
    let headers = list[8] as! [String?: String?]
    let receiveId: String? = nilOrValue(list[9])

    return GetThumbnailDataMessage(
      videoPath: videoPath,
      videoDurationMs: videoDurationMs,
      timeMs: timeMs,
      width: width,
      height: height,
      quality: quality,
      quantity: quantity,
      formatIndex: formatIndex,
      headers: headers,
      receiveId: receiveId
    )
  }
  func toList() -> [Any?] {
    return [
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
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct ThumbnailMessage {
  var thumbnailData: FlutterStandardTypedData? = nil

  static func fromList(_ list: [Any?]) -> ThumbnailMessage? {
    let thumbnailData: FlutterStandardTypedData? = nilOrValue(list[0])

    return ThumbnailMessage(
      thumbnailData: thumbnailData
    )
  }
  func toList() -> [Any?] {
    return [
      thumbnailData,
    ]
  }
}
private class VideoThumbnailApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return GetThumbnailDataMessage.fromList(self.readValue() as! [Any?])
      case 129:
        return ThumbnailMessage.fromList(self.readValue() as! [Any?])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class VideoThumbnailApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? GetThumbnailDataMessage {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else if let value = value as? ThumbnailMessage {
      super.writeByte(129)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class VideoThumbnailApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return VideoThumbnailApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return VideoThumbnailApiCodecWriter(data: data)
  }
}

class VideoThumbnailApiCodec: FlutterStandardMessageCodec {
  static let shared = VideoThumbnailApiCodec(readerWriter: VideoThumbnailApiCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol VideoThumbnailApi {
  func dispose() throws
  func getThumbnailDataAsync(msg: GetThumbnailDataMessage) throws -> ThumbnailMessage
  func getThumbnailData(msg: GetThumbnailDataMessage) throws
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class VideoThumbnailApiSetup {
  /// The codec used by VideoThumbnailApi.
  static var codec: FlutterStandardMessageCodec { VideoThumbnailApiCodec.shared }
  /// Sets up an instance of `VideoThumbnailApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: VideoThumbnailApi?) {
    let disposeChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.flutter_video_thumbnail_darwin.VideoThumbnailApi.dispose", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      disposeChannel.setMessageHandler { _, reply in
        do {
          try api.dispose()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      disposeChannel.setMessageHandler(nil)
    }
    let getThumbnailDataAsyncChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.flutter_video_thumbnail_darwin.VideoThumbnailApi.getThumbnailDataAsync", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getThumbnailDataAsyncChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let msgArg = args[0] as! GetThumbnailDataMessage
        do {
          let result = try api.getThumbnailDataAsync(msg: msgArg)
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getThumbnailDataAsyncChannel.setMessageHandler(nil)
    }
    let getThumbnailDataChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.flutter_video_thumbnail_darwin.VideoThumbnailApi.getThumbnailData", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getThumbnailDataChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let msgArg = args[0] as! GetThumbnailDataMessage
        do {
          try api.getThumbnailData(msg: msgArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getThumbnailDataChannel.setMessageHandler(nil)
    }
  }
}
