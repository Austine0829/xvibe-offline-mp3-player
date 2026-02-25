import 'package:flutter/material.dart';

class SwipableMusicPlayer extends StatefulWidget {
  const SwipableMusicPlayer({super.key});

  @override
  State<SwipableMusicPlayer> createState() => _SwipableMusicPlayerState();
}

class _SwipableMusicPlayerState extends State<SwipableMusicPlayer> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 1,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(color: Colors.black),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: ListView(
            controller: scrollController,
            children: [
              Align(
                alignment: AlignmentGeometry.topCenter,
                child: const Text(
                  "Now playing...",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40, bottom: 25),
                child: Image.asset(
                  "assets/music_card_default.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                "ALLDAYPROJECT - Look at me",
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
              Text("Chill", style: TextStyle(color: Colors.grey, fontSize: 14)),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 1,
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.grey,
                  thumbColor: Colors.deepOrangeAccent,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                ),
                child: Slider(
                  max: 100,
                  min: 0,
                  padding: EdgeInsets.only(
                    left: 0,
                    right: 0,
                    top: 15
                  ),
                  value: 50,
                  onChanged: (value) {},
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("0:50", style: TextStyle(color: Colors.grey),),
                  Text("4:10", style: TextStyle(color: Colors.grey),)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.shuffle,
                      color: const Color.fromRGBO(158, 158, 158, 1),
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.skip_previous,
                      color: Colors.grey,
                      size: 50,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.pause_circle,
                      color: Colors.white,
                      size: 70,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.skip_next, color: Colors.white, size: 50),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.repeat, color: Colors.grey, size: 30),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
