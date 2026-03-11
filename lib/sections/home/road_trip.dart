import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:xvibe_offline_mp3_player/constants/label_name.dart';
import 'package:xvibe_offline_mp3_player/constants/playlist_id.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/pages/show_more_page.dart';
import 'package:xvibe_offline_mp3_player/services/music_player_service.dart';
import 'package:xvibe_offline_mp3_player/widgets/home/horizontal_text_and_text_button.dart';
import '../../services/home/labeling_service.dart';
import '../../widgets/home/vertical_song_card.dart';

// TODO: Re-implement it into a responsive design

class RoadTripSection extends StatefulWidget {
  const RoadTripSection({super.key});

  @override
  State<RoadTripSection> createState() => _RoadTripSectionState();
}

class _RoadTripSectionState extends State<RoadTripSection> {
  final String playlistId = Playlistid.roadTrip;
  final List<Song> songs = [
    Song(id: 1, title: "J Tajor - All That Matters", vibe: "Chill", path: "assets/music/j_tajor.mp3"),
    Song(id: 1, title: "Kehlani - Folded", vibe: "Chill", path: "assets/music/kehlani.mp3"),
    Song(id: 1, title: "AllDay Project - Look at me", vibe: "Chill", path: "assets/music/adp.mp3"),
  ];

  List<AudioSource> get playlist => songs.map((song) 
    => AudioSource.asset(song.path, tag: song)).toList();

  @override
  void initState() {
    super.initState();
    initPlaylist();
  }

  Future<void> initPlaylist() async =>
    MusicPlayerService.setPlaylist(playlistId, playlist);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HorizontalTextAndTextButton(
          textLabel: LabelingService.generate(LabelType.roadTrip),
          textButtonLabel: LabelName.showMore,
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ShowMorePage( 
                  songs: songs, 
                  playlistId: playlistId
                ),
              ),
            );
          },
        ),
        Container(
          constraints: BoxConstraints(
            maxHeight: 200,
            maxWidth: double.infinity,
          ),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              return VerticalSongCard(
                songTitle: songs[index].title,
                songVibe: songs[index].vibe,
                playlistId: playlistId,
                indexId: index,
              );
            },
            separatorBuilder: (_, _) => SizedBox(width: 8),
            itemCount: playlist.length,
          ),
        ),
      ],
    );
  }
}
