import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/services/music_player_service.dart';
import 'package:xvibe_offline_mp3_player/utils/song_duration_formater.dart';

class DurationSlider extends StatefulWidget {
  const DurationSlider({super.key});

  @override
  State<DurationSlider> createState() => _DurationSliderState();
}

class _DurationSliderState extends State<DurationSlider> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: MusicPlayerService.positionStream(), 
      builder: (context, snapshot) {
        final currentDuration = snapshot.data ?? Duration.zero;
        final songDuration = MusicPlayerService.currentSongDuration() ?? Duration.zero;

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
                  MusicPlayerService.seekTo(Duration(seconds: value.toInt()));
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
