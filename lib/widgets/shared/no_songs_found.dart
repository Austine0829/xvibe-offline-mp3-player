import 'package:flutter/material.dart';

class NoSongsFound extends StatelessWidget {
  const NoSongsFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: double.infinity,
        maxHeight: 150
    ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white60
      ),
      child: Center(child: Text("No Songs Found"),),
    );
  }
}