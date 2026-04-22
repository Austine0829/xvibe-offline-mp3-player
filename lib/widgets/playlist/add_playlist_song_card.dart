import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/DTO/playlist_song_dto.dart';
import 'package:xvibe_offline_mp3_player/utils/uuid_generator.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_playlist_song_view_model.dart';
import '../../utils/app_text_theme.dart';

class AddPlaylistSongCard extends StatelessWidget {
  final IPlaylistSongViewModel playlistSongViewModel;
  final int songId;
  final String title;
  final String vibe;
  final String path;

  const AddPlaylistSongCard({
    super.key,
    required this.playlistSongViewModel,
    required this.songId,
    required this.title,
    required this.vibe,
    required this.path
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/music_card_default.jpeg"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.horizontalCardTitle,
                  ),
                  Text(
                    vibe,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.cardGenre,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              await playlistSongViewModel.addPlaylistSong(
                  PlaylistSongDTO(
                  playlistSongId: UuidGenerator.generate(), 
                  songId: songId, 
                  title: title, 
                  vibe: vibe, 
                  path: path
                )
              );

              if (playlistSongViewModel.errorMessage != null
                  && context.mounted) {
                ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(playlistSongViewModel.errorMessage!)));
              }
            },
            icon: Icon(Icons.add_rounded, size: 30),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
