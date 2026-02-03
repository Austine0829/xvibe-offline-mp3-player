import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/widgets/horizontal_card.dart';
import 'package:xvibe_offline_mp3_player/widgets/horizontal_text_and_text_button.dart';

class TopListenSection extends StatefulWidget {
  const TopListenSection({super.key});

  @override
  State<TopListenSection> createState() => _TopListenSection();
}

class _TopListenSection extends State<TopListenSection> {

  @override 
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       HorizontalTextAndTextButton(
        label: "Top Listen"
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