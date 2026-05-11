import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_analytics_view_model.dart';

class CardsAnalytics extends StatelessWidget {
  final IAnalyticsViewModel analyticsViewModel;

  const CardsAnalytics({
    super.key,
    required this.analyticsViewModel
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(15),
      child: Container(
        height: 300,
        decoration: BoxDecoration(color: Colors.grey[900]),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 178, 172),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Align(
                      alignment: AlignmentGeometry.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Song", style: TextStyle(fontSize: 18)),
                                Text("#", style: TextStyle(fontSize: 18)),
                              ],
                            ),
                            Text(analyticsViewModel.getSongCount, style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 13),
                Expanded(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 158, 255, 201),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Align(
                      alignment: AlignmentGeometry.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Playlist",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text("#", style: TextStyle(fontSize: 18)),
                              ],
                            ),
                            Text(analyticsViewModel.getPlaylistCount, style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 13),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 179, 255, 141),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Align(
                  alignment: AlignmentGeometry.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Listen", style: TextStyle(fontSize: 18)),
                            Text("#", style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        Text(analyticsViewModel.getListenCount, style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
