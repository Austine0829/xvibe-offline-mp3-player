import 'package:flutter/material.dart';
import '../sections/acoustic.dart';
import '../sections/chaotic.dart';
import '../sections/chill_vibe.dart';
import '../sections/energetic.dart';
import '../sections/home_banner.dart';
import '../sections/mix.dart';
import '../sections/recent_tracks.dart';
import '../sections/road_trip.dart';
import '../sections/top_listen.dart';
import '../utils/app_text_theme.dart';

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeBanner(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
              children: [
                RoadTripSection(),
                SizedBox(height: 15),
                RecentTracksSection(),
                EnergeticSection(),
                ChillVibeSection(),
                MixSection(),
                TopListenSection(),
                AcousticSection(),
                ChaoticSection(),
                SizedBox(height: 50)
              ])
            ) 
          ],
        ),
      ),
    );
  }
}