import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/view%20models/browse_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_browse_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/browse/browse_catalog_grid_card.dart';
import '../../utils/app_text_theme.dart';

class BrowseCatalogGridView extends StatelessWidget {
  static final List<Color> _colors = [
    Colors.teal,
    Colors.lightBlue,
    Colors.deepOrangeAccent,
    Colors.indigoAccent,
    Colors.yellowAccent
  ];

  const BrowseCatalogGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final IBrowseVibeViewModel browseVibeViewModel = context.watch<BrowseVibeViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(
            "Catalogs",
            style: Theme.of(context).textTheme.sectionLabel,
          ),
        ),
        SizedBox(
          height: 1 * MediaQuery.of(context).size.height,
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.5,
            children: List.generate(browseVibeViewModel.getVibes.length, (index) {

              return BrowseCatalogGridCard(
                vibe: browseVibeViewModel.getVibes[index],
                playlistId: browseVibeViewModel.getVibesPlaylistId[index],
                color: _colors[index],
              );
            }),
          ),
        ),
      ],
    );
  }
}
