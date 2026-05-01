import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/pages/home/sections/acoustic_vibe_section.dart';
import 'package:xvibe_offline_mp3_player/pages/home/sections/chaotic_vibe_section.dart';
import 'package:xvibe_offline_mp3_player/pages/home/sections/chill_vibe_section.dart';
import 'package:xvibe_offline_mp3_player/pages/home/sections/mix_vibe_section.dart';
import 'package:xvibe_offline_mp3_player/view%20models/acoustic_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/chaotic_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/chill_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/energetic_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/home_page_view_model.dart';
import 'package:xvibe_offline_mp3_player/pages/home/sections/energetic_section.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_home_page_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/recent_tracks_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/road_trip_vibe_view_model.dart';
import 'sections/recent_tracks.dart';
import 'sections/road_trip.dart';
import '../../utils/app_text_theme.dart';

// TODO: Remove the comment of other components after fixing the UI

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final IHomePageViewModel homePageViewModel = context.watch<HomePageViewModel>();

    if (homePageViewModel.refresh() && context.mounted) {
      // ignore: use_build_context_synchronously
      Future.microtask(() async => await context.read<RoadTripVibeViewModel>().initialize());

      // ignore: use_build_context_synchronously
      Future.microtask(() async => await context.read<RecentTracksViewModel>().initialize());

      // ignore: use_build_context_synchronously
      Future.microtask(() async => await context.read<EnergeticVibeViewModel>().initialize());

      // ignore: use_build_context_synchronously
      Future.microtask(() async => await context.read<ChillVibeViewModel>().initialize());

      // ignore: use_build_context_synchronously
      Future.microtask(() async => await context.read<AcousticVibeViewModel>().initialize());

      // ignore: use_build_context_synchronously
      Future.microtask(() async => await context.read<ChaoticVibeViewModel>().initialize());

      homePageViewModel.setRefresh(false);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: Theme.of(context).textTheme.pageLabel),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              RoadTripSection(),
              SizedBox(height: 15),
              RecentTracksSection(),
              EnergeticSection(),
              ChillVibeSection(),
              MixVibeSection(),
              // TopListenSection(),
              AcousticVibeSection(),
              ChaoticVibeSection(),
              SizedBox(height: 110)
            ],
          ),
        ),
      ),
    );
  }
}
