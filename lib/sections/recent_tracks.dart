import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/widgets/horizontal_card.dart';
import 'package:xvibe_offline_mp3_player/widgets/horizontal_text_and_text_button.dart';

class RecentTracksSection extends StatefulWidget {
  const RecentTracksSection({super.key});

  @override
  State<RecentTracksSection> createState() => _RecentTracksSectionState();
}

class _RecentTracksSectionState extends State<RecentTracksSection> {

  @override 
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HorizontalTextAndTextButton(
          label: "Recent Tracks" 
        ),
        ...List.generate(3, (index) => 
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: HorizontalCard(songTitle: "Music Card", songVibe: "Road Trip")
          )
        )
      ],
    );
  }
}