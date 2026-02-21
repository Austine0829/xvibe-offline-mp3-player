import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/widgets/browse/browse_catalog_grid_card.dart';
import '../../utils/app_text_theme.dart';

class BrowseCatalogGridView extends StatelessWidget {
  const BrowseCatalogGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(
            "Catalog",
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
            children: List.generate(5, (index) {
              return BrowseCatalogGridCard(
                textLabel: "Road Trip",
                color: Colors.lightBlue,
              );
            }),
          ),
        ),
      ],
    );
  }
}
