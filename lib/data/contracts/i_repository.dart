import 'package:sqflite/sqflite.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';

abstract class IRepository {
  // ignore: unused_field
  late final Future<Database> _db;

  Future<void> add(Song song);
  Future<List<Song>> getAll();
  Future<Song> get(int id);
  Future<void> update(int id, Song song);
  Future<void> delete(int id);
}