                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/current_queue_song_card.dart';

class CurrentQueueDialog extends StatelessWidget {
  final IMusicPlayerService musicPlayerService;

  const CurrentQueueDialog({
    super.key,
    required this.musicPlayerService
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Queue", style: TextStyle(color: Colors.white),), 
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      backgroundColor: Colors.transparent,
      body: DraggableScrollableSheet(
        initialChildSize: 1,
        expand: false,
        builder: (context, scrollController) {
          return ListView.builder(
            padding: EdgeInsets.all(12),
            controller: scrollController,
            itemCount: musicPlayerService.getCurrentQueue().length,
            itemBuilder: (_, index) {
              return Column(
                children: [
                  CurrentQueueSongCard(
                    musicPlayerService: musicPlayerService, 
                    songId: musicPlayerService.getCurrentQueue()[index].id, 
                    title: musicPlayerService.getCurrentQueue()[index].title, 
                    vibe: musicPlayerService.getCurrentQueue()[index].vibe, 
                    path: musicPlayerService.getCurrentQueue()[index].path,
                    indexId: index,
                ),
                  SizedBox(height: 5,)
                ],
              );
            }
          );
        },
      ),
    );
  }
}
