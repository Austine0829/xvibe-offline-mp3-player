import 'package:flutter/material.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBanneState();
}

class _HomeBanneState extends State<HomeBanner> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/music_card_default.jpeg"),
            fit: BoxFit.cover
          )
        )
      ) 
    );
  }
}