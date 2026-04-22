import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/music_player_service.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/current_queue_dialog.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/music_player/duration_slider.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/music_player/play_pause_button.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/music_player/repeat_button.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/music_player/shuffle_button.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/music_player/title_subtitle.dart';

class SwipableMusicPlayer extends StatefulWidget {
  const SwipableMusicPlayer({super.key});

  @override
  State<SwipableMusicPlayer> createState() => _SwipableMusicPlayerState();
}

class _SwipableMusicPlayerState extends State<SwipableMusicPlayer> {
  late final IMusicPlayerService _musicPlayerService;
  bool isInitialize = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!isInitialize) {
      _musicPlayerService = context.read<MusicPlayerService>();
      isInitialize = true;
    }
  }

  Future<void> seekNext() async => await _musicPlayerService.seekNext();
  Future<void> seekPrevious() async => await _musicPlayerService.seekPrevious();

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
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40, bottom: 25),
                child: Image.asset(
                  "assets/music_card_default.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
              TitleSubtitle(musicPlayerService: _musicPlayerService,),
              DurationSlider(musicPlayerService: _musicPlayerService,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ShuffleButton(musicPlayerService: _musicPlayerService,),
                  IconButton(
                    onPressed: () => seekPrevious(),
                    icon: Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  PlayPauseButton(musicPlayerService: _musicPlayerService,),
                  IconButton(
                    onPressed: () => seekNext(),
                    icon: Icon(Icons.skip_next, color: Colors.white, size: 50),
                  ),
                  RepeatButton(musicPlayerService: _musicPlayerService,),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     IconButton(
                      onPressed: () {}, 
                      icon: Icon(Icons.favorite),
                      color: Colors.white,
                      iconSize: 35,
                    ),
                    IconButton(
                      onPressed: () {
                         showModalBottomSheet(
                          context: context,
                          backgroundColor: const Color.fromARGB(221, 27, 27, 27),
                          showDragHandle: true,
                          builder: (context) {
                            return CurrentQueueDialog(
                              musicPlayerService: context.watch<MusicPlayerService>()
                            );
                          },
                        );
                      }, 
                      icon: Icon(Icons.menu_rounded),
                      color: Colors.white,
                      iconSize: 35,
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
