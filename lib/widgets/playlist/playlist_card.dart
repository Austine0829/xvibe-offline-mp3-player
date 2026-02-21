import 'package:flutter/material.dart';

class PlaylistCard extends StatelessWidget {
  final dynamic backgroundColor;
  final String textLabel;

  const PlaylistCard({
    super.key,
    required this.textLabel,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.only(top: 75),
        child: ListTile(title: Text(textLabel)),
      ),
    );
  }
}
