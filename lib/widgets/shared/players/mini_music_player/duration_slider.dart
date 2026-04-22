import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';

class DurationSlider extends StatelessWidget {
  final IMusicPlayerService musicPlayerService;

  const DurationSlider({
    super.key,
    required this.musicPlayerService
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: musicPlayerService.positionStream(), 
      builder: (context, snapshot) {
        final currentDuration = snapshot.data ?? Duration.zero;
        final songDuration = musicPlayerService.currentSongDuration() ?? Duration.zero;

        return SliderTheme(
          data: SliderThemeData(
            trackHeight: 2,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4), // small thumb
            overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
            thumbColor: Colors.white,
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.grey[700],
            overlayColor: Colors.white24,
          ),
          child: Slider(
            value: currentDuration.inSeconds
              .toDouble().clamp(0, songDuration.inSeconds.toDouble()),
            max: songDuration.inSeconds.toDouble(),
            min: 0,
            padding: EdgeInsets.symmetric(horizontal: 15),
            onChanged: (value) {
              musicPlayerService.seekTo(Duration(seconds: value.toInt()));
            },
          ),
        );
      }
    );
  }
}