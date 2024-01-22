package com.vanvixi.flutter_video_thumbnail_android

enum class ImageFormat(val raw: Int) {
    JPG(0),
    PNG(1),
    WEBP_LOSSY(2),
    WEBP_LOSSLESS(3);

    companion object {
        fun ofRaw(raw: Int): ImageFormat? {
            return values().firstOrNull { it.raw == raw }
        }
    }
}