package com.vanvixi.flutter_video_thumbnail_android

import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

/** FlutterVideoThumbnailAndroidPlugin */
class FlutterVideoThumbnailAndroidPlugin : FlutterPlugin, VideoThumbnailApi {
    private val kTAG = "FVideoThumbnailPlugin"
    private val eventChannelName = "vanvixi/flutter_video_thumbnail"
    private val mainScope = CoroutineScope(Dispatchers.Main)
    private var flutterState: FlutterState? = null
    private val videoThumbnailUtil = VideoThumbnailUtil()

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val eventChannel = EventChannel(binding.binaryMessenger, eventChannelName)

        flutterState = FlutterState(eventChannel)
        flutterState!!.startListening(this, binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        if (flutterState == null) {
            Log.wtf(kTAG, "Detached from the engine before registering to it.")
        }
        flutterState?.stopListening(binding.binaryMessenger)
        flutterState = null

        videoThumbnailUtil.dispose()

    }

    override fun dispose() {
        videoThumbnailUtil.dispose()
        Log.d(kTAG, "FlutterVideoEditorPlugin disposed")
    }

    override fun getThumbnailDataAsync(msg: GetThumbnailDataMessage): ThumbnailMessage {
        val videoPath = msg.videoPath
        val format = ImageFormat.ofRaw(msg.formatIndex.toInt()) ?: ImageFormat.JPG

        videoThumbnailUtil.setDataSource(videoPath, HashMap(msg.headers))

        val byteArray: ByteArray? = videoThumbnailUtil.getThumbnailData(
            msg.width.toInt(),
            msg.height.toInt(),
            msg.timeMs.toInt(),
            msg.quality.toInt(),
            format,
        )

        return ThumbnailMessage(thumbnailData = byteArray)
    }

    override fun getThumbnailData(msg: GetThumbnailDataMessage) {
        mainScope.launch {
            val videoPath = msg.videoPath
            val format = ImageFormat.ofRaw(msg.formatIndex.toInt()) ?: ImageFormat.JPG

            videoThumbnailUtil.setDataSource(videoPath, HashMap(msg.headers))

            videoThumbnailUtil.getMultiThumbnailData(
                msg.videoDurationMs,
                msg.width.toInt(),
                msg.height.toInt(),
                msg.quality.toInt(),
                msg.quantity.toInt(),
                format,
            ) { byteArray ->
                val event: HashMap<String, Any?> = HashMap()
                event["event"] = "thumbnailDataResponse"
                event["value"] = byteArray
                event["receiveId"] = msg.receiveId

                flutterState?.eventSink?.success(event)
            }
        }
    }

    class FlutterState(private val eventChannel: EventChannel) {

        var eventSink: EventChannel.EventSink? = null

        fun startListening(methodCallHandler: VideoThumbnailApi, messenger: BinaryMessenger) {
            VideoThumbnailApi.setUp(messenger, methodCallHandler)
            eventChannel.setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(o: Any?, sink: EventChannel.EventSink) {
                        eventSink = sink
                    }

                    override fun onCancel(o: Any?) {
                        eventSink = null
                    }
                })
        }

        fun stopListening(messenger: BinaryMessenger) {
            VideoThumbnailApi.setUp(messenger, null)
            eventChannel.setStreamHandler(null)
        }
    }
}
