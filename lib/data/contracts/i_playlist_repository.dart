import 'package:sqflite/sqflite.dart';
import 'package:xvibe_offline_mp3_player/models/playlist.dart';

abstract class IPlaylistRepository {
  // ignore: unused_field
  late final Future<Database> _db;

  Future<void> add(Playlist playlist);
  Future<List<Playlist>> getAll();
  Future<Playlist> get(String id);
  Future<void> update(String id, Playlist playlist);
  Future<void> delete(String id);
}