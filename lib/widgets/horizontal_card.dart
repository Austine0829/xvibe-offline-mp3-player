import 'package:flutter/material.dart';

import '../utils/app_text_theme.dart';

class HorizontalCard extends StatelessWidget {
  final String songTitle;
  final String songVibe;

  const HorizontalCard({
    super.key,
    required this.songTitle,
    required this.songVibe
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: 60,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/music_card_default.jpeg"),
                fit: BoxFit.cover
              ),
              borderRadius: BorderRadius.circular(6)
            ),
          ),
          SizedBox(width: 8),
          Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  songTitle, 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.horizontalCardTitle),
                Text(
                  songVibe, 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.cardGenre)
                ],
              ) 
            ),
            Spacer(),
            IconButton(
              onPressed: () {

            }, 
              icon: Icon(Icons.more_vert), 
              color: Colors.white
          )
        ]
      )
    );
  }
}