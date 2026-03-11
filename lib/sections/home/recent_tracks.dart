import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:xvibe_offline_mp3_player/constants/label_name.dart';
import 'package:xvibe_offline_mp3_player/constants/playlist_id.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/pages/show_more_page.dart';
import 'package:xvibe_offline_mp3_player/services/music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/scanning_service.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/horizontal_song_card.dart';
import 'package:xvibe_offline_mp3_player/widgets/home/horizontal_text_and_text_button.dart';

// TODO: Re-implement it into a responsive design

class RecentTracksSection extends StatefulWidget {
  const RecentTracksSection({super.key});

  @override
  State<RecentTracksSection> createState() => _RecentTracksSectionState();
}

class _RecentTracksSectionState extends State<RecentTracksSection> {
  final String playlistId = Playlistid.recentTrack;
  // final List<Song> songs = [
  //   Song(id: 1, title: "AllDay Project - Look at me", vibe: "Chill", path: "assets/music/adp.mp3"),
  //   Song(id: 1, title: "Kehlani - Folded", vibe: "Chill", path: "assets/music/kehlani.mp3"),
  //   Song(id: 1, title: "J Tajor - All That Matters", vibe: "Chill", path: "assets/music/j_tajor.mp3"),
  // ];

  List<Song> songs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initPlaylist();
  }

  List<Song> formatSongs(List<File> files) {
    return files.map((file) {
      return Song(
        id: 1,
        title: basename(file.path.replaceAll(RegExp(r"_mixed\.mp3$|.mp3"), "")),
        path: file.path.replaceAll(RegExp(r"_mixed\.mp3$"), "").trim(),
        vibe: "Chill"
      );
    }).toList();
  }

  Future<void> initPlaylist() async {
     final songFiles = await ScanningService.scanMp3Songs([
      "/storage/emulated/0/Download"
     ]);

    setState(() {
      songs = formatSongs(songFiles);
      isLoading = false; 
    });

    final List<AudioSource> playlist = songs.map((song) => 
      AudioSource.file(song.path, tag: song)).toList();

    MusicPlayerService.setPlaylist(playlistId, playlist);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HorizontalTextAndTextButton(
          textLabel: "Recent Tracks",
          textButtonLabel: LabelName.showAll,
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
          }
        ),
        isLoading ? Text("Loading") : Column(
          children: [
             ...List.generate(
              3,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: HorizontalSongCard(
                  songTitle: songs[index].title,
                  songVibe: songs[index].vibe,
                  playlistId: playlistId,
                  indexId: index,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}