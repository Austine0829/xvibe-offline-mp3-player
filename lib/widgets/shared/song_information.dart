import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/song_service.dart';

class SongInformation extends StatefulWidget {
   final int songId;

  const SongInformation({
    super.key,
    required this.songId
  });

  @override
  State<SongInformation> createState() => _SongInformationState();
}

class _SongInformationState extends State<SongInformation> {
  late final ISongService _songService;
  bool isInitialize = false;
  bool isLoading = true;
  Song? song;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInitialize) {
      _songService = context.read<SongService>();
      initialize(widget.songId);
      isInitialize = true;
    }
  }

  Future<void> initialize(int id) async {
    song = await _songService.getSong(id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      expand: false,
      builder: (context, scrollController) {
        if (isLoading && song == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
          
        return ListView(
          children: [
              ListTile(
                title: Text("ID"),
                subtitle: Text(song!.id.toString()),
              ),
              ListTile(
                title: Text("Song Title"),
                subtitle: Text(song!.title),
              ),
              ListTile(
                title: Text("Vibe"),
                subtitle: Text(song!.vibe),
              ),
              ListTile(
                title: Text("Path"),
                subtitle: Text(song!.path),
              )
          ],
        );
      },
    );
  }
}