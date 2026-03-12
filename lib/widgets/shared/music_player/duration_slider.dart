import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/utils/song_duration_formater.dart';

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
          data: SliderTheme.of(context).copyWith(
            trackHeight: 1,
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.grey,
            thumbColor: Colors.deepOrangeAccent,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
          ),
          child: Column(
            children: [
              Slider(
                value: currentDuration.inSeconds.
                  toDouble().clamp(0, songDuration.inSeconds.toDouble()),
                max: songDuration.inSeconds.toDouble(),
                min: 0,
                padding: EdgeInsets.only(left: 0, right: 0, top: 15),
                onChanged: (value) {
                  musicPlayerService.seekTo(Duration(seconds: value.toInt()));
                },
              ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      SongDurationFormater.format(currentDuration), 
                      style: TextStyle(color: Colors.grey)
                    ),
                    Text(
                      SongDurationFormater.format(songDuration), 
                      style: TextStyle(color: Colors.grey)
                    ),
                ],
              ),
            ],
          )
        ); 
      }
    );
  }
}