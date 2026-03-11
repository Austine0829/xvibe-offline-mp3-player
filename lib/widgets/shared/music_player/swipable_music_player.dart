import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/services/music_player_service.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/music_player/duration_slider.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/music_player/play_pause_button.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/music_player/repeat_button.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/music_player/shuffle_button.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/music_player/title_subtitle.dart';

class SwipableMusicPlayer extends StatefulWidget {
  const SwipableMusicPlayer({super.key});

  @override
  State<SwipableMusicPlayer> createState() => _SwipableMusicPlayerState();
}

class _SwipableMusicPlayerState extends State<SwipableMusicPlayer> {
  Future<void> seekNext() async => await MusicPlayerService.seekNext();
  Future<void> seekPrevious() async => await MusicPlayerService.seekPrevious();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 1,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(color: Colors.black),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: ListView(
            controller: scrollController,
            children: [
              Align(
                alignment: AlignmentGeometry.topCenter,
                child: const Text(
                  "Now playing...",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40, bottom: 25),
                child: Image.asset(
                  "assets/music_card_default.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
              TitleSubtitle(),
              DurationSlider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ShuffleButton(),
                  IconButton(
                    onPressed: () => seekPrevious(),
                    icon: Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  PlayPauseButton(),
                  IconButton(
                    onPressed: () => seekNext(),
                    icon: Icon(Icons.skip_next, color: Colors.white, size: 50),
                  ),
                  RepeatButton(),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
