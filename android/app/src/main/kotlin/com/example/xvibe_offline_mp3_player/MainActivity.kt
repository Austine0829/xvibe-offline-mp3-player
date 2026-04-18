package com.example.xvibe_offline_mp3_player

import android.app.Activity
import android.app.RecoverableSecurityException
import android.content.ContentUris
import android.content.IntentSender
import android.database.Cursor
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.mediastore"
    private val DELETE_REQUEST_CODE = 1001

    private var pendingDeleteResult: MethodChannel.Result? = null
    private var pendingDeleteUri: Uri? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {

                    "queryAudio" -> {
                        val audioList = queryAudio()
                        result.success(audioList)
                    }

                    "canWriteSettings" -> {
                        val canWrite = Settings.System.canWrite(this)
                        result.success(canWrite)
                    }

                    "openWriteSettingsPage" -> {
                        val intent = android.content.Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS).apply {
                            data = Uri.parse("package:$packageName")
                        }
                        startActivity(intent)
                        result.success(null)
                    }

                    "setRingtone" -> {
                        val songId = (call.argument<Any>("id") as? Number)?.toLong()
                        val songTitle = call.argument<String>("title")

                        if (songId == null || songTitle == null) {
                            result.error("INVALID_ARGS", "Song id or title is null", null)
                            return@setMethodCallHandler
                        }

                        if (!Settings.System.canWrite(this)) {
                            result.error("NO_PERMISSION", "WRITE_SETTINGS permission not granted", null)
                            return@setMethodCallHandler
                        }

                        try {
                            val songUri = ContentUris.withAppendedId(
                                MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                                songId
                            )

                            android.util.Log.d("RINGTONE", "Song URI: $songUri")

                            RingtoneManager.setActualDefaultRingtoneUri(
                                this,
                                RingtoneManager.TYPE_RINGTONE,
                                songUri
                            )

                            val currentRingtone = RingtoneManager.getActualDefaultRingtoneUri(
                                this,
                                RingtoneManager.TYPE_RINGTONE
                            )
                            android.util.Log.d("RINGTONE", "Current ringtone URI after set: $currentRingtone")

                            if (currentRingtone == songUri) {
                                result.success(true)
                            } else {
                                result.error(
                                    "VERIFY_FAILED",
                                    "Ringtone was not set. Current: $currentRingtone, Expected: $songUri",
                                    null
                                )
                            }

                        } catch (e: Exception) {
                            android.util.Log.e("RINGTONE", "Exception: ${e.message}", e)
                            result.error("SET_RINGTONE_FAILED", e.message, null)
                        }
                    }

                    "deleteSong" -> {
                        val songId = (call.argument<Any>("id") as? Number)?.toLong()

                        if (songId == null) {
                            result.error("INVALID_ARGS", "Song id is null", null)
                            return@setMethodCallHandler
                        }

                        val songUri = ContentUris.withAppendedId(
                            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                            songId
                        )

                        android.util.Log.d("DELETE", "Attempting to delete URI: $songUri")

                        try {
                            val rowsDeleted = contentResolver.delete(songUri, null, null)
                            android.util.Log.d("DELETE", "Rows deleted: $rowsDeleted")

                            if (rowsDeleted > 0) {
                                result.success(true)
                            } else {
                                result.error("DELETE_FAILED", "No rows were deleted", null)
                            }

                        } catch (e: RecoverableSecurityException) {
                            android.util.Log.d("DELETE", "RecoverableSecurityException — requesting user confirmation")

                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                                try {
                                    pendingDeleteResult = result
                                    pendingDeleteUri = songUri
                                    val intentSender: IntentSender = e.userAction.actionIntent.intentSender
                                    startIntentSenderForResult(
                                        intentSender,
                                        DELETE_REQUEST_CODE,
                                        null, 0, 0, 0
                                    )
                                } catch (ex: IntentSender.SendIntentException) {
                                    pendingDeleteResult = null
                                    pendingDeleteUri = null
                                    result.error("DELETE_FAILED", ex.message, null)
                                }
                            } else {
                                result.error("DELETE_FAILED", e.message, null)
                            }

                        } catch (e: Exception) {
                            android.util.Log.e("DELETE", "Exception: ${e.message}", e)
                            result.error("DELETE_FAILED", e.message, null)
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: android.content.Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == DELETE_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                android.util.Log.d("DELETE", "User confirmed delete")
                try {
                    val rowsDeleted = contentResolver.delete(pendingDeleteUri!!, null, null)
                    if (rowsDeleted > 0) {
                        pendingDeleteResult?.success(true)
                    } else {
                        pendingDeleteResult?.error("DELETE_FAILED", "No rows deleted after confirmation", null)
                    }
                } catch (e: Exception) {
                    android.util.Log.e("DELETE", "Exception after confirmation: ${e.message}", e)
                    pendingDeleteResult?.error("DELETE_FAILED", e.message, null)
                }
            } else {
                android.util.Log.d("DELETE", "User denied delete")
                pendingDeleteResult?.error("DELETE_DENIED", "User denied the delete request", null)
            }

            pendingDeleteResult = null
            pendingDeleteUri = null
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

        val selection = "${MediaStore.Audio.Media.IS_MUSIC} != 0 AND " +
                "${MediaStore.Audio.Media.MIME_TYPE} = 'audio/mpeg'"

        val cursor: Cursor? = contentResolver.query(
            uri, projection, selection, null,
            MediaStore.Audio.Media.TITLE + " ASC"
        )

        cursor?.use {
            val idColumn = it.getColumnIndexOrThrow(MediaStore.Audio.Media._ID)
            val titleColumn = it.getColumnIndexOrThrow(MediaStore.Audio.Media.TITLE)
            val pathColumn = it.getColumnIndexOrThrow(MediaStore.Audio.Media.DATA)

            while (it.moveToNext()) {
                audioList.add(
                    mapOf(
                        "id" to it.getLong(idColumn),
                        "title" to it.getString(titleColumn),
                        "path" to it.getString(pathColumn)
                    )
                )
            }
        }

        return audioList
    }
}