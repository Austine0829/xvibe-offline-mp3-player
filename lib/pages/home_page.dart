import 'package:flutter/material.dart';
import '../sections/home/acoustic.dart';
import '../sections/home/chaotic.dart';
import '../sections/home/chill_vibe.dart';
import '../sections/home/energetic.dart';
import '../sections/home/mix.dart';
import '../sections/home/recent_tracks.dart';
import '../sections/home/road_trip.dart';
import '../sections/home/top_listen.dart';
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