import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/data/application_database.dart';
import 'package:xvibe_offline_mp3_player/data/contracts/i_repository.dart';
import 'package:xvibe_offline_mp3_player/data/repositories/song_repository.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/pages/browse_page.dart';
import 'package:xvibe_offline_mp3_player/pages/home_page.dart';
import 'package:xvibe_offline_mp3_player/pages/playlist_page.dart';
import 'package:xvibe_offline_mp3_player/services/home/labeling_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_scanning_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/media_store_music_scanning_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/music_player_service.dart';

Future<void> permission(IRepository songRepository, IMusicScanningService musicScanningService) async {
  PermissionStatus audio = await Permission.audio.request();

  if (audio.isGranted) {
    List<Song> songs = await musicScanningService.scanSongs();

      for (var song in songs) {
        Song s = await songRepository.get(song.id!);

        if (s.id == song.id) continue;
          songRepository.add(song);
      }

  } else {
    openAppSettings();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  final ApplicationDatabase applicationDatabase = ApplicationDatabase();
  final SongRepository songRepository = SongRepository(appDb: applicationDatabase);
  final MediaStoreMusicScanningService mediaStoreMusicScanningService = MediaStoreMusicScanningService();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await permission(songRepository, mediaStoreMusicScanningService);

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => MusicPlayerService()),
        Provider(create: (_) => LabelingService()),
        Provider(create: (_) => applicationDatabase),
        Provider(create: (_) => songRepository)
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
        extendBody: true,
        body: IndexedStack(
          index: _currentPageIndex,
          children: _pages,
        ),
        bottomNavigationBar: Container(
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
      );
  }
}

// class Main extends StatefulWidget {
//   const Main({super.key});

//   @override
//   State<Main> createState() => _MainState();
// }

// class _MainState extends State<Main> {
//   int _currentPageIndex = 0;

//   final List<Widget> _pages = [
//     HomePage(),
//     PlaylistPage(),
//     BrowsePage(),
//     Text("Analytics"),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       body: _pages[_currentPageIndex],
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.7),
//               blurRadius: 30,
//               spreadRadius: 15,
//             ),
//           ],
//         ),
//         child: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: Colors.transparent,
//           selectedItemColor: Colors.white,
//           unselectedItemColor: Colors.white54,
//           elevation: 15,
//           currentIndex: _currentPageIndex,
//           onTap: (index) {
//             setState(() {
//               _currentPageIndex = index;
//             });
//           },
//           items: [
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.playlist_play),
//               label: "Playlist",
//             ),
//             BottomNavigationBarItem(icon: Icon(Icons.search), label: "Browse"),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.analytics),
//               label: "Analytics",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
