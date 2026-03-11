import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/sections/home/recent_tracks.dart';
import '../sections/home/road_trip.dart';
import '../utils/app_text_theme.dart';

// TODO: Remove the comment of other components after fixing the UI

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
              // EnergeticSection(),
              // ChillVibeSection(),
              // MixSection(),
              // TopListenSection(),
              // AcousticSection(),
              // ChaoticSection(),
              // SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }
}
