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
          PageRouteBuilder(
            pageBuilder: (_, _, _) => CatalogPage(
              playlistId: playlistId, 
              vibe: vibe
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final slide = Tween(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeOut));

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: animation.drive(slide),
                      child: child,
                    ),
                  );
                },
            transitionDuration: const Duration(milliseconds: 800),
          ),
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
