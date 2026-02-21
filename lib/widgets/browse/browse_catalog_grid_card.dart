import 'package:flutter/material.dart';

class BrowseCatalogGridCard extends StatelessWidget {
  final String textLabel;
  final MaterialColor color;

  const BrowseCatalogGridCard({
    super.key,
    required this.textLabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Align(
        alignment: AlignmentGeometry.bottomLeft,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text(textLabel, style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
