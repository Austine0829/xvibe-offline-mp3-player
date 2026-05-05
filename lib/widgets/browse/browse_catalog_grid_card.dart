import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/pages/browse/catalog_page.dart';

class BrowseCatalogGridCard extends StatelessWidget {
  final String vibe;
  final String playlistId;
  final Color color;

  const BrowseCatalogGridCard({
    super.key,
    required this.vibe,
    required this.playlistId,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => CatalogPage(
              playlistId: playlistId,
              vibe: vibe,
            )
          )
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          alignment: AlignmentGeometry.bottomLeft,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(vibe, style: TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }
}
