package com.shizuka.app

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val localDataChannel = "com.shizuka.app/local_data"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            localDataChannel,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "ensureStructure" -> {
                    ensureDataStructure()
                    result.success(null)
                }

                "readText" -> {
                    val path = call.argument<String>("path").orEmpty()
                    val file = resolveDataFile(path)
                    result.success(if (file.exists()) file.readText() else null)
                }

                "listFiles" -> {
                    val directory = call.argument<String>("directory").orEmpty()
                    val root = resolveDataFile(directory)
                    val files = if (root.exists() && root.isDirectory) {
                        root.listFiles()
                            ?.filter { it.isFile }
                            ?.map { "$directory/${it.name}" }
                            .orEmpty()
                    } else {
                        emptyList()
                    }
                    result.success(files)
                }

                "writeText" -> {
                    val path = call.argument<String>("path").orEmpty()
                    val content = call.argument<String>("content").orEmpty()
                    val file = resolveDataFile(path)
                    file.parentFile?.mkdirs()
                    file.writeText(content)
                    result.success(null)
                }

                "writeBytes" -> {
                    val path = call.argument<String>("path").orEmpty()
                    val bytes = call.argument<ByteArray>("bytes") ?: ByteArray(0)
                    val file = resolveDataFile(path)
                    file.parentFile?.mkdirs()
                    file.writeBytes(bytes)
                    result.success(file.absolutePath)
                }

                "deleteFile" -> {
                    val path = call.argument<String>("path").orEmpty()
                    val file = resolveDataFile(path)
                    if (file.exists() && file.isFile) {
                        file.delete()
                    }
                    result.success(null)
                }

                "exportTextToDownloads" -> {
                    try {
                        val fileName = call.argument<String>("fileName").orEmpty()
                        val mimeType = call.argument<String>("mimeType") ?: "application/json"
                        val content = call.argument<String>("content").orEmpty()
                        exportTextToDownloads(fileName, mimeType, content)
                        result.success(null)
                    } catch (error: Exception) {
                        result.error("EXPORT_FAILED", error.message, null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun ensureDataStructure() {
        filesDir.mkdirs()
        File(filesDir, "characters").mkdirs()
        File(filesDir, "chats").mkdirs()
        File(filesDir, "memories").mkdirs()
    }

    private fun resolveDataFile(relativePath: String): File {
        require(relativePath.isNotBlank()) { "Data path is required." }
        require(!relativePath.startsWith("/") && !relativePath.contains("..")) {
            "Invalid data path."
        }

        ensureDataStructure()
        val root = filesDir.canonicalFile
        val file = File(root, relativePath).canonicalFile
        require(file.path.startsWith(root.path)) { "Invalid data path." }
        return file
    }

    private fun exportTextToDownloads(fileName: String, mimeType: String, content: String) {
        require(fileName.isNotBlank()) { "File name is required." }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val values = ContentValues().apply {
                put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                put(MediaStore.Downloads.MIME_TYPE, mimeType)
                put(MediaStore.Downloads.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
                put(MediaStore.Downloads.IS_PENDING, 1)
            }
            val resolver = applicationContext.contentResolver
            val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
                ?: throw IllegalStateException("Cannot create download file.")
            resolver.openOutputStream(uri)?.use { stream ->
                stream.write(content.toByteArray(Charsets.UTF_8))
            } ?: throw IllegalStateException("Cannot write download file.")
            values.clear()
            values.put(MediaStore.Downloads.IS_PENDING, 0)
            resolver.update(uri, values, null, null)
        } else {
            val downloads = Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_DOWNLOADS,
            )
            downloads.mkdirs()
            File(downloads, fileName).writeText(content, Charsets.UTF_8)
        }
    }
}
