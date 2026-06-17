import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/pages/home/sections/acoustic_vibe_section.dart';
import 'package:xvibe_offline_mp3_player/pages/home/sections/chaotic_vibe_section.dart';
import 'package:xvibe_offline_mp3_player/pages/home/sections/chill_vibe_section.dart';
import 'package:xvibe_offline_mp3_player/pages/home/sections/mix_vibe_section.dart';
import 'package:xvibe_offline_mp3_player/pages/home/sections/top_listen_section.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/music_player_service.dart';
import 'package:xvibe_offline_mp3_player/view%20models/acoustic_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/chaotic_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/chill_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/energetic_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/home_page_view_model.dart';
import 'package:xvibe_offline_mp3_player/pages/home/sections/energetic_section.dart';
import 'package:xvibe_offline_mp3_player/view%20models/recent_log_songs_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/road_trip_vibe_view_model.dart';
import 'sections/recent_tracks_section.dart';
import 'sections/road_trip_section.dart';
import '../../utils/app_text_theme.dart';

class HomePage extends StatefulWidget{
   const HomePage({super.key});

   @override
   State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    _initViewModelsDataSource();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final homePageViewModel = context.read<HomePageViewModel>();
    if (homePageViewModel.refresh()) {
      Future.microtask(() async {
        await _initViewModelsDataSource();
        homePageViewModel.setRefresh(false);
      });
    }
  }

  Future<void> _initViewModelsDataSource() async {
    await Future.wait([
      context.read<RoadTripVibeViewModel>().initialize(),
      context.read<RecentLogSongsViewModel>().initialize(),
      context.read<EnergeticVibeViewModel>().initialize(),
      context.read<ChillVibeViewModel>().initialize(),
      context.read<AcousticVibeViewModel>().initialize(),
      context.read<ChaoticVibeViewModel>().initialize(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final IMusicPlayerService musicPlayerService = context.watch<MusicPlayerService>();
    context.watch<HomePageViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: Theme.of(context).textTheme.pageLabel),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const  RoadTripSection(),
              const SizedBox(height: 15),
              const RecentTracksSection(),
              const EnergeticSection(),
              const ChillVibeSection(),
              const MixVibeSection(),
              const TopListenSection(),
              const AcousticVibeSection(),
              const ChaoticVibeSection(),
              StreamBuilder(
                stream: musicPlayerService.playerSequenceStateStream(), 
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  int? index;

                  if (state != null) {
                    index = state.currentIndex;
                  }

                  return SizedBox(height: index != null ? 170 : 70);
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
