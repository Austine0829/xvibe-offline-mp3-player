package com.example.xvibe_offline_mp3_player

import android.database.Cursor
import android.net.Uri
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.example.mediastore"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                if (call.method == "queryAudio") {

                    val audioList = queryAudio()
                    result.success(audioList)

                } else {
                    result.notImplemented()
                }
            }
    }

    private fun queryAudio(): List<Map<String, Any>> {

        val audioList = mutableListOf<Map<String, Any>>()

        val uri: Uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI

        val projection = arrayOf(
            MediaStore.Audio.Media._ID,
            MediaStore.Audio.Media.TITLE,
            MediaStore.Audio.Media.DATA
        )

        // Filter to remove ringtones, alarms, notifications, recordings
        val selection = "${MediaStore.Audio.Media.IS_MUSIC} != 0"

        val cursor: Cursor? = contentResolver.query(
            uri,
            projection,
            selection,
            null,
            MediaStore.Audio.Media.TITLE + " ASC"
        )

        cursor?.use {

            val idColumn = it.getColumnIndexOrThrow(MediaStore.Audio.Media._ID)
            val titleColumn = it.getColumnIndexOrThrow(MediaStore.Audio.Media.TITLE)
            val pathColumn = it.getColumnIndexOrThrow(MediaStore.Audio.Media.DATA)

            while (it.moveToNext()) {

                val id = it.getLong(idColumn)
                val title = it.getString(titleColumn)
                val path = it.getString(pathColumn)

                val song = mapOf(
                    "id" to id,
                    "title" to title,
                    "path" to path
                )

                audioList.add(song)
            }
        }

        return audioList
    }
}