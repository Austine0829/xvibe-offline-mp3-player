import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/data/application_database.dart';
import 'package:xvibe_offline_mp3_player/data/repositories/playlist_repository.dart';
import 'package:xvibe_offline_mp3_player/data/repositories/playlist_song_repository.dart';
import 'package:xvibe_offline_mp3_player/data/repositories/song_repository.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/pages/browse_page.dart';
import 'package:xvibe_offline_mp3_player/pages/home_page.dart';
import 'package:xvibe_offline_mp3_player/pages/playlist/playlist_page.dart';
import 'package:xvibe_offline_mp3_player/services/home/labeling_service.dart';
import 'package:xvibe_offline_mp3_player/services/playlist/playlist_song_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_scanning_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/media_store_music_scanning_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/playlist/playlist_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/song_service.dart';
import 'package:xvibe_offline_mp3_player/view%20models/playlist_song_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/playlist_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/road_trip_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/mini_music_player/mini_music_player.dart';

Future<void> permission(ISongService songService, IMusicScanningService musicScanningService) async {
  final audio = await Permission.audio.request();

  if (!audio.isGranted) {
    openAppSettings();
    return ;
  }

  List<Song> songs = await musicScanningService.scanSongs();

  for (var song in songs) {
    Song s = await songService.getSong(song.id);

    if (s.id == song.id) continue;
      await songService.addSong(song);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  final ApplicationDatabase applicationDatabase = ApplicationDatabase();
  final SongRepository songRepository = SongRepository(appDb: applicationDatabase);
  final SongService songService = SongService(songRepository);
  final MediaStoreMusicScanningService mediaStoreMusicScanningService = MediaStoreMusicScanningService();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await permission(songService, mediaStoreMusicScanningService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MusicPlayerService()),
        Provider(create: (_) => LabelingService()),
        Provider(create: (_) => applicationDatabase),
        Provider(create: (_) => songRepository),
        Provider(create: (_) => songService),
        Provider(create: (_) => PlaylistRepository(appDb: applicationDatabase)),
        Provider(create: (context) => PlaylistService(context.read<PlaylistRepository>())),
        Provider(create: (_) => PlaylistSongRepository(appDb: applicationDatabase)),
        Provider(create: (context) => PlaylistSongService(context.read<PlaylistSongRepository>())),
        ChangeNotifierProvider(create: (context) => RoadTripVibeViewModel(
          songService, context.read<MusicPlayerService>(), context.read<LabelingService>(), 
          context.read<PlaylistService>(), context.read<PlaylistSongService>())
        ),
        ChangeNotifierProvider(create: (context) => PlaylistViewModel(context.read<PlaylistService>())),
        ChangeNotifierProvider(create: (context) => PlaylistSongViewModel(
          context.read<MusicPlayerService>(), context.read<PlaylistSongService>(), songService, context.read<PlaylistService>())
        )
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, fontFamily: "Oswald"),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentPageIndex = 0;
  bool isInitialize = false;

  final List<Widget> _pages = [
    const HomePage(),
    const PlaylistPage(),
    const BrowsePage(),
    const Text("Analytics"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        extendBody: true,
        body: Padding(
          padding: EdgeInsetsGeometry.only(bottom: 45),
          child: IndexedStack(
            index: _currentPageIndex,
            children: _pages,
          ),
        ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MiniMusicPlayer(),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.7),
                  blurRadius: 30,
                  spreadRadius: 15,
                ),
              ],
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white54,
              elevation: 15,
              currentIndex: _currentPageIndex,
              onTap: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.playlist_play),
                  label: "Playlist",
                ),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: "Browse"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics),
                  label: "Analytics",
                ),
              ],
            ),
          ),
        ],
      ) 
    );
  }
}