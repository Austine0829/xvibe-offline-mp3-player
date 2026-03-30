import 'package:flutter/services.dart';

class MediaStore {
    static const MethodChannel _channel =
      MethodChannel("com.example.mediastore");

 static Future<bool> deleteSong(dynamic songId) async {
    try {
      final bool result = await _channel.invokeMethod('deleteAudio', {
        'id': songId,
      });
      
      return result;

    // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> queryAudioFiles() async {
    final result = await _channel.invokeMethod("queryAudio");

    final List list = result;

    return list.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<bool> _canWriteSettings() async {
  return await _channel.invokeMethod<bool>('canWriteSettings') ?? false;
  }

  static Future<void> _openWriteSettingsPage() async {
    await _channel.invokeMethod('openWriteSettingsPage');
  }

  static Future<bool> setAsRingtone(int id, String title) async {
    try {
      final hasPermission = await _canWriteSettings();
      if (!hasPermission) {
        await _openWriteSettingsPage();
        return false;
      }

      return await _channel.invokeMethod<bool>(
        'setRingtone',
        {'id': id, 'title': title},
      ) ?? false;
    // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      return false;
    }
  }
}