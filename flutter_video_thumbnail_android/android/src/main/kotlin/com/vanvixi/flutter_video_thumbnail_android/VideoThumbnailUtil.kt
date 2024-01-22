package com.vanvixi.flutter_video_thumbnail_android

import android.graphics.Bitmap
import android.graphics.Bitmap.CompressFormat
import android.media.MediaMetadataRetriever
import android.os.Build
import android.util.Log
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileInputStream

fun interface ThumbnailCallback {
    fun result(byteArray: ByteArray)
}

private class VideoUtilException(message: String) : Exception(message)

class VideoThumbnailUtil {
    private val kTAG = "VideoUtil"

    private var retriever: MediaMetadataRetriever? = null

    val duration: Long
        get() {
            return try {
                if (retriever == null) {
                    throw VideoUtilException("Please call setDataSource() before doing anything")
                }

                val duration =
                    retriever?.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)

                duration?.toLong() ?: 0
            } catch (exception: Throwable) {
                Log.d(kTAG, "getDuration: $exception")

                0
            }
        }

    fun setDataSource(videoPath: String, headers: HashMap<String?, String?>?) {
        retriever = MediaMetadataRetriever()
        val path: String = if (videoPath.startsWith("/")) {
            videoPath
        } else if (videoPath.startsWith("file://")) {
            videoPath.substring(7)
        } else {
            retriever?.setDataSource(videoPath, headers ?: HashMap())
            return
        }

        val videoFile = File(path)
        val inputStream = FileInputStream(videoFile.absolutePath)
        retriever?.setDataSource(inputStream.fd)
    }

    fun dispose() {
        try {
            if (retriever == null) {
                Log.wtf(kTAG, "released from the plugin before setDataSource to it.")
            }

            retriever?.release()
            retriever = null
            Log.wtf(kTAG, "MediaMetadataRetriever released.")
        } catch (exception: Throwable) {
            Log.d(kTAG, "MediaMetadataRetriever call release(): $exception")
        }
    }

    fun getMultiThumbnailData(
        videoDuration: Long?,
        maxW: Int,
        maxH: Int,
        quality: Int,
        quantity: Int,
        format: ImageFormat,
        callback: ThumbnailCallback
    ) {
        try {
            val eachPart = (videoDuration ?: duration) / quantity
            // Retrieve media data use microsecond
            // val interval = (endPosition - startPosition) / (totalThumbsCount - 1)
            for (i in 1..quantity) {
                val byteArray = getThumbnailData(
                    maxW,
                    maxH,
                    (eachPart * i).toInt(),
                    quality,
                    format,
                ) ?: continue

                callback.result(byteArray)
            }
        } catch (e: Throwable) {
            Thread.getDefaultUncaughtExceptionHandler()
                ?.uncaughtException(Thread.currentThread(), e)
        }
    }

    fun getThumbnailData(
        maxW: Int,
        maxH: Int,
        timeMs: Int,
        quality: Int,
        format: ImageFormat,
    ): ByteArray? {
        try {
            val bitmap: Bitmap = geThumbnailAtTime(maxW, maxH, timeMs)
                ?: return null

            val stream = ByteArrayOutputStream()
            bitmap.compress(format.findCompressFormat(), quality, stream)
            bitmap.recycle()

            return stream.toByteArray()
        } catch (exception: Throwable) {
            Log.d(kTAG, "getThumbnailData(): $exception")

            throw exception
        }
    }

    /**
     * Create a video thumbnail for a video. May return null if the video is corrupt
     * or the format is not supported.
     *
     * @param dstWidth the max width of the thumbnail
     * @param dstHeight the max height of the thumbnail
     */
    private fun geThumbnailAtTime(dstWidth: Int, dstHeight: Int, timeMs: Int): Bitmap? {
        if (retriever == null) {
            throw VideoUtilException("Please call geThumbnailAtTime() after setDataSource()")
        }

        val timeUs = (timeMs * 1000).toLong()
        val option = MediaMetadataRetriever.OPTION_CLOSEST_SYNC

        return try {
            // Prioritize the most efficient method for API level 27+
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1 && dstWidth != 0 && dstHeight != 0) {
                return retriever?.getScaledFrameAtTime(timeUs, option, dstWidth, dstHeight)
            }

            // Handle target dimensions and scaling for lower API levels
            val bitmap = retriever?.getFrameAtTime(timeUs, option) ?: return null
            return scaleBitmapIfNeeded(bitmap, dstWidth, dstHeight)
        } catch (exception: Throwable) {
            Log.d(kTAG, "geThumbnailAtTime(): $exception")
            null
        }
    }

    private fun scaleBitmapIfNeeded(bitmap: Bitmap, targetW: Int, targetH: Int): Bitmap {
        val width = bitmap.width
        val height = bitmap.height

        if (targetW == 0 && targetH == 0 || targetW >= width && targetH >= height) return bitmap

        // Preserve aspect ratio if either target dimension is 0
        val aspectRatio = width.toFloat() / height
        val scaledWidth = if (targetW == 0) (targetH * aspectRatio).toInt() else targetW
        val scaledHeight = if (targetH == 0) (targetW / aspectRatio).toInt() else targetH

        return Bitmap.createScaledBitmap(bitmap, scaledWidth, scaledHeight, true)
    }

    private fun ImageFormat.findCompressFormat(): CompressFormat {
        return when (this) {
            ImageFormat.JPG -> CompressFormat.JPEG

            ImageFormat.PNG -> CompressFormat.PNG

            ImageFormat.WEBP_LOSSY -> if (Build.VERSION.SDK_INT > Build.VERSION_CODES.R) CompressFormat.WEBP_LOSSY else CompressFormat.WEBP

            ImageFormat.WEBP_LOSSLESS -> if (Build.VERSION.SDK_INT > Build.VERSION_CODES.R) CompressFormat.WEBP_LOSSLESS else CompressFormat.WEBP
        }
    }
}
