import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/song_service.dart';

class Share extends StatefulWidget {
  final int songId;

  const Share({
    super.key,
    required this.songId,
  });

  @override
  State<Share> createState() => _ShareState();
}

class _ShareState extends State<Share> {
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

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    _shareSong();
  }

  Future<void> _shareSong() async {
    if (song == null) return;

    final box = context.findRenderObject() as RenderBox?;
    final file = XFile(song!.path);

    await SharePlus.instance.share(
      ShareParams(
        files: [file],
        text: song!.title,
        sharePositionOrigin: box != null
            ? box.localToGlobal(Offset.zero) & box.size
            : null,
      ),
    );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : const SizedBox.shrink(),
      ),
    );
  }
}