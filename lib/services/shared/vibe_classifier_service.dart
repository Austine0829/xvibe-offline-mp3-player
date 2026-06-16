import 'dart:io';
import 'dart:typed_data';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:xvibe_offline_mp3_player/constants/vibe.dart';

class VibeClassifierService {
  static Interpreter? _yamnet;
  static Interpreter? _classifier;

  static Future<void> initialize() async {
    _yamnet = await Interpreter.fromAsset("assets/models/yamnet_model.tflite");
    _classifier = await Interpreter.fromAsset("assets/models/vibe_classification_model.tflite");
  }

  static Future<String> inference(String filePath) async {
    final pcd = await _decodeAudioToPCD(filePath);
    List<double>? embeddings = [];

    if (pcd != null) {
      embeddings = _getEmbedding(pcd);
    }

    _classifier!.allocateTensors();

    if (embeddings != null) {
      _classifier!.runInference([embeddings]);
    }

    final probsTensor = _classifier!.getOutputTensor(0);
    final probs = [List<double>.filled(5, 0.0)];
    probsTensor.copyTo(probs);

    List<String> vibeLabels = [Vibe.chill,
                               Vibe.chaotic,
                               Vibe.roadTrip,
                               Vibe.energetic,
                               Vibe.acoustic];

    int bestIndex = _argmax(probs);

    return vibeLabels[bestIndex];
  }

  static Future<Float32List?> _decodeAudioToPCD(String filePath) async {
    final tempDir = await getTemporaryDirectory();
    final outputPath = "${tempDir.path}/audio_pcm.raw";

     final sessionTwo = await FFmpegKit.executeWithArguments([
      '-y',
      '-i', filePath,
      '-t', '60',
      '-ar', '16000',
      '-ac', '1',
      '-f', 'f32le',
      outputPath,
    ]);

    final returnCode = await sessionTwo.getReturnCode();

    if (returnCode == null || !returnCode.isValueSuccess()) return null;
    final file = File(outputPath);

    final bytes = await file.readAsBytes();
    return bytes.buffer.asFloat32List();
  }

  static List<double>? _getEmbedding(Float32List pcmSamples) {
    var input = pcmSamples;

    _yamnet!.allocateTensors();
    _yamnet!.runInference([input]);

    final embeddingTensor = _yamnet!.getOutputTensor(1);
    final embedding = List<double>.filled(1024, 0.0);
    embeddingTensor.copyTo(embedding);

    return embedding;
  }

  static int _argmax(List<List<double>> probs) {
    int bestIndex = 0;
    double highestProbability = probs[0][0];

    for (var i = 0; i < probs.length; i++) {
      for (var j = 0; j < probs[i].length; j++) {
        if (probs[i][j] > highestProbability) {
          highestProbability = probs[i][j];
          bestIndex = j;
        }
      }
    }

    return bestIndex;
  }
}