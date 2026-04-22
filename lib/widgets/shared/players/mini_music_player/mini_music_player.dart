import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/music_player_service.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/current_queue_dialog.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/mini_music_player/duration_slider.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/mini_music_player/play_pause_button.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/music_player/swipable_music_player.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/music_player/swipable_music_player_handler.dart';

class MiniMusicPlayer extends StatefulWidget {
  const MiniMusicPlayer({super.key});

  @override
  State<MiniMusicPlayer> createState() => _MiniMusicPlayerState();
}

class _MiniMusicPlayerState extends State<MiniMusicPlayer> {
  late final IMusicPlayerService _musicPlayerService;
  bool isInitialize = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInitialize) {
      _musicPlayerService = context.read<MusicPlayerService>();
      isInitialize = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final IMusicPlayerService musicPlayerService = context
        .watch<MusicPlayerService>();

    if (musicPlayerService.getCurrentQueue().isEmpty) {
      return Card();
    }

    return Card(
      color: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder(
            stream: _musicPlayerService.playerSequenceStateStream(),
            builder: (context, snapshot) {
              final state = snapshot.data;
              Song? song;

              if (state != null) {
                song = state.currentSource?.tag as Song;
              }

              return ListTile(
                onTap: () => SwipableMusicPlayerHandler.show(
                  SwipableMusicPlayer(),
                  context,
                ),
                leading: Image.asset("assets/music_card_default.jpeg"),
                title: Text(
                  song != null ? song.title : "Music Title",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                  maxLines: 1,
                ),
                subtitle: Text(
                  song != null ? song.vibe : "Music Vibe",
                  style: TextStyle(color: Colors.blueGrey, fontSize: 13),
                ),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      PlayPauseButton(musicPlayerService: _musicPlayerService),
                      IconButton(
                        icon: Icon(
                          Icons.menu_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: const Color.fromARGB(
                              221,
                              27,
                              27,
                              27,
                            ),
                            showDragHandle: true,
                            builder: (context) {
                              return CurrentQueueDialog(
                                musicPlayerService: context
                                    .watch<MusicPlayerService>(),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          DurationSlider(musicPlayerService: _musicPlayerService),
        ],
      ),
    );
  }
}
