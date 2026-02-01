import 'package:flutter/material.dart';

import '../utils/app_text_theme.dart';

class VerticalCard extends StatelessWidget {
  final String songTitle;
  final String songVibe;

  const VerticalCard({
    super.key, 
    required this.songTitle, 
    required this.songVibe
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            image: DecorationImage(
              image: AssetImage("assets/music_card_default.jpeg")
            )
          ),
        ),
        SizedBox(height: 10),
        Text(
          songVibe, 
          maxLines: 1, 
          style: Theme.of(context).textTheme.cardGenre),
        Text(
          songTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis, 
          style: Theme.of(context).textTheme.verticalCardTitle)
      ])
    );
  }
}