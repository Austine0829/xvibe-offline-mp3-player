import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/constants/hive_keys.dart';
import 'package:xvibe_offline_mp3_player/data/application_database.dart';
import 'package:xvibe_offline_mp3_player/data/repositories/playlist_repository.dart';
import 'package:xvibe_offline_mp3_player/data/repositories/playlist_song_repository.dart';
import 'package:xvibe_offline_mp3_player/data/repositories/song_log_repository.dart';
import 'package:xvibe_offline_mp3_player/data/repositories/song_repository.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/pages/analytics/analytics_page.dart';
import 'package:xvibe_offline_mp3_player/pages/browse/browse_page.dart';
import 'package:xvibe_offline_mp3_player/pages/home/home_page.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_session_cache_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/session_cache_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/vibe_classifier_service.dart';
import 'package:xvibe_offline_mp3_player/view%20models/acoustic_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/analytics_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/browse_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/chaotic_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/chill_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/home_page_view_model.dart';
import 'package:xvibe_offline_mp3_player/pages/playlist/playlist_page.dart';
import 'package:xvibe_offline_mp3_player/services/home/labeling_service.dart';
import 'package:xvibe_offline_mp3_player/services/playlist/playlist_song_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_scanning_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/media_store_music_scanning_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/playlist/playlist_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/song_log_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/song_service.dart';
import 'package:xvibe_offline_mp3_player/view%20models/energetic_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/mix_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/playlist_song_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/playlist_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/recent_log_songs_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/road_trip_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/top_listen_log_song_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/mini_music_player/mini_music_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();  
  Hive.registerAdapter(SongAdapter());
  await Hive.openBox(HiveKeys.queueCache);

  final ApplicationDatabase applicationDatabase = ApplicationDatabase();
  await applicationDatabase.initialize();
  final SongRepository songRepository = SongRepository(appDb: applicationDatabase);
  final SongService songService = SongService(songRepository);
  final MediaStoreMusicScanningService mediaStoreMusicScanningService = MediaStoreMusicScanningService();
  final ISessionCacheService sessionCacheService = SessionCacheService();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => LabelingService()),
        Provider(create: (_) => applicationDatabase),
        Provider(create: (_) => songRepository),
        Provider(create: (_) => PlaylistRepository(appDb: applicationDatabase)),
        Provider(create: (context) => PlaylistService(context.read<PlaylistRepository>())),
        Provider(create: (_) => PlaylistSongRepository(appDb: applicationDatabase)),
        Provider(create: (context) => PlaylistSongService(context.read<PlaylistSongRepository>())),
        Provider(create: (_) => SongLogRepository(appDb: applicationDatabase)),
        Provider(create: (_) => mediaStoreMusicScanningService),
        ChangeNotifierProvider(create: (_) => songService),
        ChangeNotifierProvider(create: (context) => MusicPlayerService(context.read<SongService>(), sessionCacheService)),
        ChangeNotifierProvider(create: (context) => SongLogService(
          context.read<SongLogRepository>(), context.read<MusicPlayerService>())
        ),
        ChangeNotifierProvider(create: (_) => HomePageViewModel()),
        ChangeNotifierProvider(create: (context) => RoadTripVibeViewModel(
          songService, context.read<MusicPlayerService>(), context.read<LabelingService>(), 
          context.read<PlaylistService>(), context.read<PlaylistSongService>(), context.read<HomePageViewModel>())
        ),
        ChangeNotifierProvider(create: (context) => RecentLogSongsViewModel(
          context.read<SongLogService>(), songService, context.read<PlaylistSongService>(), 
          context.read<MusicPlayerService>(), context.read<PlaylistService>())
        ),
        ChangeNotifierProvider(create: (context) => EnergeticVibeViewModel(
          songService, context.read<MusicPlayerService>(), context.read<LabelingService>(), 
          context.read<PlaylistService>(), context.read<PlaylistSongService>(), context.read<HomePageViewModel>())
        ),
        ChangeNotifierProvider(create: (context) => ChillVibeViewModel(
          songService, context.read<MusicPlayerService>(), context.read<LabelingService>(), 
          context.read<PlaylistService>(), context.read<PlaylistSongService>(), context.read<HomePageViewModel>())
        ),
        ChangeNotifierProvider(create: (context) => MixVibeViewModel(
          songService, context.read<MusicPlayerService>(), context.read<PlaylistService>(), 
          context.read<PlaylistSongService>(), context.read<HomePageViewModel>())
        ),
        ChangeNotifierProvider(create: (context) => TopListenLogSongViewModel(
          context.read<SongLogService>(), songService, context.read<PlaylistSongService>(), 
          context.read<MusicPlayerService>(), context.read<PlaylistService>())
        ),
        ChangeNotifierProvider(create: (context) => AcousticVibeViewModel(
          songService, context.read<MusicPlayerService>(),  context.read<LabelingService>() ,
          context.read<PlaylistService>(), context.read<PlaylistSongService>(), context.read<HomePageViewModel>())
        ),
        ChangeNotifierProvider(create: (context) => ChaoticVibeViewModel(
          songService, context.read<MusicPlayerService>(),  context.read<LabelingService>() ,
          context.read<PlaylistService>(), context.read<PlaylistSongService>(), context.read<HomePageViewModel>())
        ),
        ChangeNotifierProvider(create: (context) => PlaylistViewModel(context.read<PlaylistService>())),
        ChangeNotifierProvider(create: (context) => PlaylistSongViewModel(
          context.read<MusicPlayerService>(), context.read<PlaylistSongService>(), songService, context.read<PlaylistService>())
        ),
        ChangeNotifierProvider(create: (context) => BrowseVibeViewModel(
          context.read<MusicPlayerService>(), context.read<PlaylistSongService>(), songService, 
          context.read<PlaylistService>())
        ),
        ChangeNotifierProvider(create: (context) => AnalyticsViewModel(
          songService, context.read<PlaylistService>(), context.read<SongLogService>())
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
  late final ISongService _songService;
  late final IMusicScanningService _musicScanningService;

  int _currentPageIndex = 0;
  int analyticsKey = 0;
  bool _isInitialize = false;
  bool _isLoading = true;
  bool _isAllowed = false;
  int _labeledCount = 0;
  int _totalSongs = 0;
  
  late final AppLifecycleListener _lifecycleListener;
  bool _hasRequestedPermission = false;

  @override
  void initState() {
    super.initState();
    _initClassifier();

    _lifecycleListener = AppLifecycleListener(
    onResume: _onAppResumed,
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  Future<void> _onAppResumed() async {
    if (!_hasRequestedPermission) return;
    if (_isAllowed) return;

    final audio = await Permission.audio.status;
    if (audio.isGranted) {
      setState(() => _isAllowed = true);
      await _scanSongs();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_isInitialize) {
      _songService = context.read<SongService>();
      _musicScanningService = context.read<MediaStoreMusicScanningService>();
      _permission();
      _isInitialize = true;
    }
  }

  Future<void> _initClassifier() async {
    await VibeClassifierService.initialize();
  }

  Future<void> _permission() async {
  final audio = await Permission.audio.request();

    if (!audio.isGranted) {
       _hasRequestedPermission = true;
      await openAppSettings();
      setState(() => _isAllowed = false);
      return;
    }

    setState(() => _isAllowed = true);

    await _scanSongs();
  }

  Future<void> _scanSongs() async {
    try {
      List<Song> songs = await _musicScanningService.scanSongs();
      List<int> dbSongsId = await _songService.getSongsId();
      List<Song> filteredSongs = [];

      for (var song in songs) {
        if (dbSongsId.contains(song.id)) continue;
        filteredSongs.add(song);
      }

      setState(() {
        _totalSongs = filteredSongs.length;
      });

      for (var song in filteredSongs) {
        String predictedVibe = await VibeClassifierService.inference(song.path);
        Song updatedVibeSong = song.updateVibe(vibe: predictedVibe);
        song = updatedVibeSong;
        await _songService.addSong(song);
        
        setState(() {
          _labeledCount = _labeledCount + 1;
        });
      }

    } catch (e) {
      debugPrint('>>> Scan error: $e');
    } finally {
      await _songService.initializeAudioSources();
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAllowed && _isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.deepOrangeAccent,),
              SizedBox(height: 20,),
              Text("Generating labels... $_labeledCount out of $_totalSongs", style: TextStyle(color: Colors.white),)
            ],
          ),
        )
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
        extendBody: true,
        body: IndexedStack(
          index: _currentPageIndex,
          children: [
            const HomePage(),
            const PlaylistPage(),
            const BrowsePage(),
            AnalyticsPage(key: ValueKey(analyticsKey),),
          ],
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
                const analyticsPageIndex = 3;

                setState(() {
                  if (index == analyticsPageIndex) {
                    analyticsKey++;
                  }

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