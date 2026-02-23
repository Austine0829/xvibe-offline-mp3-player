import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/constants/label_name.dart';
import 'package:xvibe_offline_mp3_player/pages/songs_page.dart';
import 'package:xvibe_offline_mp3_player/widgets/home/horizontal_text_and_text_button.dart';
import '../../services/home/labeling_service.dart';
import '../../widgets/home/vertical_song_card.dart';

class RoadTripSection extends StatefulWidget {
  const RoadTripSection({super.key});

  @override
  State<RoadTripSection> createState() => _RoadTripSectionState();
}

class _RoadTripSectionState extends State<RoadTripSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HorizontalTextAndTextButton(
          textLabel: LabelingService.generate(LabelType.roadTrip),
          textButtonLabel: LabelName.showMore,
          callback: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (_) => SongsPage(pageLabel: "Road Trip")
              )
            );
          },
        ),
        Container(
          constraints: BoxConstraints(
            maxHeight: 200,
            maxWidth: double.infinity,
          ),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              return VerticalSongCard(
                songTitle: "My Music Card",
                songVibe: "Road Trip",
              );
            },
            separatorBuilder: (_, _) => SizedBox(width: 8),
            itemCount: 3,
          ),
        ),
      ],
    );
  }
}
