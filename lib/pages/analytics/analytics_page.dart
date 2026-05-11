import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/music_player_service.dart';
import 'package:xvibe_offline_mp3_player/widgets/analytics/cards_analytics.dart';
import 'package:xvibe_offline_mp3_player/widgets/analytics/vibes_percentages_pie_chart.dart';
import 'package:xvibe_offline_mp3_player/widgets/analytics/seven_span_days_listen_bar_chart.dart';
import 'package:xvibe_offline_mp3_player/utils/app_text_theme.dart';
import 'package:xvibe_offline_mp3_player/view%20models/analytics_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_analytics_view_model.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    final viewModel = context.read<AnalyticsViewModel>();
    Future.microtask(() async => await viewModel.initialize());
  }

  @override
  Widget build(BuildContext context) {
    final IAnalyticsViewModel analyticsViewModel = context
        .watch<AnalyticsViewModel>();
    final IMusicPlayerService musicPlayerService = context
        .watch<MusicPlayerService>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Analytics", style: Theme.of(context).textTheme.pageLabel),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardsAnalytics(analyticsViewModel: analyticsViewModel),
            VibesPercentagesPieChart(analyticsViewModel: analyticsViewModel),
            SevenSpanDaysListenBarChart(analyticsViewModel: analyticsViewModel),
            StreamBuilder(
              stream: musicPlayerService.playerSequenceStateStream(),
              builder: (context, snapshot) {
                final state = snapshot.data;
                int? index;

                if (state != null) {
                  index = state.currentIndex;
                }

                return SizedBox(height: index != null ? 150 : 50);
              },
            ),
          ],
        ),
      ),
    );
  }
}
